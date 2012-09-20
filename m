Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab2ITJg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:36:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab2ITJg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:36:26 -0400
Message-ID: <505AE385.3030600@redhat.com>
Date: Thu, 20 Sep 2012 12:36:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, andreas.herrmann3@amd.com, bp@amd64.org,
        robert.richter@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] x86, kvm: use kernel_fpu_begin/end() in kvm_load/put_guest_fpu()
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>  <1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com>  <50599AE2.80601@redhat.com> <1348075103.26695.301.camel@sbsiddha-desk.sc.intel.com> <5059FF67.6050005@redhat.com> <505A002E.6050304@zytor.com>
In-Reply-To: <505A002E.6050304@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 08:26 PM, H. Peter Anvin wrote:
> On 09/19/2012 10:22 AM, Avi Kivity wrote:
>> 
>> Note, we could also go in a different direction and make
>> kernel_fpu_begin() use preempt notifiers and thus make its users
>> preemptible.  But that's for a separate patchset.
>> 
> 
> Where would you put the state if you were preempted?  You want to
> allocate a full extra buffer for the kernel xstate for each thread just
> in case?  ("Yes" is a valid answer to that question, but it is a fair
> chunk of memory.)

kernel_fpu_begin() could receive a pointer to a struct fpu, with
fpu->state either preallocated by the caller, or allocated by
kernel_fpu_begin() itself.

-- 
error compiling committee.c: too many arguments to function
