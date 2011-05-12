Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab1ELMFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:05:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36316 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab1ELMFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=W9C7IHfvY7KSUAAh6KhhY3dxP/qTj+dOs3et8j10BrnZroxKqgEPlHVCtCAOaRuOBx
         h00Qnkkk6HaUv6VJ+e8yKVDcB58LQemXoMmVZFtue+4MCUmb5e8KOQjWZzAGFwXNAsf7
         OMYqdQsff8+ojxLeu8vYBXRZiBE7gAVXU3PiQ=
Message-ID: <4DCBCCF5.5040501@gmail.com>
Date: Thu, 12 May 2011 16:05:09 +0400
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, stf_xl@wp.pl
Subject: Re: [PATCH] ATA: pata_at91.c bugfixes
References: <1303299877-12088-1-git-send-email-plyatov@gmail.com> <4DB4433A.5000609@pobox.com>
In-Reply-To: <4DB4433A.5000609@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff!

> On 04/20/2011 07:44 AM, Igor Plyatov wrote:
>> * Fix "initial_timing" structure initialisation. The "struct 
>> ata_timing" must
>>    contain 10 members, but ".dmack_hold" member was not initialised.
>> * The AT91SAM9 microcontrollers use special coding scheme for SMC_SETUP,
>>    SMC_PULSE, SMC_CYCLE registers.
>>    Old driver operates correctly only with low master clock values, but
>>    with high master clock it incorrectly calculates SMC values and stops
>>    to operate, because SMC can be setup only to admissible ranges in 
>> special
>>    format.
>>    New code correctly calculates SMC registers values, adjusts 
>> calculated
>>    to admissible ranges, enlarges cycles if required and converts values
>>    into SMC's format.
>> * Old driver calculates CS_SETUP and CS_PULSE cycles incorrectly
>>    because of wrong assumptions.
>>    New code calculates:
>>        CS_SETUP = SETUP/2
>>        CS_PULSE = PULSE + SETUP/2 + HOLD/2
>> * This fixes allows to correctly operate with any master clock 
>> frequency.
>>
>> Signed-off-by: Igor Plyatov<plyatov@gmail.com>
>> ---
>>   drivers/ata/pata_at91.c |  223 
>> ++++++++++++++++++++++++++++++++---------------
>>   1 files changed, 154 insertions(+), 69 deletions(-)
>
> FYI, the two previous "v4" patches are now applied.
>
> Based on the comments from Stanislaw, this patch would need to be 
> updated anyway.

Thank you for info!

I will update this patch.

Best regards!

-- 
Igor Plyatov

