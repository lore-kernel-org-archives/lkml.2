Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab2KOV0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:26:40 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:41471
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710Ab2KOV0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:26:38 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1de0h1202h1d1ah1d2ahzz8275bhz2dh668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
X-WSS-ID: 0MDJSW5-01-301-02
X-M-MSG: 
Message-ID: <50A55E04.9020606@amd.com>
Date: Thu, 15 Nov 2012 16:26:28 -0500
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
        <herrmann.der.user@googlemail.com>, <bp@alien8.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h processors
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com> <20121115204503.GB18032@khazad-dum.debian.net>
In-Reply-To: <20121115204503.GB18032@khazad-dum.debian.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/15/2012 03:45 PM, Henrique de Moraes Holschuh wrote:
> On Thu, 15 Nov 2012, Boris Ostrovsky wrote:
>> Add valid patch size for family 16h processors
>>
>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
>
> Is this something that needs to go to -stable ?
>
>>   #define F1XH_MPB_MAX_SIZE 2048
>>   #define F14H_MPB_MAX_SIZE 1824
>>   #define F15H_MPB_MAX_SIZE 4096
>> +#define F16H_MPB_MAX_SIZE 3458
>>
>>   	switch (c->x86) {
>>   	case 0x14:
>> @@ -198,6 +199,9 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
>>   	case 0x15:
>>   		max_size = F15H_MPB_MAX_SIZE;
>>   		break;
>> +	case 0x16:
>> +		max_size = F16H_MPB_MAX_SIZE;
>> +		break;
>>   	default:
>>   		max_size = F1XH_MPB_MAX_SIZE;
>>   		break;
>
> Because it looks like without this patch, some valid microcode updates
> would be rejected by the kernel...

Right, patch loading will fail.

I wasn't sure whether stable would be appropriate since this is support 
for new HW. OTOH since this would result in loss of functionality one 
could consider this a bug.

-boris

