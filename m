Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab2DSB6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 21:58:01 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37978 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2DSB57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 21:57:59 -0400
MIME-Version: 1.0
In-Reply-To: <4F8F4655.9000004@fold.natur.cuni.cz>
References: <4F6A483D.50702@fold.natur.cuni.cz>
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
	<CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com>
	<4F8F243B.70906@fold.natur.cuni.cz>
	<CAE9FiQXx1NcGY9cHDiM5isx7NyxWN--Exb-4Gfj0arr6vf5ghQ@mail.gmail.com>
	<4F8F4655.9000004@fold.natur.cuni.cz>
Date: Wed, 18 Apr 2012 18:57:59 -0700
X-Google-Sender-Auth: -ZlStNQWWphg4WQXBOOJxwdzS3o
Message-ID: <CAE9FiQWhbXPnxCAtsgL4FYqTZgqzosSdzEJCW7-11ooDNY2g8w@mail.gmail.com>
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

On Wed, Apr 18, 2012 at 3:55 PM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
>
>>>> Can you try to use acpiphp instead of pciehp?
>>>
>>> Umm. I do have acpiphp in my kernel already. I am rather attaching my .config,
>>> please me know what you want me to do. My kernel command line could be seen
>>> in my previous posts in the dmesg file.
>>
>> remove
>>
>> CONFIG_HOTPLUG_PCI_PCIE=y
>
> The express card slot seems "dead", nothing happens when I plugin the card.
> I have attached the lspci of the bridge (when card p[lugged in), in case there is
> something of interest to you. ;-) Same for dmesg.
>
>
>
> # grep HOTPLUG /usr/src/linux-3.4-rc3__patches_yinghai_jeff_garzik/.config
> CONFIG_HOTPLUG=y
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_HOTPLUG_CPU=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_ACPI_HOTPLUG_CPU=y
> # CONFIG_HOTPLUG_PCI_PCIE is not set
> CONFIG_HOTPLUG_PCI=y
> # CONFIG_HOTPLUG_PCI_FAKE is not set
> CONFIG_HOTPLUG_PCI_ACPI=y
> # CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
> # CONFIG_HOTPLUG_PCI_CPCI is not set
> CONFIG_HOTPLUG_PCI_SHPC=m
> #
>
>
> The echo commands just do:
>
> [  616.477711] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 53
> [  637.242990] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 43
> [  641.791748] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 52
> [  654.317009] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 42
> [  664.238154] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 52
> [  686.101576] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 43
>

looks your BIOS does not support acpiphp.

Maybe you have to stay with

echo 1  > .../pcie_link_disable
echo 0  > .../pcie_link_disable

after removal every time.

Yinghai
