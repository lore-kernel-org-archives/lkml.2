Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940Ab1L1FBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 00:01:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13163 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab1L1FA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 00:00:56 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7b95ae00000198b-13-4efaa287b483
Message-id: <4EFAA280.3030307@samsung.com>
Date: Wed, 28 Dec 2011 14:00:48 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110419
 Thunderbird/3.1.9
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-pm@vger.kernel.org, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        rdunlap@xenotime.net, cbouatmailru@gmail.com, pali.rohar@gmail.com,
        prakity@mavell.com, lars@metafoo.de, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] power: Charger-Manager: add initial Charger-Manager
 driver
References: <1324979269-2453-1-git-send-email-dg77.kim@samsung.com>
 <1324979269-2453-2-git-send-email-dg77.kim@samsung.com>
 <20111227113611.GH2870@opensource.wolfsonmicro.com>
In-reply-to: <20111227113611.GH2870@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011년 12월 27일 20:36, Mark Brown wrote:
> On Tue, Dec 27, 2011 at 06:47:48PM +0900, Donggeun Kim wrote:
> 
>> +		/*
>> +		 * Abnormal battery state - Stop charging forcibly,
>> +		 * even if charger was enabled at the other places
>> +		 */
>> +		err = regulator_bulk_disable(desc->num_charger_regulators,
>> +					desc->charger_regulators);
>> +
>> +		for (i = 0; i < desc->num_charger_regulators; i++) {
>> +			if (regulator_is_enabled(
>> +				    desc->charger_regulators[i].consumer)) {
>> +				regulator_force_disable(
>> +					desc->charger_regulators[i].consumer);
>> +				dev_warn(cm->dev,
>> +					"Disable regulator(%s) forcibly.\n",
>> +					desc->charger_regulators[i].supply);
>> +			}
> 
> Just implement a regulator_bulk_force_disable() operation; this is a
> totally reasonable thing to want to do and other drivers may have the
> same need.  Actually, looking at what you've written here it's totally
> sensible and we should probably also roll the attempt to do a normal
> disable() into force_disable() - there can't be many situations in which
> trying a clean shutdown first isn't the right thing to do.
> 
Okay.
The patch for 'regulator_bulk_force_disable' will be sent regardless of
this patchset.

Thanks.
-Donggeun
