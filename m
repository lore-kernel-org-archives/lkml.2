Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab2LVRoD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 12:44:03 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:42945 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2LVRn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 12:43:59 -0500
MIME-Version: 1.0
In-Reply-To: <1356102354.5896.103.camel@gandalf.local.home>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
	<1356028391-14427-4-git-send-email-fweisbec@gmail.com>
	<1356102354.5896.103.camel@gandalf.local.home>
Date: Sat, 22 Dec 2012 18:43:58 +0100
Message-ID: <CAFTL4hxU+fTTm-82SUbitgfhhafr+THXWb4=a3CFXqPNS_5p5g@mail.gmail.com>
Subject: Re: [PATCH 03/24] cputime: Allow dynamic switch between tick/virtual
 based cputime accounting
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/21 Steven Rostedt <rostedt@goodmis.org>:
>>@@ -601,6 +612,7 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
>>       thread_group_cputime(p, &cputime);
>>       cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
>>  }
>> +#endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
>
> Ah, the missing #endif gets added back here.

Right, I fixed the mid-state breakage for the next version.

Thanks for the report!
