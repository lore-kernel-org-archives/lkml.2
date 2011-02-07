Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1BGCZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 21:25:31 -0500
Received: from mx2.parallels.com ([64.131.90.16]:35734 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472Ab1BGCZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 21:25:29 -0500
Message-ID: <4D4F5810.3070300@parallels.com>
Date: Sun, 6 Feb 2011 20:25:20 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Vivek Goyal <vgoyal@redhat.com>,
        Haren Myneni <hbabu@us.ibm.com>,
        Eric Biederman <ebiederm@xmission.com>, <kexec@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH -next] Documentation: Improve crashkernel= description
References: <20110206154108.GA16542@laptop> <20110206215733.GB26233@verge.net.au>
In-Reply-To: <20110206215733.GB26233@verge.net.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.27.19.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2011 03:57 PM, Simon Horman wrote:
> On Sun, Feb 06, 2011 at 05:41:08PM +0200, Ahmed S. Darwish wrote:
>> (Also applicable over 2.6.38-rc3)
>>
>> Had to explore two C code files to make sense of the 'crashkernel='
>> kernel parameter values.  Improve the situation.
>>
>> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
>> ---
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 89835a4..8f26b42 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -545,9 +545,12 @@ and is between 256 and 4096 characters. It is defined in the file
>>  			Format:
>>  			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
>>  
>> -	crashkernel=nn[KMG]@ss[KMG]
>> -			[KNL] Reserve a chunk of physical memory to
>> -			hold a kernel to switch to with kexec on panic.
>> +	crashkernel=size[KMG][@offset[KMG]]
>> +			[KNL] Using kexec, Linux can switch to a 'crash kernel'
>> +			upon panic. This parameter reserves the physical
>> +			memory region [offset, offset + size] for that kernel
>> +			image. If the '@offset' part was ignored, Linux finds
>> +			a suitable crash image start address automatically.
> 
> I think this would be further improved as:
> 
> 			... If '@offset' is omitted then a suitable
> 			offset is selected automatically.

Suitable offset as in parses a known image type (ELF, bzImage, etc) to
find the start address?  Or just assumes the entry point and load
address are the same?

Is this the size for just the kernel image, or also for the physical
memory it uses so it won't overwrite the existing kernel's stuff on the
way up?  (If a compressed kernel wants to decompress itself or extract
an initramfs for itself, what happens?)

Rob
