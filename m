Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0DSOum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:50:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab0DSOuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:50:40 -0400
Date: Mon, 19 Apr 2010 11:50:38 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] export new cpuid KVM_CAP
Message-ID: <20100419145037.GG14158@mothafucka.localdomain>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
 <1271356648-5108-2-git-send-email-glommer@redhat.com>
 <1271356648-5108-3-git-send-email-glommer@redhat.com>
 <1271356648-5108-4-git-send-email-glommer@redhat.com>
 <1271356648-5108-5-git-send-email-glommer@redhat.com>
 <4BCA04D2.1040300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCA04D2.1040300@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 17, 2010 at 09:58:26PM +0300, Avi Kivity wrote:
> On 04/15/2010 09:37 PM, Glauber Costa wrote:
> >Since we're changing the msrs kvmclock uses, we have to communicate
> >that to the guest, through cpuid. We can add a new KVM_CAP to the
> >hypervisor, and then patch userspace to recognize it.
> >
> >And if we ever add a new cpuid bit in the future, we have to do that again,
> >which create some complexity and delay in feature adoption.
> >
> >Instead, what I'm proposing in this patch is a new capability, called
> >KVM_CAP_X86_CPUID_FEATURE_LIST, that returns the current feature list
> >currently supported by the hypervisor. If we ever want to add or remove
> >some feature, we only need to tweak into the HV, leaving userspace untouched.
> >
> 
> Hm.  We need to update userspace anyway, since we don't like turning
> features on unconditionally (it breaks live migration into an older
> kernel).
Right now, we don't have any mechanism to disable, say, kvmclock cpuid bit
at userspace. But let's suppose we have: What's the difference between disabling
it in the way it is now, and disabling it with the method I am proposing?

All this ioctl say is: "Those are the current supported stuff in this HV".
It does not mandate userspace to expose all of this to the guest. It just saves
us from the job of creating yet another CAP for every bit we plan on including.

If we want to be conservative, we can keep everything but the things we know 
already disabled, in userspace.

