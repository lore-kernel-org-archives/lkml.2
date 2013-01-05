Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab3AELVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 06:21:47 -0500
Received: from [216.228.121.35] ([216.228.121.35]:3357 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab3AELVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 06:21:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 05 Jan 2013 03:18:31 -0800
Message-ID: <50E80C9A.7040404@nvidia.com>
Date: Sat, 5 Jan 2013 16:50:58 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Stephen Warren <swarren@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource
 allocation
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com> <1357371910-3164-3-git-send-email-ldewangan@nvidia.com> <20130105080658.GA1315@core.coreip.homeip.net>
In-Reply-To: <20130105080658.GA1315@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Dmitry,
Thanks for quick review.

I will take care of your comment in next version. Some have my answer.


On Saturday 05 January 2013 01:36 PM, Dmitry Torokhov wrote:
> Hi Laxman,
>
> On Sat, Jan 05, 2013 at 01:15:08PM +0530, Laxman Dewangan wrote:
>> Use devm_* for memory, clock, input device allocation. This reduces
>> code for freeing these resources.

>>   	err = tegra_kbd_setup_keymap(kbc);
>> -	if (err) {
>> +	if (err < 0) {
> Why is this change? As far as I can see tegra_kbd_setup_keymap() never
> returns positive values.

Ok, mostly errors are in negative and hence this change, I will revert 
it and will keep original.

>
>>   		dev_err(&pdev->dev, "failed to setup keymap\n");
>> -		goto err_put_clk;
>> +		return err;
>>   	}
>>   
>>   	__set_bit(EV_REP, input_dev->evbit);
>> @@ -790,15 +784,15 @@ static int tegra_kbc_probe(struct platform_device *pdev)
>>   
>>   	err = request_irq(kbc->irq, tegra_kbc_isr,
>>   			  IRQF_NO_SUSPEND | IRQF_TRIGGER_HIGH, pdev->name, kbc);
>> -	if (err) {
>> +	if (err < 0) {
> Neither request_irq(). BTW, why not devm_request_irq?

I understand from Mark B on different patches that using 
devm_request_irq() can create race condition when removing device. 
Interrupt can occur when device resource release is in process and so it 
can cause isr call which can use the freed pointer. devm_request_irq() 
should be avoided.


Thanks,
Laxman
