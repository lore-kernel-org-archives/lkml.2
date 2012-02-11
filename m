Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab2BKCMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 21:12:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40812 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab2BKCL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 21:11:59 -0500
MIME-Version: 1.0
In-Reply-To: <1328901567.25989.51.camel@laptop>
References: <1328560933-3037-1-git-send-email-venki@google.com>
	<1328901567.25989.51.camel@laptop>
Date: Fri, 10 Feb 2012 18:11:58 -0800
Message-ID: <CABeCy1aUj9MM8YabvvQCYYFm4FNMsomU3PZ1ZyoKikL9hnc9uQ@mail.gmail.com>
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
From: Venki Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 11:19 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-02-06 at 12:42 -0800, Venkatesh Pallipadi wrote:
>> smp_call_function_single and ttwu_queue_remote sends unconditional IPI
>> to target CPU. However, if the target CPU is in mwait based idle, we can
>> do IPI-less wakeups using the magical powers of monitor-mwait.
>
> So I was thinking, why not change native_smp_send_reschedule() and
> native_send_call_func_single_ipi() and keep the change entirely inside
> the arch?
>
> Ideally its only APIC/idle that know about this detail, the scheduler
> (or other consumers) really don't care about how the other cpu comes to
> run the callback.
>

OK. Moving most of this into arch code will be cleaner. But, Yong
mentioned in this thread that he was looking to do something similar
on MIPS. So, we may end up with some code duplication though..
