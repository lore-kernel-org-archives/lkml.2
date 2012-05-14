Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab2ENKG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:06:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39027 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2ENKGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:06:55 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-91-4fb0d93d33ce
Message-id: <4FB0D93A.7000108@samsung.com>
Date: Mon, 14 May 2012 19:06:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] MFD: MAX77693: add IRQ handler
References: <1336972835-15203-1-git-send-email-cw00.choi@samsung.com>
 <20120514095719.GK31985@opensource.wolfsonmicro.com>
In-reply-to: <20120514095719.GK31985@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 05/14/2012 06:57 PM, Mark Brown wrote:

> On Mon, May 14, 2012 at 02:20:35PM +0900, Chanwoo Choi wrote:
> 
>> +	if (!max77693->irq) {
>> +		dev_warn(max77693->dev, "No interrupt specified.\n");
>> +		return 0;
>> +	}
> 
> I'd suggest just setting up the IRQ domain anyway - it makes life
> simpler in the other drivers for the chip as they don't need to worry if
> interrupts are registered unless it's very important to them that they
> go off which is often not the case.  Just skip actually claiming the
> IRQ.
> 

This patch add support irq domain for MAX77693 in the
max77693_irq_init() function.
You can check on patchset. Then, The 'max77693->irq' is gpio pin for
IRQ. max77693->irq
is meant to indicate to the application processor that the status of
MAX77693 has changed.

>> +EXPORT_SYMBOL_GPL(max77693_irq_resume);
>> +EXPORT_SYMBOL_GPL(max77693_irq_init);
>> +EXPORT_SYMBOL_GPL(max77693_irq_exit);
> 
> These shouldn't need to be exported, they're only used by the MFD core.

OK, I remove it.

Thank you,
Chanwoo Choi
