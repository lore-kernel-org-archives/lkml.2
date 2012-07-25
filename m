Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab2GYLkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:40:04 -0400
Received: from relay.parallels.com ([195.214.232.42]:54177 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab2GYLkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:40:01 -0400
Message-ID: <500FDB0D.7010105@parallels.com>
Date: Wed, 25 Jul 2012 15:39:57 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Andre Przywara <andre.przywara@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Pavel Emelianov <xemul@parallels.com>,
        Konstantin Khorenko <khorenko@parallels.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120721103715.GA3632@aftab.osrc.amd.com> <500E4960.8040307@parallels.com> <500E5951.5020900@amd.com> <500E5CDF.5000504@parallels.com> <20120724101041.GA24739@aftab.osrc.amd.com> <500E8280.6050905@parallels.com> <500E9664.9030306@amd.com> <500FCAFB.4080301@parallels.com> <20120725104346.GA11152@aftab.osrc.amd.com>
In-Reply-To: <20120725104346.GA11152@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 02:43 PM, Borislav Petkov wrote:
> On Wed, Jul 25, 2012 at 02:31:23PM +0400, Vladimir Davydov wrote:
>> So, you prefer adding some filtering of /proc/cpuinfo into the
>> mainstream kernel
> That's already there right? And your 1/2 patch was making toggling those
> bits easier.
>
>> (not now, later, for LXC to work) instead of enabling clearcpuid boot
>> option to mask CPUID features? IMO, the latter would look clearer.
> Yes, but for reasons noted earlier, you cannot tweak all hardware CPUID
> features as you want them.
>
> So, having a software-only layer of tweaking /proc/cpuinfo or something
> different you can come up with is the only option you have.
>
> And even in that case, applications running in the container which
> execute CPUID might fail in a strange manner when the corresponding
> /proc/cpuinfo flag was cleared by you intentionally but the hardware
> CPUID flag is there. In such situations, issues like that should
> probably be sorted on a case-by-case basis I guess.
>
> Thanks.
>

We've agreed that tweaking CPUID bits in kernel is not a good idea and 
it is better to think about virtualization of /proc/cpuinfo and using 
msr-tools.

Thank you for your time and feedback.
