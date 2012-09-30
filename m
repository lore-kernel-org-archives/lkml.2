Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab2I3IZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:25:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab2I3IZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:25:05 -0400
Message-ID: <506801D3.6040305@redhat.com>
Date: Sun, 30 Sep 2012 10:24:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: habanero@linux.vnet.ibm.com
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
References: <20120921115942.27611.67488.sendpatchset@codeblue>  <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com>  <1348490165.11847.58.camel@twins> <50606050.309@linux.vnet.ibm.com>  <1348494895.11847.64.camel@twins> <50606B33.1040102@linux.vnet.ibm.com>  <5061B437.8070300@linux.vnet.ibm.com> <5064101A.5070902@redhat.com>  <50643745.6010202@linux.vnet.ibm.com> <506440AF.9080202@redhat.com>  <506537C7.9070909@linux.vnet.ibm.com> <1348832438.5551.5.camel@oc6622382223.ibm.com>
In-Reply-To: <1348832438.5551.5.camel@oc6622382223.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 01:40 PM, Andrew Theurer wrote:
>> 
>> >>
>> >> IIRC, with defer preemption :
>> >> we will have hook in spinlock/unlock path to measure depth of lock held,
>> >> and shared with host scheduler (may be via MSRs now).
>> >> Host scheduler 'prefers' not to preempt lock holding vcpu. (or rather
>> >> give say one chance.
>> >
>> > A downside is that we have to do that even when undercommitted.
> 
> Hopefully vcpu preemption is very rare when undercommitted, so it should
> not happen much at all.

As soon as you're preempted, you're effectively overcommitted (even if
the system as a whole is undercommitted).  What I meant was that you
need to communicate your lock state to the host, and with fine-grained
locking this can happen a lot.  It may be as simple as an
increment/decrement instruction though.



-- 
error compiling committee.c: too many arguments to function
