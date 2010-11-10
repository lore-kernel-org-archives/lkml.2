Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0KJKxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:53:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50503 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0KJKxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:53:07 -0500
Message-ID: <4CDA7925.10707@ru.mvista.com>
Date: Wed, 10 Nov 2010 13:51:17 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 6/6] ce4100: Add support for CE4100 EHCI IP block to EHCI
 driver
References: <Pine.LNX.4.44L0.1011092134180.14099-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011092134180.14099-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-11-2010 5:36, Alan Stern wrote:

>> In a previous patch in this series GregKH asked that the PCI ID not be added
>> to pci_ids.h for ID's that are only used by a single file.
>> Here is an updated version of the EHCI controller patch.

>> Subject: [PATCH] ce4100: Add support for CE4100 EHCI IP block to EHCI driver

>> This patch adds support for the EHCI IP block present on the Intel
>> CE4100.

>> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
>> CC: linux-usb@vger.kernel.org
>> CC: David Brownell<dbrownell@users.sourceforge.net>
>> ---
>>   drivers/usb/host/ehci-pci.c |    4 ++++
>>   1 files changed, 4 insertions(+), 0 deletions(-)

>> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
>> index a1e8d27..da2b196 100644
>> --- a/drivers/usb/host/ehci-pci.c
>> +++ b/drivers/usb/host/ehci-pci.c
>> @@ -124,6 +124,10 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
>>   			ehci_info(ehci, "disable lpm for langwell/penwell\n");
>>   			ehci->has_lpm = 0;
>>   		}
>> +		if (pdev->device == 0x2e70) {
>> +			hcd->has_tt = 1;
>> +			tdi_reset(ehci);
>> +		}

> I think Greg meant that it's okay to use a symbolic constant for the
> PCI ID (it helps tell people what hardware is being handled).  Just
> don't add that constant to the pci_ids.h file.

    Or at least you need a comment naming the hardware that this ID belongs to.

> Alan Stern

WBR, Sergei
