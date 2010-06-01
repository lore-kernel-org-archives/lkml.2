Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab0FARBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:01:35 -0400
Received: from kroah.org ([198.145.64.141]:51125 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab0FARB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:01:27 -0400
Date: Tue, 1 Jun 2010 10:01:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.15
Message-ID: <20100601170123.GB23431@kroah.com>
References: <20100601170032.GA23431@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601170032.GA23431@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 47866f8..36fead3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .14
+EXTRAVERSION = .15
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index f672d51..9af5672 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -591,9 +591,9 @@ static int static_obj(void *obj)
 	 * percpu var?
 	 */
 	for_each_possible_cpu(i) {
-		start = (unsigned long) per_cpu_ptr(&__per_cpu_start, i);
-		end   = (unsigned long) per_cpu_ptr(&__per_cpu_start, i)
-					+ PERCPU_ENOUGH_ROOM;
+		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
+		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
+					+ per_cpu_offset(i);
 
 		if ((addr >= start) && (addr < end))
 			return 1;
diff --git a/kernel/module.c b/kernel/module.c
index a4aae35..dfa33e8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -555,7 +555,7 @@ static void percpu_modcopy(void *pcpudest, const void *from, unsigned long size)
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		memcpy(per_cpu_ptr(pcpudest, cpu), from, size);
+		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
 }
 
 #else /* ... !CONFIG_SMP */
