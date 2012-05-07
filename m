Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2EGUnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:43:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:42111 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab2EGUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:43:29 -0400
Date: Mon, 7 May 2012 22:43:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 18/18] task_allocator: Use config switches instead of
 magic defines
In-Reply-To: <20120507203216.GC10521@merkur.ravnborg.org>
Message-ID: <alpine.LFD.2.02.1205072243110.6271@ionos>
References: <20120505150007.543515803@linutronix.de> <20120505150142.371309416@linutronix.de> <20120507203216.GC10521@merkur.ravnborg.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012, Sam Ravnborg wrote:

> On Sat, May 05, 2012 at 03:05:48PM -0000, Thomas Gleixner wrote:
> > Replace __HAVE_ARCH_TASK_ALLOCATOR and __HAVE_ARCH_THREAD_ALLOCATOR
> > with proper config switches.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Tony Luck <tony.luck@intel.com>
> 
> > Index: tip/arch/sparc/include/asm/thread_info_32.h
> > ===================================================================
> > --- tip.orig/arch/sparc/include/asm/thread_info_32.h
> > +++ tip/arch/sparc/include/asm/thread_info_32.h
> > @@ -80,8 +80,6 @@ register struct thread_info *current_thr
> >   */
> >  #define THREAD_INFO_ORDER  1
> >  
> > -#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
> > -
> >  BTFIXUPDEF_CALL(struct thread_info *, alloc_thread_info_node, int)
> >  #define alloc_thread_info_node(tsk, node) BTFIXUP_CALL(alloc_thread_info_node)(node)
> 
> On the sparc mailing list we have discussed to drop
> support for sun4c - and decided to do so.
> With sun4c dropped sparc32 will be able to use the
> generic variant too.
> 
> I will take care to introduce the generic variant
> when sparc32 is ready.

Nice :)
