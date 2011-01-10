Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1AJJ5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 04:57:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46636 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1AJJ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 04:57:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nXH3wlVHPZ88mdTypg0RBYlEg4fsZelZJCVn3+vVippcHUkg+ibVQgFyM2zx+rR6yl
         ZBEw+3AD1tZyCVlH/iZfS7DclARRqyHbb9xLkiLzn1fAvoBZEa6GGOVKVlO0M5IkQCcI
         QYARnABRc55Q7qTBS8Hceh9tEsPZtXTwBUl3k=
Message-ID: <4D2AD7FB.8030906@gmail.com>
Date: Mon, 10 Jan 2011 12:57:15 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: [PATCH] x86, apic: Do not increment disabled_cpus from generic_processor_info.
References: <AANLkTimb7wj0oP_ctr7Ergf4VmVFTMHU3QCCaLcPE5Q9@mail.gmail.com>	<20110109093926.GB542@elte.hu>	<AANLkTik=bg0KY8Oygxem+SdEaPHwBtHRHOcz29HSReHH@mail.gmail.com>	<4D2A00C2.904@gmail.com> <AANLkTinM0P90w6tRaogEm1S6o3Prb3DFHNgqgmVTLh+H@mail.gmail.com>
In-Reply-To: <AANLkTinM0P90w6tRaogEm1S6o3Prb3DFHNgqgmVTLh+H@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 07:06 AM, Rakib Mullick wrote:
> On Mon, Jan 10, 2011 at 12:38 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> On 01/09/2011 07:57 PM, Rakib Mullick wrote:
>>> On Sun, Jan 9, 2011 at 3:39 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>>  When nr_cpus=n passed from command line and there is N > n physical cpu
>> present we *still* have to increment disabled_cpus in generic_processor_info
>> because:
>>
>> 1) We're priting out the number of cpu which is disabled
>> 2) total_cpus become inconsistent
>>
>> and while (1) is not that important, total_cpus _is_ important (it
>> is used to print out offlined cpus).
>>
> When we use nr_cpus=n, it works as an upper limit. If there are any
> other CPUs beyond that limit those are not counted and we couldn't put
> them back on work. So, when we couldn't use hotpluging feature to back
> them into work, should we care about them?
> 

  Yes we should, the cpus which are present but offlined (due to maxcpus
or whatever reason) are listed in sysfs so i fear such a change would
break compatibility with userspace as well.

  Rakib, don't get me wrong, I don't like to complain but the side effect
of the patch might be pretty inconvenient.

> 
>>  So I still fail to see why we need to drop the former increment in
>> first place.

-- 
    Cyrill
