Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab1F2FpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:45:01 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:43944 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab1F2Fo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:44:56 -0400
Message-ID: <4E0ABA3F.5040809@in.ibm.com>
Date: Wed, 29 Jun 2011 11:08:07 +0530
From: Suzuki Poulose <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Kexec support for PPC440x
References: <4DE345B0.8020505@in.ibm.com> <4DE50617.7090509@linutronix.de> <4DE72EFE.8080502@in.ibm.com> <4DE8CA76.2060303@in.ibm.com> <4DE8E746.2080100@linutronix.de>
In-Reply-To: <4DE8E746.2080100@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/11 19:23, Sebastian Andrzej Siewior wrote:
> Suzuki Poulose wrote:
>>>> The way you setup the 1:1 mapping should be close to what you are doing on
>>>> kernel entry.Isn't it possible to include the file here and in the entry
>>>> code?
>>
>>> I will make this change and resend the patch.
>>
>> I took a look at the way we do it at kernel entry. It looks more cleaner to leave
>> it untouched. Especially, when we add the support for 47x in the future, the code
>> will become more unreadable.
>>
>> What do you think ?
>
> So the entry code has one 256MiB mapping, you need 8 of those. Entry goes for TLB 63 and you need to be flexible and avoid TLB 63 :).
> So after all you don't have that much in common with the entry code. If
> you look at the FSL-book code then you will notice that I tried to share
> some code.
>
> I don't understand why you don't flip the address space bit. On fsl we
> setup the tmp mapping in the "other address" space so we don't have two
> mappings for the same address. The entry code could be doing this with STS
> bit, I'm not sure.

I am not sure if I understood this correctly.
Could you explain how could there be two mappings for the same address ?
We are setting up 1:1 mapping for 0-2GiB and the only mapping that could exist
(in other words, not invalidated) is PAGE_OFFSET mapping. Since PAGE_OFFSET < 2GiB
we won't have multiple mappings. Or in other words we could limit KEXEC_*_MEMORY_LIMIT
to PAGE_OFFSET to make sure the crossing doesn't occur.

The kernel entry code sets up the mapping without a tmp mapping in 44x. i.e, it uses
the mapping setup by the firmware/boot loader.

Thanks
Suzuki
