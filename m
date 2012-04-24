Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab2DXXb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:31:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45357 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2DXXbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:31:25 -0400
X-AuditID: cbfee61a-b7b8eae00000534b-a3-4f9737cb537e
Message-id: <4F9737CC.6010703@samsung.com>
Date: Wed, 25 Apr 2012 08:31:24 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC/PATCH] Prevent wasting time to find out get_parent_ip
References: <4F969E53.9080307@samsung.com> <1335272025.28150.193.camel@twins>
In-reply-to: <1335272025.28150.193.camel@twins>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 09:53 PM, Peter Zijlstra wrote:
> On Tue, 2012-04-24 at 21:36 +0900, Minho Ban wrote:
>> trace_preempt_on/off looks empty if PREEMPT_TRACER is off. But actually it is
>> spending time to find out get_parent_ip(even CALLER_ADDR for some ARCH) which is
>> in argument. This seems not fair for those who expect to do nothing but increase
>> or decrease count.
> 
> You can do the same by making them CPP macros and adding a comment as to
> why they're macros instead of inlines..
> 

Thank you for pointing this out, certainly macros look better. I'll amend this.
