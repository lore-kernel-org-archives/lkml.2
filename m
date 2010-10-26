Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446Ab0JZVYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 17:24:39 -0400
Received: from fieldses.org ([174.143.236.118]:56529 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774Ab0JZVYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 17:24:37 -0400
Date: Tue, 26 Oct 2010 17:24:34 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Bryan Schumaker <bjschuma@netapp.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: nfsd changes for 2.6.37
Message-ID: <20101026212433.GB1842@fieldses.org>
References: <20101026164549.GD19445@fieldses.org>
 <201010262218.36940.arnd@arndb.de>
 <4CC73BA6.1090407@netapp.com>
 <201010262255.40481.arnd@arndb.de>
 <AANLkTimPBqafDPxYpZjuym8+-yk4vKYTU15Js-Ux_e6Z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimPBqafDPxYpZjuym8+-yk4vKYTU15Js-Ux_e6Z@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 02:02:05PM -0700, Linus Torvalds wrote:
> On Tue, Oct 26, 2010 at 1:55 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > Finally, we can build fs/locks.c, nfs and nfsd with CONFIG_BKL
> > disabled.
> >
> > *not tested*
> 
> Ok, please make this so, so that we finally can effectively get rid of
> the BKL in this release (I don't really care about the random old
> drivers that may be "depends on BKL").
> 
> But that obviously requires at least some minimal testing by somebody
> who is using NFS heavily, including locking. I assume that the
> connectathon tests include file locking? And I presume that the nfs
> developers run those at least semi-regularly and could do at least
> that kind of minimal testing?

I did a couple connectathon runs just now with no obvious ill effects
except for some sleep-within-spinlock warnings in the lease code.

Yeah, connecthon does include lock tests, though they're just basic
correctness tests.

--b.
