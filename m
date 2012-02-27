Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2B0Unn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 15:43:43 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42414 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab2B0Unl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 15:43:41 -0500
MIME-Version: 1.0
In-Reply-To: <20120227121932.24852506@jbarnes-desktop>
References: <1330206863-31381-1-git-send-email-yinghai@kernel.org>
	<1330206863-31381-5-git-send-email-yinghai@kernel.org>
	<20120227121932.24852506@jbarnes-desktop>
Date: Mon, 27 Feb 2012 12:43:41 -0800
X-Google-Sender-Auth: Ui9EevggtYWZYFjTJiGBli_Ewrw
Message-ID: <CAE9FiQWGRgKRynj6xBoWM3CABFH6QYii1TbHBg8-9Qyz_vR6YA@mail.gmail.com>
Subject: Re: [PATCH 4/4] PCI: acpihp user __pci_remove_bus_device instead
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 12:19 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Sat, 25 Feb 2012 13:54:23 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>> pci_stop_bus_device get called before in the same loop.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  drivers/pci/hotplug/acpiphp_glue.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/pci/hotplug/acpiphp_glue.c
>> +++ linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
>> @@ -910,7 +910,7 @@ static int disable_device(struct acpiphp
>>                               disable_bridges(pdev->subordinate);
>>                               pci_disable_device(pdev);
>>                       }
>> -                     pci_stop_and_remove_bus_device(pdev);
>> +                     __pci_remove_bus_device(pdev);
>>                       pci_dev_put(pdev);
>>               }
>>       }
>>
>
> Ok applied these.  How about another that converts in-tree users to
> pci_remove_bus_device and marks the __ version deprecated though?

thanks.

now the only user for  __pci_remove_bus_device is acpiphp

it will call stop bus devices at first, and then disable all bridges
and then call __pci_remove_bus_device.

not sure why it need  to disable all bridges.

     Yinghai
