Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2AEI50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 03:57:26 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49852 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2AEI5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 03:57:24 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6579"; a="152384399"
X-IronPort-AV: E=Sophos;i="4.71,459,1320652800"; 
   d="scan'208";a="156931104"
Message-ID: <4F0565E1.30909@qca.qualcomm.com>
Date: Thu, 5 Jan 2012 10:57:05 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linville@tuxdriver.com>, <sfr@canb.auug.org.au>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
        <davem@davemloft.net>
Subject: Re: [PATCH 4/6] ath6kl: get rid of AR_DBG_LVL_CHECK()
References: <20120104230429.32306.75965.stgit@x201>	 <20120104230921.32306.63985.stgit@x201> <1325721515.4116.11.camel@joe2Laptop>
In-Reply-To: <1325721515.4116.11.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.1.192]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 01:58 AM, Joe Perches wrote:
> On Thu, 2012-01-05 at 01:09 +0200, Kalle Valo wrote:
>> We don't need it as debug calls already have a log level and compiler
>> should be smart enough to optimise away the code when ath6kl debug code
>> is not enabled. Also it makes it easier to abstract core code to
>> ath6kl_core.ko.
> 
> Changelog isn't representative of code changes.
> ATH6KL_DBG_ANY -> ATH6KL_DBG_IRQ.
> 
>> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
> []
>> @@ -82,31 +82,31 @@ void ath6kl_dump_registers(struct ath6kl_device *dev,
>>  			   struct ath6kl_irq_enable_reg *irq_enable_reg)
>>  {
>>  
>> -	ath6kl_dbg(ATH6KL_DBG_ANY, ("<------- Register Table -------->\n"));
>> +	ath6kl_dbg(ATH6KL_DBG_IRQ, ("<------- Register Table -------->\n"));

It's related to this change:

-		if (AR_DBG_LVL_CHECK(ATH6KL_DBG_IRQ))
-			ath6kl_dump_registers(dev, &dev->irq_proc_reg,
-					 &dev->irq_en_reg);
+		ath6kl_dump_registers(dev, &dev->irq_proc_reg,
+				      &dev->irq_en_reg);

So instead of checking ATH6KL_DBG_IRQ before calling the function the
debug messages in function instead use ATH6KL_DBG_IRQ. I'll mention this
in the commit log.

I should get rid of that ATH6KL_DBG_ANY level completely, it's just
confusing. But I'll do that later.

Thank you for the review.

Kalle
