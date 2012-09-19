Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab2ISRXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:23:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932321Ab2ISRXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:23:05 -0400
Message-ID: <5059FF67.6050005@redhat.com>
Date: Wed, 19 Sep 2012 20:22:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] x86, kvm: use kernel_fpu_begin/end() in kvm_load/put_guest_fpu()
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>  <1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com>  <50599AE2.80601@redhat.com> <1348075103.26695.301.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1348075103.26695.301.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 08:18 PM, Suresh Siddha wrote:

> These routines (kvm_load/put_guest_fpu()) are already called with
> preemption disabled but as you mentioned, we don't want the preemption
> to be disabled completely between the kvm_load_guest_fpu() and
> kvm_put_guest_fpu().
> 
> Also KVM already has the preempt notifier which is doing the
> kvm_put_guest_fpu(), so something like the appended should address this.
> I will test this shortly.
> 

Note, we could also go in a different direction and make
kernel_fpu_begin() use preempt notifiers and thus make its users
preemptible.  But that's for a separate patchset.

-- 
error compiling committee.c: too many arguments to function
