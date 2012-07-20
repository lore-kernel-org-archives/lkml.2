Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2GTUhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 16:37:50 -0400
Received: from relay.parallels.com ([195.214.232.42]:47546 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2GTUhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 16:37:48 -0400
From: Vladimir Davydov <VDavydov@parallels.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 21 Jul 2012 00:37:36 +0400
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
Thread-Topic: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
Thread-Index: Ac1mt3/UXTJps8GBQ+mEC11n0U9fLg==
Message-ID: <DE11821E-06DD-4ED9-B54F-564CDC6EF5B5@parallels.com>
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com>
 <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
 <50099361.6050300@zytor.com>
 <2764CF11-A5E5-4C8D-A2EE-69491D2864C3@parallels.com>
 <5009BD48.80204@zytor.com>
In-Reply-To: <5009BD48.80204@zytor.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 21, 2012, at 12:19 AM, H. Peter Anvin wrote:

> On 07/20/2012 11:21 AM, Vladimir Davydov wrote:
>>> 
>>> I am a bit concerned about this patch:
>>> 
>>> 1. it silently changes existing behavior.
>> 
>> Yes, but who needs the current implementation of 'clearcpuid' which,
>> in fact, just hides flags in /proc/cpuinfo while userspace apps will
>> see and consequently use all CPU features?
> 
> Anyone who wants to disable a feature from the kernel, specifically.
> 

Another option then?

>> So, I think it logically extends the existing behavior.
>> 
>>> 2. even on enabled hardware, only some of the bits are maskable.
>> 
>> The patch makes only words 0, 1, 4, 6 maskable, but words 3, 7, 8 are Linux-defined, words 2 and 5 are Transmeta-, Centaur-, etc- defined, and word 9 contains some bizarre Intel CPU features. Thus, it is words 0, 1, 4, 6 that contain useful information for most hardware models.
> 
> "Bizarre"?  New features, perhaps.

All right, new :-)

If the features are widely used, they'll provide a way of masking them either I guess.

AFAIK, Intel added CPUID faulting for their newest 'Ivy Bridge' models, which allows masking all CPUID functions. Unfortunately, I don't have such a CPU. But later this feature can be utilized and wired into the code.

Anyway, masking of at least some of the features would be better than lacking of the ability at all, wouldn't it? Another question whether the kernel should report errors/warnings if a particular feature can't be masked.

> 
>> If you ask about some Intel CPUs that can't mask CPUID function 0x80000001, this function describes AMD-specific features, and I bet those Intel CPUs just don't have them at all and thus have nothing to mask.
> 
> Not quite.
> 
> 	-hpa
> 
> 
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> 
> 

