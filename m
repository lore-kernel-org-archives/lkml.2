Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442Ab1LPSce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:32:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50122 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760218Ab1LPSc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:32:27 -0500
Message-ID: <4EEB8EAE.6010306@zytor.com>
Date: Fri, 16 Dec 2011 10:32:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jacob Shin <jacob.shin@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 1/1] x86: Exclude E820_RESERVED regions and memory holes
 above 4 GB from direct mapping.
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com> <4EA09EA2.3030203@zytor.com> <1319149574.13035.6.camel@jshin-Toonie> <4EE9266A.90200@zytor.com> <20111214231425.GA18068@jshin-Toonie> <20111216162004.GC18068@jshin-Toonie> <4EEB8320.4010809@oracle.com> <4EEB85F1.7050903@zytor.com> <CAE9FiQXTeJ2XZy-Pjwvdb4Fp5wb_XLq88tC-2M_3RbjSLk5d4A@mail.gmail.com>
In-Reply-To: <CAE9FiQXTeJ2XZy-Pjwvdb4Fp5wb_XLq88tC-2M_3RbjSLk5d4A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 10:29 AM, Yinghai Lu wrote:
> On Fri, Dec 16, 2011 at 9:54 AM, H. Peter Anvin<hpa@zytor.com>  wrote:
>
>>
>> For 2 - why can't we simply make the invariant that E820_RAM is mapped and
>> nothing else, with the sole exceptions being the 1 MiB (fixed MTRR)?
>
> Yes, we could do that. but need to track mapped area in simple way.
> like later memory hotadd or remove to update those tracking.
>

Well, there are two options for memory hotplug: either we always leave 
address space that can be used for memory hotplug mapped at all times, 
or we need to track it anyway.  Either way we need to know where there 
regions are.  Am I correct that right now we always map memory 
hotpluggable regions, being below the top pfn?

	-hpa

