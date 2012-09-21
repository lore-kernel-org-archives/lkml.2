Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2IUHZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:25:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53821 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2IUHZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:25:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7f2b6d000000f14-af-505c1675d1a5
Message-id: <505C1673.50603@samsung.com>
Date: Fri, 21 Sep 2012 16:25:39 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] charger-manager: Add support sysfs entry for charger
References: <1345536409-25880-1-git-send-email-cw00.choi@samsung.com>
 <20120921051239.GA31443@lizard>
In-reply-to: <20120921051239.GA31443@lizard>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jAd1SsZgAg9ZlchaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjy5fljAW/xCu6elcwNzCeFO5i5OSQEDCRuHJ1KSOELSZx4d56
	ti5GLg4hgUWMEq9ebmcCSfAKCEr8mHyPpYuRg4NZQF7iyKVskDCzgLrEpHmLmCHqu5gkHrVs
	gqrXkPi07RLYUBYBVYnlL/eAxdkEtCT2v7jBBjJHVCBC4lc/B0hYRMBA4uDDpUwgc5gFehgl
	vpzcwAaSEBbwlej/3cAEUi8kkC7xr4cPJMwpoCOx6HwP4wRGgVlIrpuFcN0sJNctYGRexSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREcfM+kdzCuarA4xCjAwajEw7viW3SAEGtiWXFl7iFG
	CQ5mJRHeRzFAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzCnwIDgG5LLEnNTk0tSC2CyTJxcEo1
	MPJJTtpSeu79annnb9e8Oc5wv8sp8Z415SrPq1xdZb5923Xq0rZXJv3fcFTD76zGYfH9FQVn
	bPVtfoT7Ln54TpqvcoZLztRPprJSFoI6LdWpvHMVC6bvObAxbf3C+ZPZ17Bzzn5Q5bHNpMYp
	LC5ZlkdeyOrx3rPLN8Smyu44cTfbLGcyh6vnHiWW4oxEQy3mouJEAEK0gKY6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 02:12 PM, Anton Vorontsov wrote:

> On Tue, Aug 21, 2012 at 05:06:49PM +0900, Chanwoo Choi wrote:
>> This patch add support sysfs entry for each charger(regulator).
>> Charger-manager use one or more chargers for charging battery but
>> some charger isn't necessary on specific scenario. So, if some charger
>> isn't needed, can disable specific charger through 'externally_control'
>> entry while system is on state and confirm the information(name, state)
>> of charger.
>>
>> the list of added sysfs entry
>> - /sys/class/power_supply/battery/chargers/charger.[index]/name
>> : show name of charger(regulator)
>> - /sys/class/power_supply/battery/chargers/charger.[index]/state
>> : show either enabled or disabled state of charger
>> - /sys/class/power_supply/battery/chargers/charger.[index]/externally_control
> 
> The API looks sane.
> 
> For the future, you might want to get rid of the 'name', and instead
> just point to a regulator device (via a sysfs symlink). I.e.
> 
> /sys/class/power_supply/battery/chargers/charger.[index]/device
> would be a symlink to the regulator device.
> 
> But for the time being, I guess it's OK as is (although I wouldn't
> mind if it'll use the symlink from the start. :-)


OK, as your said, I will modify sysfs entry for charger(regulator) by
linking sysfs
of regulator device.

> 
> [...]
>>  		for (j = 0 ; j < charger->num_cables ; j++) {
>>  			struct charger_cable *cable = &charger->cables[j];
>> @@ -1287,6 +1386,71 @@ static int charger_manager_probe(struct platform_device *pdev)
>>  			cable->charger = charger;
>>  			cable->cm = cm;
>>  		}
>> +
> [...]
>> +		charger->attr_g.attrs = charger->attrs;
>> +
>> +		sysfs_attr_init(&cable->attr_name.attr);
> 
> Notice that 'cable' is declared in the 'for' loop above,
> so this doesn't compile for me:
> 
>   CHECK   drivers/power/charger-manager.c
> drivers/power/charger-manager.c:1559:17: error: undefined identifier 'cable'
> drivers/power/charger-manager.c:1564:17: error: undefined identifier 'cable'
> drivers/power/charger-manager.c:1569:17: error: undefined identifier 'cable'
>   CC      drivers/power/charger-manager.o
> drivers/power/charger-manager.c: In function ‘charger_manager_probe’:
> drivers/power/charger-manager.c:1559:3: error: ‘cable’ undeclared (first use in this function)
> drivers/power/charger-manager.c:1559:3: note: each undeclared identifier is reported only once for each function it appears in
> make[1]: *** [drivers/power/charger-manager.o] Error 1
> 

I will fix it.

> Also:
> - Please adhere to the codingstyle, there should be no spaces
>   before ';' in the for loop statement.
> - If possible, please consider splitting _probe routine, it is more
>   than 300 lines long nowadays.
> 


I resend soon patch which fix build break. As you said, I will modify
sysfs entry
for charger(regulator) by linking sysfs of regulator device and split _probe
routine.

Thanks for your comment.

Best Regards,
Chanwoo Choi





