Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0HQJCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:02:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7468 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab0HQJCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:02:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6076"; a="51278751"
Message-ID: <4C6A5034.2090406@codeaurora.org>
Date: Tue, 17 Aug 2010 02:02:44 -0700
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: dwalker@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v4] arm: msm: Add MSM IOMMU support.
References: <1281469529-23340-1-git-send-email-stepanm@codeaurora.org> <20100816183226.GA31512@phenom.dumpdata.com>
In-Reply-To: <20100816183226.GA31512@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 8/16/2010 11:32 AM, Konrad Rzeszutek Wilk wrote:
> I did a very brief look.
>
>> +	dmac_flush_range(fl_table, fl_table + SZ_16K);
>> +
>> +	for (i = 0; i<  4096; i++)
> Can you use a #define for the 4096? Will that value ever change?
I suppose a #define can be used, but this is a HW-specific number that 
will never ever change.

>> +		if ((fl_table[i]&  0x03) == FL_TYPE_TABLE) {
>> +			void *sl_table = __va(fl_table[i]&  0xFFFFFC00);
> Does it make sense to define say:
> #define MASK_XX (x) x&  0xFFFFFC00
> and
> #define MASK_XY (x) x&  0xFFFF0000
>
> and use those instead of these hard-coded values?
I guess so.. again, HW specific.


>> +	priv->pgtable = (unsigned long *)__get_free_pages(GFP_KERNEL, 2);
> Ugh.  Can you use get_order(SZ_16K) instead?
>
>> +	/* Invalidate context TLB */
>> +	SET_CTX_TLBIALL(base, ctx, 0);
>> +	SET_V2PPR_VA(base, ctx, va>>  12);
> Hmm, PAGE_SHIFT can't be used? Or some other #define?
I guess I can use the IOMMU PA shift. PAGE_SHIFT is not appropriate here 
because that is MMU-specific.

I can put out a v5 early next week.

Thanks
Steve
