Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2ETX2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 19:28:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39691 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2ETX2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 19:28:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fe76d0000023f5-bd-4fb97e2215bb
Message-id: <4FB97E22.7090604@samsung.com>
Date: Mon, 21 May 2012 08:28:34 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Greg KH <gregkh@linuxfoundation.org>
Cc: broonie@opensource.wolfsonmicro.com, thomas.abraham@linaro.org,
        grant.likely@secretlab.ca, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mfd: add irq domain support for max8997 interrupts
References: <1337154104-22036-1-git-send-email-cw00.choi@samsung.com>
 <20120518235916.GA14015@kroah.com>
In-reply-to: <20120518235916.GA14015@kroah.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jAV2lup3+BhufKltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M3qO3WAreC1QsenCVvYFxGV8XIyeHhICJRPeXt8wQtpjEhXvr
	2boYuTiEBBYxSvSu/8ICkuAVEJT4MfkekM3BwSwgL3HkUjZImFlAXWLSvEXMEPXdTBITV7Qx
	QtRrSTzZc5IJxGYRUJVY2LedDcRmA4rvf3GDDWSOqECExK9+DpCwiICGxEug20DmMAucZpQ4
	f2cRWL2wgJ/Ekx9rmEHqhQSyJO4d0wcJcwroS7yf/Il5AqPALCTXzUK4bhaS6xYwMq9iFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECA6+Z1I7GFc2WBxiFOBgVOLhLV+8w1+INbGsuDL3EKME
	B7OSCK90FlCINyWxsiq1KD++qDQntfgQozQHi5I4rx1ItUB6YklqdmpqQWoRTJaJg1OqgXFT
	ymdXQ9mq9g8NovZTWfUu9lxomJsco8HxnunSu0179Sf4hX666cYf78G00XWPj6Pz6rPd5QsW
	XfrEviBpy0rBbZv71t2UWR2hv/T6wWiNpc5ba/NYvrxrXu5Uo8aY8Tvhy4WlX8x+fFmxZ7u5
	bZzf3LubKnTmrn+n8yD87ml50bzJfuseqKgrsRRnJBpqMRcVJwIAP6pdTDoCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 05/19/2012 08:59 AM, Greg KH wrote:

> On Wed, May 16, 2012 at 04:41:44PM +0900, Chanwoo Choi wrote:
>> From: Thomas Abraham <thomas.abraham@linaro.org>
>>
>> Add irq domain support for max8997 interrupts. The reverse mapping method
>> used is linear mapping since the sub-drivers of max8997 such as regulator
>> and charger drivers can use the max8997 irq_domain to get the linux irq
>> number for max8997 interrupts. All uses of irq_base in platform data and
>> max8997 driver private data are removed.
>>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
>> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> 	[Fix two bug which set max8997->irq_domain and correct wrong parameter]
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Same problem as before, I apply this and it breaks the build with the
> following errors:
> 
> drivers/extcon/extcon-max8997.c: In function ‘max8997_muic_irq_work’:
> drivers/extcon/extcon-max8997.c:350:36: error: ‘struct max8997_dev’ has no member named ‘irq_base’
> drivers/extcon/extcon-max8997.c: In function ‘max8997_muic_probe’:
> drivers/extcon/extcon-max8997.c:452:35: error: ‘struct max8997_platform_data’ has no member named ‘irq_base’
> drivers/extcon/extcon-max8997.c: In function ‘max8997_muic_remove’:
> drivers/extcon/extcon-max8997.c:514:19: error: ‘struct max8997_dev’ has no member named ‘irq_base’
> 
> Please fix.

I posted patchset including below two patch. The second patch fix that
extcon-max8997 driver use irq_domain instead of irq_base field in
'struct max8997_dev'.

Please apply second patch when test this patchset.
If you want to consolidate this patchset, I will resend it.

[PATCH v3 1/2] mfd: add irq domain support for max8997 interrupts
[PATCH v3 2/2] Extcon: MAX8997: Add support irq domain for MAX8997 muic

Best Regards,
Chanwoo Choi

