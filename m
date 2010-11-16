Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab0KPXY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:24:58 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54447 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab0KPXY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wcPhRylIsgV7P1hg3lIwz/FJvfUrW3RJu+sUVIckQznJRvFG/E92KmuEDZvpUD5//D
         39cwYfr19KfLwvhf4OYnOzamCUa63fSIIRy02wWcOjeeomTRgYNTB5pqDFF5iIqdUSsG
         Wspsz8lz5cUu6a45Mg2cdPX8NB3GE9NwFcR/A=
Message-ID: <4CE312C1.6070100@gmail.com>
Date: Tue, 16 Nov 2010 15:24:49 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 6/6] ce4100: Add support for CE4100 EHCI IP block to EHCI
 driver
References: <Pine.LNX.4.44L0.1011092134180.14099-100000@netrider.rowland.org> <4CDA7925.10707@ru.mvista.com> <20101116214652.GB18387@kroah.com>
In-Reply-To: <20101116214652.GB18387@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 01:46 PM, Greg KH wrote:
> On Wed, Nov 10, 2010 at 01:51:17PM +0300, Sergei Shtylyov wrote:
>> Hello.
>>
>> On 10-11-2010 5:36, Alan Stern wrote:
>>
>>>> In a previous patch in this series GregKH asked that the PCI ID not be added
>>>> to pci_ids.h for ID's that are only used by a single file.
>>>> Here is an updated version of the EHCI controller patch.
>>
>>>> Subject: [PATCH] ce4100: Add support for CE4100 EHCI IP block to EHCI driver
>>
>>>> This patch adds support for the EHCI IP block present on the Intel
>>>> CE4100.
>>
>>>> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
>>>> CC: linux-usb@vger.kernel.org
>>>> CC: David Brownell<dbrownell@users.sourceforge.net>
>>>> ---
>>>>   drivers/usb/host/ehci-pci.c |    4 ++++
>>>>   1 files changed, 4 insertions(+), 0 deletions(-)
>>
>>>> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
>>>> index a1e8d27..da2b196 100644
>>>> --- a/drivers/usb/host/ehci-pci.c
>>>> +++ b/drivers/usb/host/ehci-pci.c
>>>> @@ -124,6 +124,10 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
>>>>   			ehci_info(ehci, "disable lpm for langwell/penwell\n");
>>>>   			ehci->has_lpm = 0;
>>>>   		}
>>>> +		if (pdev->device == 0x2e70) {
>>>> +			hcd->has_tt = 1;
>>>> +			tdi_reset(ehci);
>>>> +		}
>>
>>> I think Greg meant that it's okay to use a symbolic constant for the
>>> PCI ID (it helps tell people what hardware is being handled).  Just
>>> don't add that constant to the pci_ids.h file.
>>
>>     Or at least you need a comment naming the hardware that this ID belongs to.
>
> I agree, something a bit better than just the device id might be nice
> here.
>
> Dirk, care to redo this one and your serial one, with that idea?
>
Yes, sorry for slow turn around been pulled in other random directions the last 
few days

--Dirk
