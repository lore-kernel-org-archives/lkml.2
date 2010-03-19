Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0CSX11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 19:27:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:45765 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0CSX1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 19:27:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J4NMhUHFm0MW5vnZndz8PRPJ7h9vRhaRFoQqc8B1TfOvlcs6M850AD4ZY1d3+Kl9X/
         yoLNFNHckKTGnJJel1jxvAn+uv1rwoc62F4Rp4TOTn7XJftSlmNkiuiv3LwZytCGOJB2
         6MeoTec5IBid9Cth+T2H5HzSbiHPChzWoOHwA=
Message-ID: <4BA40864.3080204@googlemail.com>
Date: Sat, 20 Mar 2010 00:27:32 +0100
From: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] arch/x86/kernel/head_32.S Warning: shift count out
 of range (32 is not between 0 and 31)
References: <4BA2A45B.6060004@googlemail.com> <4BA3F088.8040203@zytor.com>
In-Reply-To: <4BA3F088.8040203@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/10 22:45, H. Peter Anvin wrote:
> On 03/18/2010 03:08 PM, Ren� Bolldorf wrote:
>> Signed-off-by: Rene Bolldorf<xsecute@googlemail.com>
>>
>> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
>> index 37c3d4b..8bfba5e 100644
>> --- a/arch/x86/kernel/head_32.S
>> +++ b/arch/x86/kernel/head_32.S
>> @@ -62,7 +62,7 @@
>>
>>    /* Enough space to fit pagetables for the low memory linear map */
>>    MAPPING_BEYOND_END = \
>> -	PAGE_TABLE_SIZE(((1<<32) - __PAGE_OFFSET)>>  PAGE_SHIFT)<<  PAGE_SHIFT
>> +	PAGE_TABLE_SIZE(((1<<31) - __PAGE_OFFSET)>>  PAGE_SHIFT)<<  PAGE_SHIFT
>>
>>    /*
>>     * Worst-case size of the kernel mapping we need to make:
>
> NAK... this is in fact doubly wrong... the assembler handles this case
> just fine -- it's a .S file after all -- and the result is wrong.
>
> If you want to change it change it to 0x100000000.
>
> 	-hpa

The funny thing is even if i change to 0x100000000 or 0 etc., the 
compiler warns me. Is this normal or a compiler issue?
