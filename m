Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab2DQTCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:02:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54153 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2DQTCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:02:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com>
References: <4F6A483D.50702@fold.natur.cuni.cz>
	<CAE9FiQVnErU-cska4gpinyj-LOup-U+3vsEG2z_-7h6kyREYtw@mail.gmail.com>
	<4F6A5A53.305@fold.natur.cuni.cz>
	<CAE9FiQXP7fO9OGN557jdofFFiFj96wL--ZA8X3UPEJ6o9JLvBw@mail.gmail.com>
	<4F8BEB1D.9080903@fold.natur.cuni.cz>
	<CAE9FiQXoX3J6P_9Tun_XbkK3egvSeBZxAtC13HacFDO0fwmZaA@mail.gmail.com>
	<4F8C6E4E.1000205@fold.natur.cuni.cz>
	<CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com>
	<CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com>
	<CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com>
	<4F8D1B72.2000105@fold.natur.cuni.cz>
	<CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com>
	<CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com>
	<4F8D390F.9050408@fold.natur.cuni.cz>
	<CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com>
Date: Tue, 17 Apr 2012 12:02:04 -0700
X-Google-Sender-Auth: qSdoNpoewNwtFdd0q6HbmRyv2jE
Message-ID: <CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 10:07 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Apr 17, 2012 at 2:34 AM, Martin Mokrejs
> <mmokrejs@fold.natur.cuni.cz> wrote:
>> Yinghai Lu wrote:
>>> On Tue, Apr 17, 2012 at 1:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>> On Tue, Apr 17, 2012 at 12:27 AM, Martin Mokrejs
>>>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>>>>>
>>>>>> can you send out lspci -vvxxxx -s 00:1c.7 after removing USB 3.0 express card?
>>>>>
>>>>> No, that did not help (tried on 3.4-rc3). First I plugged in the NEC uPD720200 USB3.0 card
>>>>> and unplugged it (card removal not reported :(), saved the lspci output.
>>>>> Then I inserted the FireWire card, unplugged, again saved the lspci output.
>>>>> Finally, saved the dmesg. All three files are attached.
>>>>
>>>> for USB 3.0:
>>>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>>>>                        Changed: MRL- PresDet- LinkState+
>>>
>>> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
>>> BWMgmt+ ABWMgmt-
>>>
>>> link still active even that card get removed, that looks like chipset
>>> have problem.
>>
>> Yinghai,
>>  so what should I ask Dell for? To fix BIOS of the laptop? What exactly? Or do you think
>> this is a hardware issue with the chipset?
>
> after the expresscard get removed, that root port socket status bits
> still report Data Link Active, and
> the card still present.
>
> Better check with Dell at first, and ask them to talk with intel if
> there is silicon bug with that chipset that report wrong status.
>
> Let me check if i could rebase one my local patch do reset pcie link
> to prove that problem it silicon related.

Rebase patches about pcie link disable/enable in /sys. please check them at

 git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-pci-test

  PCI, sysfs: merge dev and bus cpuaffinity show handling
  PCI, sys: Use is_visable() with boot_vga attribute for pci_dev
  PCI, sysfs: Put resource_alignment info pci_bus_attrs array
  PCI: Move pcie_link_disable to pcie-link.c
  PCI, sysfs: Add pcie attrs for pcie device under pci dev dir.
  PCI: Add link_disable in /sysfs for pcie device

it is based on for-pci-root-bus-hotplug branch

Or you can just master branch like
git clone git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git

After you remove USB3 expresscard, you need to

echo 1 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
then
echo 0 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable

Thanks

Yinghai
