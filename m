Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab0LCP4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:56:09 -0500
Received: from sous-sol.org ([216.99.217.87]:44892 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751289Ab0LCP4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:56:08 -0500
Date: Fri, 3 Dec 2010 07:55:36 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Rik van Riel <riel@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/3] kvm: keep track of which task is running a KVM
 vcpu
Message-ID: <20101203155536.GB10050@sequoia.sous-sol.org>
References: <20101202144129.4357fe00@annuminas.surriel.com>
 <20101202144324.4a79263b@annuminas.surriel.com>
 <20101203011810.GV10050@sequoia.sous-sol.org>
 <4CF903A6.5050209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF903A6.5050209@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel (riel@redhat.com) wrote:
> On 12/02/2010 08:18 PM, Chris Wright wrote:
> >* Rik van Riel (riel@redhat.com) wrote:
> >>Keep track of which task is running a KVM vcpu.  This helps us
> >>figure out later what task to wake up if we want to boost a
> >>vcpu that got preempted.
> >>
> >>Unfortunately there are no guarantees that the same task
> >>always keeps the same vcpu, so we can only track the task
> >>across a single "run" of the vcpu.
> >
> >So shouldn't it confine to KVM_RUN?  The other vcpu_load callers aren't
> >always a vcpu in a useful runnable state.
> 
> Yeah, probably.  If you want I can move the setting of
> vcpu->task to kvm_vcpu_ioctl.

Or maybe setting in sched_out and unsetting in sched_in.
