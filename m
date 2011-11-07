Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1KGLaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:30:35 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41517 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1KGLad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:30:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EB7C14E.1070503@jp.fujitsu.com>
Date: Mon, 07 Nov 2011 20:30:22 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai.lu@oracle.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] pciehp: Retrieve link speed after link is trained
References: <4E9147DE.3050006@oracle.com> <20111102140522.411ef343@jbarnes-desktop> <4EB23DBC.8050805@jp.fujitsu.com>
In-Reply-To: <4EB23DBC.8050805@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/11/03 16:07), Kenji Kaneshige wrote:
> (2011/11/03 6:05), Jesse Barnes wrote:
>> On Sun, 09 Oct 2011 00:06:06 -0700
>> Yinghai Lu<yinghai.lu@oracle.com> wrote:
>>
>>>
>>> During hot plug, board_added will call pciehp_power_on_slot().
>>> But link speed is updated in pciehp_power_on_slot().
>>>
>>> We should not update link speed there, because that is too early.
>>>
>>> Move updating to pciehp_check_link_status() after making sure link is trained.
>>>
>>> Signed-off-by: Yinghai Lu<yinghai.lu@oracle.com>
>>>
>>> ---
>>> drivers/pci/hotplug/pciehp_hpc.c | 10 ++--------
>>> 1 file changed, 2 insertions(+), 8 deletions(-)
>>>
>>> Index: linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/pci/hotplug/pciehp_hpc.c
>>> +++ linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
>>> @@ -294,6 +294,8 @@ int pciehp_check_link_status(struct cont
>>> return retval;
>>> }
>>>
>>> + pcie_update_link_speed(ctrl->pcie->port->subordinate, lnk_status);
>>> +
>>> return retval;
>>> }
>>>
>>> @@ -516,14 +518,6 @@ int pciehp_power_on_slot(struct slot * s
>>> ctrl_dbg(ctrl, "%s: SLOTCTRL %x write cmd %x\n", __func__,
>>> pci_pcie_cap(ctrl->pcie->port) + PCI_EXP_SLTCTL, slot_cmd);
>>>
>>> - retval = pciehp_readw(ctrl, PCI_EXP_LNKSTA,&lnk_status);
>>> - if (retval) {
>>> - ctrl_err(ctrl, "%s: Cannot read LNKSTA register\n",
>>> - __func__);
>>> - return retval;
>>> - }
>>> - pcie_update_link_speed(ctrl->pcie->port->subordinate, lnk_status);
>>> -
>>> return retval;
>>> }
>>
>> Kenji-san or Hidetoshi-san, would it be possible to get tested-bys and
>> reviewed-bys from you on this patch?
>>
>> Thanks,
>
> Looks good to me.
> Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>
> Unfortunately, I don't have test environment right now. Maybe
> I will be able to test it early next week.
>

I got the following warning messages on kernel compile. I'm using 3.1.
Yinghai, please fix this.

   CC      drivers/pci/hotplug/pciehp_hpc.o
drivers/pci/hotplug/pciehp_hpc.c: In function 'pciehp_power_on_slot':
drivers/pci/hotplug/pciehp_hpc.c:489: warning: unused variable 'lnk_status'

Looks good to me, other than this.

Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Regards,
Kenji Kaneshige




