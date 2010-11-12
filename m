Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab0KLTj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:39:26 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:38450 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab0KLTjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:39:25 -0500
/m: 
From: Richard Weinberger <richard@nod.at>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] um: mark CONFIG_HIGHMEM as broken
Date: Fri, 12 Nov 2010 20:39:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net
References: <1289517488-17628-1-git-send-email-richard@nod.at> <20101112112904.4b91d140.akpm@linux-foundation.org>
In-Reply-To: <20101112112904.4b91d140.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011122039.18025.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 12 November 2010, 20:29:04 schrieb Andrew Morton:
> On Fri, 12 Nov 2010 00:18:08 +0100
> 
> Richard Weinberger <richard@nod.at> wrote:
> > Currently CONFIG_HIGHMEM is broken on User Mode Linux.
> > I'm not sure if it worked ever.
> 
> What is "broken" about it?

Currently it does not even build.
This is very annoying when using "make randconfig".

And it was never stable.
See commit ce2d2aed:
commit ce2d2aedcc3ca582fed90f44970e8b3e4f006a7d
Author: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Date:   Wed Jan 18 17:42:59 2006 -0800

    [PATCH] uml: arch Kconfig menu cleanups
    
    *) mark as "EXPERIMENTAL" various items that either aren't very stable or
       that are actively crashing the setup of users which don't really need them
       (i.e.  HIGHMEM and 3-level pagetables on x86 - nobody needs either,
       everybody reports "I'm using it and getting trouble").
    
    *) move net/Kconfig near to the rest of network configurations, and
       drivers/block/Kconfig near "Block layer" submenu.
    
    *) it's useless and doesn't work well to force NETDEVICES on and to disable
       the prompt like it's done.  Better remove the attempt, and change that to a
       simple "default y if UML".
    
    *) drop the warning about "report problems about HPPFS" - it's redundant
       anyway, as that's the usual procedure, and HPPFS users are especially
       technical (i.e.  they know reporting bugs is _good_).
    
    Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
    Cc: Jeff Dike <jdike@addtoit.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

Thanks,
//richard
