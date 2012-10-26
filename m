Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966358Ab2JZUHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:07:09 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38430 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966288Ab2JZUHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:07:06 -0400
Message-ID: <508AED66.3040808@gmail.com>
Date: Fri, 26 Oct 2012 13:07:02 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: shuah.khan@hp.com
CC: ralf@linux-mips.org, kyungmin.park@samsung.com, arnd@arndb.de,
        andrzej.p@samsung.com, m.szyprowski@samsung.com,
        linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Subject: Re: [PATCH RFT RESEND linux-next] mips: dma-mapping: support debug_dma_mapping_error
References: <1351208193.6851.17.camel@lorien2>  <1351267298.4013.12.camel@lorien2> <508ABE1D.5010106@gmail.com> <1351271198.4013.35.camel@lorien2>
In-Reply-To: <1351271198.4013.35.camel@lorien2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 10:06 AM, Shuah Khan wrote:
> On Fri, 2012-10-26 at 09:45 -0700, David Daney wrote:
>> On 10/26/2012 09:01 AM, Shuah Khan wrote:
>>> Add support for debug_dma_mapping_error() call to avoid warning from
>>> debug_dma_unmap() interface when it checks for mapping error checked
>>> status. Without this patch, device driver failed to check map error
>>> warning is generated.
>>>
>>> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
>>> ---
>>>    arch/mips/include/asm/dma-mapping.h |    2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/arch/mips/include/asm/dma-mapping.h b/arch/mips/include/asm/dma-mapping.h
>>> index be39a12..006b43e 100644
>>> --- a/arch/mips/include/asm/dma-mapping.h
>>> +++ b/arch/mips/include/asm/dma-mapping.h
>>> @@ -40,6 +40,8 @@ static inline int dma_supported(struct device *dev, u64 mask)
>>>    static inline int dma_mapping_error(struct device *dev, u64 mask)
>>>    {
>>>    	struct dma_map_ops *ops = get_dma_ops(dev);
>>> +
>>> +	debug_dma_mapping_error(dev, mask);
>>>    	return ops->mapping_error(dev, mask);
>>>    }
>>>
>>>
>>
>> Although this is a start, I don't think it is sufficient.
>>
>> As far as I can tell, there are many missing calls to debug_dma_*() in
>> the various MIPS commone and sub-architecture DMA code.
>>
>> Really you (or someone) needs to look at *all* the functions in
>> arch/mips/asm/dma-mapping.h, and arch/mips/mm/dma-default.c and find
>> places missing a debug_dma_*().
>
> Is it correct to assume that this patch is not needed on MIPS until
> debug_dma interfaces get added to MIPS common and sub-architecture DMA
> code.

No, you have a false predicate here.

debug_dma_* *is* already mostly added.  The problem is that it is 
incomplete.  That is the nature of the problem.  Your patch makes it 
slightly better, but doesn't fully fix the problems.


>
> When I didn't see dma_map_page() in arch/mips/include/asm/dma-mapping.h
> defined, and just an extern, I incorrectly assumed, it is getting picked
> up from <asm-generic/dma-mapping-common.h>, hence the need for this
> patch in the first place.
>
> -- Shuah
>
>
>

