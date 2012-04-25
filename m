Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab2DYDVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 23:21:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22865 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab2DYDVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 23:21:38 -0400
X-AuditID: cbfee61b-b7c1cae000004793-02-4f976dc071cd
Message-id: <4F976DC0.6060004@samsung.com>
Date: Wed, 25 Apr 2012 12:21:36 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH] Prevent wasting time to find out get_parent_ip
References: <4F969E53.9080307@samsung.com> <1335272025.28150.193.camel@twins>
 <4F9737CC.6010703@samsung.com> <20120424234513.GA11841@leaf>
In-reply-to: <20120424234513.GA11841@leaf>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 08:45 AM, Josh Triplett wrote:
> On Wed, Apr 25, 2012 at 08:31:24AM +0900, Minho Ban wrote:
>> On 04/24/2012 09:53 PM, Peter Zijlstra wrote:
>>> On Tue, 2012-04-24 at 21:36 +0900, Minho Ban wrote:
>>>> trace_preempt_on/off looks empty if PREEMPT_TRACER is off. But actually it is
>>>> spending time to find out get_parent_ip(even CALLER_ADDR for some ARCH) which is
>>>> in argument. This seems not fair for those who expect to do nothing but increase
>>>> or decrease count.
>>>
>>> You can do the same by making them CPP macros and adding a comment as to
>>> why they're macros instead of inlines..
>>>
>>
>> Thank you for pointing this out, certainly macros look better. I'll amend this.
> 
> As an alternative, how about making get_parent_ip and its called
> functions static inlines?  Then the compiler can eliminate them via dead
> code elimination.
> 
> Or, how about declaring get_parent_ip with the GCC "pure" attribute?
> That would tell GCC that it can safely eliminate calls to the function.
> 
> - Josh Triplett
> 

Thank you for alternative method, but I'm afraid this could not cover the CALLER_ADDR.

