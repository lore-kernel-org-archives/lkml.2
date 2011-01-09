Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab1AISjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 13:39:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58149 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1AISjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 13:39:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JyeMe3AOIVOnxQgtqBkLeAiZSrJAYxgO33VJZwr/3x6UJD3H9dPXrsTZV1GahZXQzr
         JrgFVpjrzO3nztxll3gazmFO6L2m2RJ6mrkffrFnl4d0Rno8a8UtZ/kzEJ4bR8S+44Fv
         G15oI2xdNZ4HOxaJXU2TWWm074aqvUhel+E68=
Message-ID: <4D2A00C2.904@gmail.com>
Date: Sun, 09 Jan 2011 21:38:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: [PATCH] x86, apic: Do not increment disabled_cpus from generic_processor_info.
References: <AANLkTimb7wj0oP_ctr7Ergf4VmVFTMHU3QCCaLcPE5Q9@mail.gmail.com>	<20110109093926.GB542@elte.hu> <AANLkTik=bg0KY8Oygxem+SdEaPHwBtHRHOcz29HSReHH@mail.gmail.com>
In-Reply-To: <AANLkTik=bg0KY8Oygxem+SdEaPHwBtHRHOcz29HSReHH@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2011 07:57 PM, Rakib Mullick wrote:
> On Sun, Jan 9, 2011 at 3:39 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> Hm, what effects does this have in practice? smpboot.c uses disabled_cpus as a value
>> to calculate limits - why has this bug not caused some misbehavior somewhere? (or if
>> it has caused misbehavior, what is that?)
> 
> If I'm not wrong, smpboot.c tries to get the possible cpu map by
> calculating disabled_cpus and num_processors. When we pass nr_cpus=n,
> which is less than no. of CPUs available, we can't put more CPUs
> online. So, no of cpu we detect at startup is okay. Or am I missing
> anything?
> 
> thanks,
> rakib
> 

 When nr_cpus=n passed from command line and there is N > n physical cpu
present we *still* have to increment disabled_cpus in generic_processor_info
because:

1) We're priting out the number of cpu which is disabled
2) total_cpus become inconsistent

and while (1) is not that important, total_cpus _is_ important (it
is used to print out offlined cpus).

 So I still fail to see why we need to drop the former increment in
first place.
-- 
    Cyrill
