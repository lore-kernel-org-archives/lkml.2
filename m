Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab2I1GqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:46:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34726 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab2I1GqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:46:23 -0400
Date: Fri, 28 Sep 2012 02:46:21 -0400 (EDT)
Message-Id: <20120928.024621.1635385815700269914.davem@davemloft.net>
To: haicheng.li@linux.intel.com
Cc: netdev@vger.kernel.org, tshimizu818@gmail.com,
        linux-kernel@vger.kernel.org, haicheng.lee@gmail.com
Subject: Re: [PATCH 1/2] Fix build error caused by broken PCH_PTP module
 dependency.
From: David Miller <davem@davemloft.net>
In-Reply-To: <506546A7.7030500@linux.intel.com>
References: <5060F97F.3040809@linux.intel.com>
	<20120927.180942.969924012897168294.davem@davemloft.net>
	<506546A7.7030500@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haicheng Li <haicheng.li@linux.intel.com>
Date: Fri, 28 Sep 2012 14:41:43 +0800

> On 09/28/2012 06:09 AM, David Miller wrote:
>> Look at how other people submit patches, do any other patch
>> submissions
>> look like your's having all of this metadata in the message body:
> I'm sorry for it.
> 
>> As for this specific patch:
>>
>>> -	depends on PTP_1588_CLOCK_PCH
>>> +	depends on PTP_1588_CLOCK_PCH = PCH_GBE
>>
>> This is not the correct way to ensure that the module'ness of one
>> config option meets the module'ness requirements of another.
>> The correct way is to say something like "&&  (PCH_GBE || PCH_GBE=n)"
> 
> This case is a little bit tricky than usual, with PCH_PTP selected,
> the valid config would be either "PTP_1588_CLOCK_PCH=PCH_GBE=m" or
> "PTP_1588_CLOCK_PCH=PCH_GBE=y", and PTP_1588_CLOCK_PCH depends on
> PCH_GBE.

And a simple "&& PCH_GBE" should accomplish this, no?

