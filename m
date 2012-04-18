Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2DRTsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:48:24 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:33496 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab2DRTsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:48:19 -0400
MIME-Version: 1.0
In-Reply-To: <4F8EFFA3.3050705@fold.natur.cuni.cz>
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
	<CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com>
	<4F8EFFA3.3050705@fold.natur.cuni.cz>
Date: Wed, 18 Apr 2012 12:48:18 -0700
X-Google-Sender-Auth: wxF1Vlrdh8qzOXh_k3cVndOhI3M
Message-ID: <CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com>
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

On Wed, Apr 18, 2012 at 10:53 AM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
>> After you remove USB3 expresscard, you need to
>>
>> echo 1 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>> then
>> echo 0 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>
> So without these two echo commands the is no improvement/fix.
>
> [  686.701306] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  686.701316] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  686.701319] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
> [  686.701357] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  686.701390] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
> [  686.809763] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
...
> [  686.833678] hub 6-0:1.0: 2 ports detected
>
> echo 1 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>
> [  716.999938] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 53
> [  717.024647] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  717.024657] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  717.024665] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
> [  717.024723] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  717.024753] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
> [  717.024756] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
..
> [  717.045197] pci 0000:11:00.0: freeing pci_dev info
>
> echo 0 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>
> [  748.456914] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 40
>

so it is chipset problem, it does not detect and report the presence
of the card after that link is removed.

Can you try to use acpiphp instead of pciehp?

Yinghai
