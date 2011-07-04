Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1GDBJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 21:09:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46133 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1GDBJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 21:09:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110703135812I.fujita.tomonori@lab.ntt.co.jp>
References: <BANLkTi=OkgWYJz-29yALe=11L8_UEcBvfA@mail.gmail.com> <20110703135812I.fujita.tomonori@lab.ntt.co.jp>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Sun, 3 Jul 2011 19:09:09 -0600
Message-ID: <CAJfuBxxP1cOgJHW7ujGfeHE2CxDcoCe1qb5eZQWCgkyhgLYBWw@mail.gmail.com>
Subject: Re: dma-debug report/error on natsemi eth0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 2, 2011 at 11:06 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Thu, 30 Jun 2011 12:34:52 -0600
> Jim Cromie <jim.cromie@gmail.com> wrote:
>
>> since adding DMA-debug to my config, Ive been seeing these.
>> I suspect it goes back a ways..
>>
>> its on my list to do some investigating,
>> but I figured Id report in the meantime.
>>
>> ------------[ cut here ]------------
>> WARNING: at /home/jimc/projects/lx/linux-2.6/lib/dma-debug.c:820
>> check_unmap+0x1fe/0x56a()
>> natsemi 0000:00:06.0: DMA-API: device driver frees DMA memory with
>> different size [device address=0x0000000006ef0040] [map size=1538
>> bytes] [unmap size=1522 bytes]
>> Modules linked in: pc8736x_gpio pc87360 hwmon_vid scx200_gpio nsc_gpio
>> scx200_hrt scx200_acb i2c_core arc4 rtl8180 mac80211 eeprom_93cx6
>> cfg80211 pcspkr rfkill scx200 ide_gd_mod ide_pci_generic ohci_hcd
>> usbcore sc1200 ide_core
>> Pid: 870, comm: collector Not tainted 3.0.0-rc5-sk-00080-gca56a95 #1
>> Call Trace:
>>  [<c011a556>] warn_slowpath_common+0x4a/0x5f
>>  [<c02565cb>] ? check_unmap+0x1fe/0x56a
>>  [<c011a5cf>] warn_slowpath_fmt+0x26/0x2a
>
> The following patch silences the warning?


yes it does, thanks.

Reported-by: Jim Cromie <jim.cromie@gmail.com>
Tested-by: Jim Cromie <jim.cromie@gmail.com>

>
> diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
> index b78be08..1019379 100644
> --- a/drivers/net/natsemi.c
> +++ b/drivers/net/natsemi.c
> @@ -2360,7 +2360,8 @@ static void netdev_rx(struct net_device *dev, int *work_done, int work_to_do)
>                                        PCI_DMA_FROMDEVICE);
>                        } else {
>                                pci_unmap_single(np->pci_dev, np->rx_dma[entry],
> -                                       buflen, PCI_DMA_FROMDEVICE);
> +                                                buflen+NATSEMI_PADDING,
> +                                                PCI_DMA_FROMDEVICE);
>                                skb_put(skb = np->rx_skbuff[entry], pkt_len);
>                                np->rx_skbuff[entry] = NULL;
>                        }
>
