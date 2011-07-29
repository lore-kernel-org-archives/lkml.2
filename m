Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab1G2OWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:22:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1G2OWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:22:31 -0400
Date: Fri, 29 Jul 2011 16:22:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@HansenPartnership.com, vitalivanov@gmail.com,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: sungem: fix compile failure caused by trivial #include
 consolidation
In-Reply-To: <20110729.071710.1864654661956416171.davem@davemloft.net>
Message-ID: <alpine.LNX.2.00.1107291620400.7300@pobox.suse.cz>
References: <1311948524.8190.39.camel@mulgrave> <alpine.LNX.2.00.1107291611030.7300@pobox.suse.cz> <20110729.071710.1864654661956416171.davem@davemloft.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011, David Miller wrote:

> >> This patch:
> >> 
> >> commit e44ba033c5654dbfda53461c9b1f7dd9bd1d198f
> >> Author: Vitaliy Ivanov <vitalivanov@gmail.com>
> >> Date:   Mon Jun 20 16:08:07 2011 +0200
> >> 
> >>     treewide: remove duplicate includes
> >> 
> >> Causes this compile failure on parisc:
> >> 
> >>   CC [M]  drivers/net/sungem.o
> >> drivers/net/sungem.c:49:22: error: asm/prom.h: No such file or directory
> >> make[2]: *** [drivers/net/sungem.o] Error 1
> >> 
> >> Only Sparc and PPC actually have the asm/prom.h include, so you can't
> >> consolidate it outside of the ifdefs.
> >> 
> >> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> >> 
> >> ---
> >> 
> >> This really shouldn't be happening with a trivial patch, since it's an
> >> obviously non-trivial transformation ... I assume the duplicate include
> >> checker isn't taking #ifdefs into account?
> > 
> > Ah, right. I am afraid this was simply overlooked. David, do you want me 
> > to take this, or will you fix that up in your tree? (I am fine either 
> > way).
> 
> Take what, although James signed off he seemd to simply repost your
> patch again rather than a fix, unless I'm reading it wrong :-)

Well yes, I think that James wanted to actually send a revert of that 
patch (as otherwise he wouldn't Sign-off on it) instead, right James? :)

> But yeah once there is a fix please push it.

So I'll revert that hunk with James' Reported-by, if there are no 
objections.

Thanks,

-- 
Jiri Kosina
SUSE Labs
