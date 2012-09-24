Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab2IXPnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:43:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab2IXPnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:43:41 -0400
Message-ID: <50607F9B.7090701@redhat.com>
Date: Mon, 24 Sep 2012 17:43:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 2/2] kvm: Be courteous to other VMs in overcommitted
 scenario in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue>  <20120921120019.27611.66093.sendpatchset@codeblue>  <50607BBE.8070507@redhat.com> <1348500861.11847.72.camel@twins>
In-Reply-To: <1348500861.11847.72.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 05:34 PM, Peter Zijlstra wrote:
> On Mon, 2012-09-24 at 17:26 +0200, Avi Kivity wrote:
>> I think this is a no-op these (CFS) days.  To get schedule() to do
>> anything, you need to wake up a task, or let time pass, or block.
>> Otherwise it will see that nothing has changed and as far as it's
>> concerned you're still the best task to be running (otherwise it
>> wouldn't have picked you in the first place). 
> 
> Time could have passed enough before calling this that there's now a
> different/more eligible task around to schedule.

Wouldn't this correspond to the scheduler interrupt firing and causing a
reschedule?  I thought the timer was programmed for exactly the point in
time that CFS considers the right time for a switch.  But I'm basing
this on my mental model of CFS, not CFS itself.

> Esp. for a !PREEMPT kernel this is could be significant.


-- 
error compiling committee.c: too many arguments to function
