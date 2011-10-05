Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab1JECqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 22:46:21 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:51829
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757450Ab1JECqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 22:46:20 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2dK1432N98dKzz1202hzz8275bhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4E8BC496.3040605@am.sony.com>
Date: Tue, 4 Oct 2011 19:44:38 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0.6-rt16
References: <alpine.LFD.2.02.1110042139350.18778@ionos>
In-Reply-To: <alpine.LFD.2.02.1110042139350.18778@ionos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/11 13:19, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.0.6-rt16 release.


Fix compile error for non-SMP.

Can be folded into rt-sched-postpone-actual-migration-disalbe-to-schedule.patch

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 kernel/sched.c |    2 	1 +	1 -	0 !
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4207,7 +4207,7 @@ static inline void schedule_debug(struct
 	schedstat_inc(this_rq(), sched_count);
 }
 
-#ifdef CONFIG_PREEMPT_RT_FULL
+#if defined(CONFIG_PREEMPT_RT_FULL) && defined(CONFIG_SMP)
 #define MIGRATE_DISABLE_SET_AFFIN	(1<<30) /* Can't make a negative */
 #define migrate_disabled_updated(p)	((p)->migrate_disable & MIGRATE_DISABLE_SET_AFFIN)
 #define migrate_disable_count(p)	((p)->migrate_disable & ~MIGRATE_DISABLE_SET_AFFIN)

