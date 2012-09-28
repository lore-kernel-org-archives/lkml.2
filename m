Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab2I1OPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:15:18 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:45884 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898Ab2I1OPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:15:15 -0400
Message-ID: <5065B00A.4050107@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2012 19:41:22 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: habanero@linux.vnet.ibm.com
CC: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com> <1348490165.11847.58.camel@twins> <50606050.309@linux.vnet.ibm.com> <1348494895.11847.64.camel@twins> <50606B33.1040102@linux.vnet.ibm.com> <5061B437.8070300@linux.vnet.ibm.com> <5064101A.5070902@redhat.com> <50643745.6010202@linux.vnet.ibm.com> <506440AF.9080202@redhat.com> <506537C7.9070909@linux.vnet.ibm.com> <1348832438.5551.5.camel@oc6622382223.ibm.com>
In-Reply-To: <1348832438.5551.5.camel@oc6622382223.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092814-3864-0000-0000-000004D56A50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 05:10 PM, Andrew Theurer wrote:
> On Fri, 2012-09-28 at 11:08 +0530, Raghavendra K T wrote:
>> On 09/27/2012 05:33 PM, Avi Kivity wrote:
>>> On 09/27/2012 01:23 PM, Raghavendra K T wrote:
>>>>>
[...]
>>>
>>> Also there may be a lot of false positives (deferred preemptions even
>>> when there is no contention).
>
> It will be interesting to see how this behaves with a very high lock
> activity in a guest.  Once the scheduler defers preemption, is it for a
> fixed amount of time, or does it know to cut the deferral short as soon
> as the lock depth is reduced [by x]?

Design/protocol that Vatsa, had in mind was something like this:

- scheduler does not give a vcpu holding lock forever, it may give one
chance that would give only few ticks. In addition to giving chance,
scheduler also sets some indication that he has been given chance.

- vcpu once he release (all) the lock(s), if it had given chance,
it should clear that (ACK), and relinquish the cpu.




