Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab2BJTTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:19:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:35852 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2BJTTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:19:35 -0500
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1328560933-3037-1-git-send-email-venki@google.com>
References: <1328560933-3037-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 20:19:27 +0100
Message-ID: <1328901567.25989.51.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 12:42 -0800, Venkatesh Pallipadi wrote:
> smp_call_function_single and ttwu_queue_remote sends unconditional IPI
> to target CPU. However, if the target CPU is in mwait based idle, we can
> do IPI-less wakeups using the magical powers of monitor-mwait. 

So I was thinking, why not change native_smp_send_reschedule() and
native_send_call_func_single_ipi() and keep the change entirely inside
the arch?

Ideally its only APIC/idle that know about this detail, the scheduler
(or other consumers) really don't care about how the other cpu comes to
run the callback.

