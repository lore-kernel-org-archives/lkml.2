Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab2ISR0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:26:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54156 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624Ab2ISR03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:26:29 -0400
Message-ID: <505A002E.6050304@zytor.com>
Date: Wed, 19 Sep 2012 10:26:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, andreas.herrmann3@amd.com, bp@amd64.org,
        robert.richter@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] x86, kvm: use kernel_fpu_begin/end() in kvm_load/put_guest_fpu()
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>  <1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com>  <50599AE2.80601@redhat.com> <1348075103.26695.301.camel@sbsiddha-desk.sc.intel.com> <5059FF67.6050005@redhat.com>
In-Reply-To: <5059FF67.6050005@redhat.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 10:22 AM, Avi Kivity wrote:
> 
> Note, we could also go in a different direction and make
> kernel_fpu_begin() use preempt notifiers and thus make its users
> preemptible.  But that's for a separate patchset.
> 

Where would you put the state if you were preempted?  You want to
allocate a full extra buffer for the kernel xstate for each thread just
in case?  ("Yes" is a valid answer to that question, but it is a fair
chunk of memory.)

	-hpa

