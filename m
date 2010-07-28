Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab0G1UnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:43:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab0G1UnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:43:10 -0400
Date: Wed, 28 Jul 2010 16:42:26 -0400
From: Jason Baron <jbaron@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 00/12] jump label v10
Message-ID: <20100728204225.GB28992@redhat.com>
References: <cover.1280263065.git.jbaron@redhat.com> <20100728.123427.63008085.davem@davemloft.net> <20100728201459.GA28992@redhat.com> <20100728.132427.35841081.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728.132427.35841081.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 01:24:27PM -0700, David Miller wrote:
> > Patches are against Ingo's latest -tip tree. 
> 
> After applying patch #5:
> 
> kernel/kprobes.c: In function 'register_kprobe':
> kernel/kprobes.c:1145:6: error: implicit declaration of function 'jump_label_text_reserved'
> make[1]: *** [kernel/kprobes.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make: *** [kernel] Error 2

ok,

Not sure exactly what your .config is, but pulling in jump_label.h
explicitly into kprobes.c should fix that. if it doesn't please post
your .config. 


diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 2f9bea6..a53bff3 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -47,6 +47,7 @@
 #include <linux/memory.h>
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
+#include <linux/jump_label.h>
 
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>

thanks,

-Jason
