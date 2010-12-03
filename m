Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab0LCBSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 20:18:38 -0500
Received: from sous-sol.org ([216.99.217.87]:34865 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758247Ab0LCBSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 20:18:37 -0500
Date: Thu, 2 Dec 2010 17:18:10 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/3] kvm: keep track of which task is running a KVM
 vcpu
Message-ID: <20101203011810.GV10050@sequoia.sous-sol.org>
References: <20101202144129.4357fe00@annuminas.surriel.com>
 <20101202144324.4a79263b@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202144324.4a79263b@annuminas.surriel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel (riel@redhat.com) wrote:
> Keep track of which task is running a KVM vcpu.  This helps us
> figure out later what task to wake up if we want to boost a
> vcpu that got preempted.
> 
> Unfortunately there are no guarantees that the same task
> always keeps the same vcpu, so we can only track the task
> across a single "run" of the vcpu.

So shouldn't it confine to KVM_RUN?  The other vcpu_load callers aren't
always a vcpu in a useful runnable state.
