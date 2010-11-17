Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578Ab0KQJS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 04:18:26 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64863 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab0KQJSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 04:18:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dQDPl7FRfvKpswOGZTFbb/hSX7m0mn7bWOe6zxBZiHEHikFAccIcxPXnFwUNbb+z25
         fcUbbzOXQSA22MAJAB84Ji3/v1oVsyHPRvnhQ/IDZCgQy47p0zt+oc6D2MPcN4JF9bcz
         RkhLAYdMDmN7DcTm8ISlwjW+pGvmYGp3EZjJU=
MIME-Version: 1.0
In-Reply-To: <4CE397BF0200007800022AD6@vpn.id2.novell.com>
References: <4CE24DF40200007800022737@vpn.id2.novell.com>
	<4CE30524.5080802@kernel.org>
	<4CE397BF0200007800022AD6@vpn.id2.novell.com>
Date: Wed, 17 Nov 2010 01:18:24 -0800
X-Google-Sender-Auth: UCsXYMCCn9s2mdxm1rmF3AsH_jE
Message-ID: <AANLkTi=hvf7h7kHivpM3MdWBrhT2V+WBkbQWvVFa9caH@mail.gmail.com>
Subject: Re: [PATCH, v2] x86-64: fix and clean up AMD Fam10 MMCONF enabling
From: Yinghai Lu <yinghai@kernel.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:52 PM, Jan Beulich <JBeulich@novell.com> wrote:
>>>> On 16.11.10 at 23:26, Yinghai Lu <yinghai@kernel.org> wrote:
>> On 11/16/2010 12:25 AM, Jan Beulich wrote:
>>> @@ -206,8 +200,10 @@ void __cpuinit fam10h_check_enable_mmcfg
>>>       * with 256 buses
>>>       */
>>>      get_fam10h_pci_mmconf_base();
>>> -    if (fam10h_pci_mmconf_base_status <= 0)
>>> +    if (!fam10h_pci_mmconf_base) {
>>> +            pci_probe &= ~PCI_CHECK_ENABLE_AMD_MMCONF;
>>
>> case: if no cpu mmconf reg are set by BIOS and later if BSP can not get new
>> base,
>>
>> this pci_probe &= line will be called for every AP...
>
> No, because the function itself has
>
>        if (!(pci_probe & PCI_CHECK_ENABLE_AMD_MMCONF))
>                return;
>
> at its very beginning.

ok.

Acked-by: Yinghai Lu <yinghai@kernel.org>
