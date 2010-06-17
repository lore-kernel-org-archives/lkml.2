Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0FQHEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 03:04:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752996Ab0FQHEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 03:04:40 -0400
Date: Thu, 17 Jun 2010 00:04:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: avoid using smp_processor_id() in preemptible
 code (nr_iowait_cpu) v4
Message-Id: <20100617000431.ed186403.akpm@linux-foundation.org>
In-Reply-To: <20100616235907.eb11dfcc.akpm@linux-foundation.org>
References: <20100614140941.GA3581@swordfish.minsk.epam.com>
	<20100614073853.6fa2f91f@infradead.org>
	<20100614145439.GA3448@swordfish.minsk.epam.com>
	<20100614080154.7d6a71fc@infradead.org>
	<20100614151735.GB3448@swordfish.minsk.epam.com>
	<20100614204021.52c50cdc@infradead.org>
	<20100615061927.GA3312@swordfish>
	<20100615072435.5a47d850@infradead.org>
	<20100615145029.GB3967@swordfish.minsk.epam.com>
	<20100615080808.6286448b@infradead.org>
	<20100617062950.GA3979@swordfish>
	<20100616235907.eb11dfcc.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 23:59:07 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> So how does this look?  If "OK" then would you be able to test it please?

I saw it first!


fix !CONFIG_TICK_ONESHOT

--- a/include/linux/tick.h~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix
+++ a/include/linux/tick.h
@@ -71,7 +71,6 @@ struct tick_sched {
 };
 
 extern void __init tick_init(void);
-extern void __init tick_sched_init(void);
 extern int tick_is_oneshot_available(void);
 extern struct tick_device *tick_get_device(int cpu);
 
@@ -93,6 +92,9 @@ extern struct cpumask *tick_get_broadcas
 
 #  ifdef CONFIG_TICK_ONESHOT
 extern struct cpumask *tick_get_broadcast_oneshot_mask(void);
+extern void __init tick_sched_init(void);
+#  else
+static inline void tick_sched_init(void) { }
 #  endif
 
 # endif /* BROADCAST */
_

