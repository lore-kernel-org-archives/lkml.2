Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab0HTXsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 19:48:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab0HTXsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 19:48:16 -0400
Date: Sat, 21 Aug 2010 09:47:59 +1000
From: Neil Brown <neilb@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
        npiggin@suse.de, hooanon05@yahoo.co.jp, bfields@fieldses.org,
        miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
Message-ID: <20100821094759.24a6dc37@notabene>
In-Reply-To: <1282310729.2605.989.camel@laptop>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100820083057.GA10039@infradead.org>
	<20100820195303.20b17210@notabene>
	<1282310729.2605.989.camel@laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 15:25:29 +0200
Peter Dijkstra <peter@infradead.org> wrote:

> On Fri, 2010-08-20 at 19:53 +1000, Neil Brown wrote:
> > With futexes we suddenly get a file descriptor for something we could never
> > get a file descriptor on before and that doesn't seem to be a problem. 
> 
> FWIW
> 
> commit 82af7aca56c67061420d618cc5a30f0fd4106b80
> Author: Eric Sesterhenn <snakebyte@gmx.de>
> Date:   Fri Jan 25 10:40:46 2008 +0100
> 
>     Removal of FUTEX_FD

Interesting - thanks.

OK, adjust my argument to reference signalfd, timerfs and pollfd.

I haven't looked at that code before - "anon_inode_getfd" gives you an fd on
an inode for which 
    (stat.st_mode & S_IFMT) == 0
Cool!  They have no format at all :-)

NeilBrown
