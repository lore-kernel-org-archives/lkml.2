Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab1LLWA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:00:56 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:33375 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab1LLWAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:00:52 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 12 Dec 2011 16:52:18 -0500
Subject: RE: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit tracepoints
Thread-Topic: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit
 tracepoints
Thread-Index: AcxOS+higUwf0B+dQeOFVLnSyEpgsRqx47Qw
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47BC@USINDEVS01.corp.hds.com>
References: <1311983978-10350-1-git-send-email-vnagarnaik@google.com>
 <1311983978-10350-3-git-send-email-vnagarnaik@google.com>
In-Reply-To: <1311983978-10350-3-git-send-email-vnagarnaik@google.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1112120233
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm interested in these tracepoints.
But this patch removed from -mm tree for some reason.

http://www.spinics.net/lists/mm-commits/msg85707.html

Do you plan to update it and push to upstream?

>@@ -859,7 +860,9 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
> 	 */
> 	exit_idle();
> 	irq_enter();
>+	trace_irq_vector_entry(LOCAL_TIMER_VECTOR);
> 	local_apic_timer_interrupt();
>+	trace_irq_vector_exit(LOCAL_TIMER_VECTOR);
> 	irq_exit();

It would be better if you add "regs" to the argument of trace_irq_vector_entry()/ trace_irq_vector_exit().

With "regs", we are able to know what part of the system CPUs execute periodically. 
This information really helps us find a root cause of system slowdown or hung up.

Seiji
