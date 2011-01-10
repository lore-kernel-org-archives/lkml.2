Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1AJOEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:04:24 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55877 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1AJOEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:04:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zjuw4v/4jukQAl47PE3/yo8aRM8gDUq1NLndPhW5hKPb+RhXBuklL1/VraY5Fm0119
         EqkErZVBNEUeCoTuNRy+18IB3x5Ao86vRIiCYnzw347iY4M8haVxLEavY6L9l9gWEy7B
         XMddgLzx5Q6/STXeS9TSRg/lY9g9gWRQwyV/w=
MIME-Version: 1.0
In-Reply-To: <4D2AD7FB.8030906@gmail.com>
References: <AANLkTimb7wj0oP_ctr7Ergf4VmVFTMHU3QCCaLcPE5Q9@mail.gmail.com>
	<20110109093926.GB542@elte.hu>
	<AANLkTik=bg0KY8Oygxem+SdEaPHwBtHRHOcz29HSReHH@mail.gmail.com>
	<4D2A00C2.904@gmail.com>
	<AANLkTinM0P90w6tRaogEm1S6o3Prb3DFHNgqgmVTLh+H@mail.gmail.com>
	<4D2AD7FB.8030906@gmail.com>
Date: Mon, 10 Jan 2011 20:04:21 +0600
Message-ID: <AANLkTik7rQVv_YJPSkTKujjtHOsTCfV2RQSASTDU4rKt@mail.gmail.com>
Subject: Re: [PATCH] x86, apic: Do not increment disabled_cpus from generic_processor_info.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 3:57 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On 01/10/2011 07:06 AM, Rakib Mullick wrote:
>> On Mon, Jan 10, 2011 at 12:38 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>
>> When we use nr_cpus=n, it works as an upper limit. If there are any
>> other CPUs beyond that limit those are not counted and we couldn't put
>> them back on work. So, when we couldn't use hotpluging feature to back
>> them into work, should we care about them?
>>
>
>  Yes we should, the cpus which are present but offlined (due to maxcpus
> or whatever reason) are listed in sysfs so i fear such a change would
> break compatibility with userspace as well.
>
For an example, there are 4 CPUs, we did nr_cpus=2 at boot time. Then
using hotpluging feature we can put CPUs online or offline only these
two CPUs, not the 3rd or 4th CPUs that we left out at startup. But, by
incrementing disabled_cpus at generic_processor_info we are accouting
those two left out CPUs. And latter on at cpumask build up (in
smpboot.c) we're using disabled_cpus to build cpumask bit.

So, as you are fearing about sysfs listing, those maybe right but only
for CPUs we have by passing nr_cpus.

>  Rakib, don't get me wrong, I don't like to complain but the side effect
> of the patch might be pretty inconvenient.
>
It's okay. My primary intention was to raise the issue and have some
disscussion about it. Not necessarily, it must have to included. And
it also helps to clear up the concept and that is why was expecting
Ingo's opinion.


thanks,
rakib

> --
>    Cyrill
>
