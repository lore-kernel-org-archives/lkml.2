Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab2ISRZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:25:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:6255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778Ab2ISRZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:25:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,450,1344236400"; 
   d="scan'208";a="194630485"
Subject: Re: [PATCH 3/6] x86, kvm: use kernel_fpu_begin/end() in
 kvm_load/put_guest_fpu()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Sep 2012 10:25:33 -0700
In-Reply-To: <5059FF67.6050005@redhat.com>
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
	  <1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com>
	  <50599AE2.80601@redhat.com>
	 <1348075103.26695.301.camel@sbsiddha-desk.sc.intel.com>
	 <5059FF67.6050005@redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1348075534.26695.303.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 20:22 +0300, Avi Kivity wrote:
> On 09/19/2012 08:18 PM, Suresh Siddha wrote:
> 
> > These routines (kvm_load/put_guest_fpu()) are already called with
> > preemption disabled but as you mentioned, we don't want the preemption
> > to be disabled completely between the kvm_load_guest_fpu() and
> > kvm_put_guest_fpu().
> > 
> > Also KVM already has the preempt notifier which is doing the
> > kvm_put_guest_fpu(), so something like the appended should address this.
> > I will test this shortly.
> > 
> 
> Note, we could also go in a different direction and make
> kernel_fpu_begin() use preempt notifiers and thus make its users
> preemptible.  But that's for a separate patchset.

yep, but we need the fpu buffer to save/restore the kernel fpu state.

KVM already has those buffers allocated in the guest cpu state and hence
it all works out ok. But yes, we can revisit this in future.

thanks,
suresh


