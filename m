Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab0E0QBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:01:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41075 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab0E0QBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:01:18 -0400
Date: Thu, 27 May 2010 17:01:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Erik van der Kouwe <vdkouwe@cs.vu.nl>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Fam Zheng <famcool@gmail.com>
Subject: Re: [PATCH] fs/minix: bugfix, number of indirect block ptrs per
 block depends on block size
Message-ID: <20100527160114.GH31073@ZenIV.linux.org.uk>
References: <4BFCF1EB.20709@cs.vu.nl>
 <20100526215442.GB3316@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526215442.GB3316@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 11:54:43PM +0200, Jan Kara wrote:
> > -	} else if ((block -= 7) < 256) {
> > -		offsets[n++] = 7;
> > +	} else if ((block -= DIRCOUNT) < INDIRCOUNT(sb)) {
>   This modification of 'block' in the if condition is a blatant violation
> of the kernel coding style.

The hell it is. [...said the guy who'd written it that way in the first place]
It _is_ idiomatic C for that kind of thing ("we've got several adjacent ranges,
find which one had we hit and how far from its start").
