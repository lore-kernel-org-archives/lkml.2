Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1IPU1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 16:27:06 -0400
Received: from kanga.kvack.org ([205.233.56.17]:49618 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab1IPU1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 16:27:05 -0400
X-Greylist: delayed 1126 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Sep 2011 16:27:05 EDT
Date: Fri, 16 Sep 2011 16:08:17 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Andres Freund <andres@anarazel.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, robertmhaas@gmail.com,
        pgsql-hackers@postgresql.org
Subject: Re: Improve lseek scalability v3
Message-ID: <20110916200817.GD28519@kvack.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <201109161616.50004.andres@anarazel.de> <20110916153620.GA9913@parisc-linux.org> <201109161927.34472.andres@anarazel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109161927.34472.andres@anarazel.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 07:27:33PM +0200, Andres Freund wrote:
> many tuples does the table have. Those statistics are only updated every now 
> and then though.
> So it uses those old stats to check how many tuples are normally stored on a 
> page and then uses that to extrapolate the number of tuples from the current 
> nr of pages (which is computed by lseek(SEEK_END) over the 1GB segements of a 
> table).
> 
> I am not sure how interested you are on the relevant postgres internals?

For such tables, can't Postgres track the size of the file internally?  I'm 
assuming it's keeping file descriptors open on the tables it manages, in 
which case when it writes to a file to extend it, the internally stored size 
could be updated.  Not making a syscall at all would scale far better than 
even a modified lseek() will perform.

Granted, I've not looked at the Postgres code at all.

		-ben
