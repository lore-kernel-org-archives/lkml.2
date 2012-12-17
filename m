Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2LQJfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 04:35:01 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:37575 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2LQJfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 04:35:00 -0500
Message-ID: <50CEE736.8020000@itwm.fraunhofer.de>
Date: Mon, 17 Dec 2012 10:34:46 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Weidong Han <weidong.han@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [regression] 3.7 ends in APIC panic
References: <50CB3EAB.309@itwm.fraunhofer.de> <CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com> <CAE9FiQUyj65jB4bPkJQHGRZEkhOry736g362-m145vNYRRSdAQ@mail.gmail.com> <50CE0C82.20708@itwm.fraunhofer.de> <CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com> <50CE12EB.1050804@itwm.fraunhofer.de> <20121216191347.GB14678@liondog.tnic> <50CE24FE.3030409@itwm.fraunhofer.de> <20121216203913.GB14643@liondog.tnic>
In-Reply-To: <20121216203913.GB14643@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: UTF-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2012 09:39 PM, Borislav Petkov wrote:
> On Sun, Dec 16, 2012 at 08:46:06PM +0100, Bernd Schubert wrote:
>> Hmm, I read it the other way around - x2apic depends on interrupt
>> remapping, but interrupt remapping can be used without x2apic.
>
> Ok, you're right. X2APIC should depend on IRQ_REMAP:
> https://lwn.net/Articles/289881/
>
>> The help text of CONFIG_IRQ_REMAP also says "x2APIC enhancements or to
>> support platforms with CPU's having > 8 bit APIC ID, say Y." I guess
>> may CPU has the latter?
>
> I think it is what Yinghai said - you obviously need x2apic kernel
> support if you have IRQ_REMAP on.
>
>> Can the kernel panic a bit improved to help user to understand what
>> needs to be enabled?
>
> Well, your kernel enables IRQ_REMAP properly:
>
> [    0.031115] Enabled IRQ remapping in x2apic mode
>
> I guess at that stage we could probably check for x2apic support and
> scream loudly if it is not present... IMHO.
>

Hmm, I think that would the wrong place, as the initial 3.7.0 
configuration didn't have IRQ_REMAP enabled. And that was the reason why 
x2apic got disabled during the "make oldconfig" process...

Is this message an indication for missing x2apic?

"smpboot: weird, boot (#255) not listed by the BIOS"


Thanks,
Bernd

