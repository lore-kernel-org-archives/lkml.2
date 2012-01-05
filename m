Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2AEIWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 03:22:50 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13810 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2AEIWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 03:22:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6579"; a="152379159"
X-IronPort-AV: E=Sophos;i="4.71,459,1320652800"; 
   d="scan'208";a="229406403"
Message-ID: <4F055DC8.9050902@qca.qualcomm.com>
Date: Thu, 5 Jan 2012 10:22:32 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linville@tuxdriver.com>, <sfr@canb.auug.org.au>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
        <davem@davemloft.net>
Subject: Re: [PATCH 5/6] ath6kl: convert ath6kl_dbg() and ath6kl_dbg_dump()
 into functions
References: <20120104230429.32306.75965.stgit@x201>	 <20120104230950.32306.21264.stgit@x201> <1325720472.4116.7.camel@joe2Laptop>
In-Reply-To: <1325720472.4116.7.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.133.26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 01:41 AM, Joe Perches wrote:
> On Thu, 2012-01-05 at 01:09 +0200, Kalle Valo wrote:
>> That way it's possible to not export debug_mask outside the upcoming
>> ath6kl_core.ko and that makes it easier to ath6kl_core.ko in the
>> following patch.
> []
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> []
>> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
> []
>> +void ath6kl_dbg(enum ATH6K_DEBUG_MASK mask, const char *fmt, ...)
>> +{
>> +	va_list args;
>> +
>> +	if (!(debug_mask & mask))
>> +		return;
>> +
>> +	va_start(args, fmt);
>> +	ath6kl_printk(KERN_DEBUG, fmt, &args);
> 
> Passing a va_list as an argument?
> I believe this doesn't work.

Doh, I was supposed to test this but then I forgot in the hurry. Thanks
for pointing this out. I will send v2 which will fix this.

Kalle
