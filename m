Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab2IXPwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:52:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:41211 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2IXPw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:52:29 -0400
Message-ID: <1348501929.11847.81.camel@twins>
Subject: Re: [PATCH RFC 2/2] kvm: Be courteous to other VMs in overcommitted
 scenario in PLE handler
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
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
Date: Mon, 24 Sep 2012 17:52:09 +0200
In-Reply-To: <50607F9B.7090701@redhat.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
	  <20120921120019.27611.66093.sendpatchset@codeblue>
	  <50607BBE.8070507@redhat.com> <1348500861.11847.72.camel@twins>
	 <50607F9B.7090701@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 17:43 +0200, Avi Kivity wrote:
> Wouldn't this correspond to the scheduler interrupt firing and causing a
> reschedule?  I thought the timer was programmed for exactly the point in
> time that CFS considers the right time for a switch.  But I'm basing
> this on my mental model of CFS, not CFS itself. 

No, we tried this for hrtimer kernels for a while, but programming
hrtimers the whole time (every actual task-switch) turns out to be far
too expensive. So we're back to HZ ticks and 'polling' the preemption
state.

Even if we remove all the hrtimer infrastructure overhead (can do with a
few hacks) setting the hardware requires going out to the LAPIC, which
is stupid slow.

Some hardware actually has fast/reliable/usable timers, sadly none of it
is popular.
