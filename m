Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1KCHHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:07:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60210 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1KCHHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:07:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EB23DBC.8050805@jp.fujitsu.com>
Date: Thu, 03 Nov 2011 16:07:40 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Yinghai Lu <yinghai.lu@oracle.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] pciehp: Retrieve link speed after link is trained
References: <4E9147DE.3050006@oracle.com> <20111102140522.411ef343@jbarnes-desktop>
In-Reply-To: <20111102140522.411ef343@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/11/03 6:05), Jesse Barnes wrote:
> On Sun, 09 Oct 2011 00:06:06 -0700
> Yinghai Lu<yinghai.lu@oracle.com>  wrote:
>
>>
>> During hot plug, board_added will call pciehp_power_on_slot().
>> But link speed is updated in pciehp_power_on_slot().
>>
>> We should not update link speed there, because that is too early.
>>
>> Move updating to pciehp_check_link_status() after making sure link is trained.
>>
>> Signed-off-by: Yinghai Lu<yinghai.lu@oracle.com>
>>
>> ---
>>   drivers/pci/hotplug/pciehp_hpc.c |   10 ++--------
>>   1 file changed, 2 insertions(+), 8 deletions(-)
>>
>> Index: linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/pci/hotplug/pciehp_hpc.c
>> +++ linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
>> @@ -294,6 +294,8 @@ int pciehp_check_link_status(struct cont
>>   		return retval;
>>   	}
>>
>> +	pcie_update_link_speed(ctrl->pcie->port->subordinate, lnk_status);
>> +
>>   	return retval;
>>   }
>>
>> @@ -516,14 +518,6 @@ int pciehp_power_on_slot(struct slot * s
>>   	ctrl_dbg(ctrl, "%s: SLOTCTRL %x write cmd %x\n", __func__,
>>   		 pci_pcie_cap(ctrl->pcie->port) + PCI_EXP_SLTCTL, slot_cmd);
>>
>> -	retval = pciehp_readw(ctrl, PCI_EXP_LNKSTA,&lnk_status);
>> -	if (retval) {
>> -		ctrl_err(ctrl, "%s: Cannot read LNKSTA register\n",
>> -				__func__);
>> -		return retval;
>> -	}
>> -	pcie_update_link_speed(ctrl->pcie->port->subordinate, lnk_status);
>> -
>>   	return retval;
>>   }
>
> Kenji-san or Hidetoshi-san, would it be possible to get tested-bys and
> reviewed-bys from you on this patch?
>
> Thanks,

Looks good to me.
Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Unfortunately, I don't have test environment right now. Maybe
I will be able to test it early next week.

Regards,
Kenji Kaneshige

