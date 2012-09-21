Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab2IUHSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:18:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52290 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2IUHSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:18:21 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-45-505c14bbfcf5
Message-id: <505C14B9.5010207@samsung.com>
Date: Fri, 21 Sep 2012 16:18:17 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] charger-manager: Check fully charged state of battery
 periodically
References: <1345536412-25914-1-git-send-email-cw00.choi@samsung.com>
 <20120921051044.GB927@lizard>
In-reply-to: <20120921051044.GB927@lizard>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jQd3dIjEBBnvua1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MRf+/shYc46ro2nKQsYHxAEcXIweHhICJxMyNKV2MnECmmMSF
	e+vZuhi5OIQEpjNK3Dl/jBXC6WKSuHu2kRWkildAS2J9TxcbiM0ioCox7eYdsDgbUHz/ixts
	IENFBSIkfvVzQJQLSvyYfI8FxBYRMJA4+HApE8hMZoEeRokvJzeAzREWiJV4ePEgmC0kkCpx
	edJxsDmcQDMPb5IBCTMLqEtMmreIGcKWl9i85i3zBEaBWUhWzEJSNgtJ2QJG5lWMoqkFyQXF
	Sem5RnrFibnFpXnpesn5uZsYweH3THoH46oGi0OMAhyMSjy8K75FBwixJpYVV+YeYpTgYFYS
	4X0UAxTiTUmsrEotyo8vKs1JLT7EKM3BoiTOK/wpMEBIID2xJDU7NbUgtQgmy8TBKdXA6MOq
	0LRBe5/k2kY2ts91P6W9FJ6En+7Rzjgh4332ukVJrJ3rjVnbzi1MVI9OyHw846LDVO2O1RMT
	NTdfs198SfOlu8Z1neDbTqdmnRbTWW5neY2twWUDyyQXnp8zfR0mT73Pypm5stfvvdiFzLwV
	qlsMr9yKOVD65337pkqzKw9YN84pCJTgU2Ipzkg01GIuKk4EAMkoZww7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 02:10 PM, Anton Vorontsov wrote:

> On Tue, Aug 21, 2012 at 05:06:52PM +0900, Chanwoo Choi wrote:
>> This patch check periodically fully charged state of battery to protect
>> overcharge and overheat. If battery is fully charged, stop charging
>> and check droped voltage with 'fullbatt_vchkdrop_ms' period. When voltage
>> of battery is more droped than 'fullbatt_vchkdrop_uV' voltage,
>> charger-manager will restart charging for battery.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
> 
> Applied, thank you.
> 
> There were some minor issues, but I fixed them up:
> 
> [...]
>> +	} else if (!cm->emergency_stop
>> +			&& is_ext_pwr_online(cm) && !cm->charger_enabled) {
> 
> Wrong && placement (should have been on the previous line).
> 
>> +		fullbatt_vchk(&cm->fullbatt_vchk_work.work);
>> +
>> +	/*
>> +	 * Check whether fully charged state to protect overcharge
>> +	 * if charger-manager is charging for battery.
>> +	 */
>> +	} else if (!cm->emergency_stop
>> +			&& is_full_charged(cm) && cm->charger_enabled) {
> 
> Ditto.
> 


Thanks for your reply and applied it.

I will consider your comment about coding style.

Best Regards,
Chanwoo Choi
