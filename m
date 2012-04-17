Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab2DQJeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 05:34:12 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:39713 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932082Ab2DQJeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 05:34:10 -0400
Message-ID: <4F8D390F.9050408@fold.natur.cuni.cz>
Date: Tue, 17 Apr 2012 11:34:07 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
References: <4F6A483D.50702@fold.natur.cuni.cz> <CAE9FiQVnErU-cska4gpinyj-LOup-U+3vsEG2z_-7h6kyREYtw@mail.gmail.com> <4F6A5A53.305@fold.natur.cuni.cz> <CAE9FiQXP7fO9OGN557jdofFFiFj96wL--ZA8X3UPEJ6o9JLvBw@mail.gmail.com> <4F8BEB1D.9080903@fold.natur.cuni.cz> <CAE9FiQXoX3J6P_9Tun_XbkK3egvSeBZxAtC13HacFDO0fwmZaA@mail.gmail.com> <4F8C6E4E.1000205@fold.natur.cuni.cz> <CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com> <CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com> <CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com> <4F8D1B72.2000105@fold.natur.cuni.cz> <CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com> <CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com>
In-Reply-To: <CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Tue, Apr 17, 2012 at 1:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Tue, Apr 17, 2012 at 12:27 AM, Martin Mokrejs
>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>>>
>>>> can you send out lspci -vvxxxx -s 00:1c.7 after removing USB 3.0 express card?
>>>
>>> No, that did not help (tried on 3.4-rc3). First I plugged in the NEC uPD720200 USB3.0 card
>>> and unplugged it (card removal not reported :(), saved the lspci output.
>>> Then I inserted the FireWire card, unplugged, again saved the lspci output.
>>> Finally, saved the dmesg. All three files are attached.
>>
>> for USB 3.0:
>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>>                        Changed: MRL- PresDet- LinkState+
> 
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
> BWMgmt+ ABWMgmt-
> 
> link still active even that card get removed, that looks like chipset
> have problem.

Yinghai,
  so what should I ask Dell for? To fix BIOS of the laptop? What exactly? Or do you think
this is a hardware issue with the chipset?

# lspci
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5)
00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b5)
00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b5)
00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5 (rev b5)
00:1c.7 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 8 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation HM67 Express Chipset Family LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
09:00.0 Network controller: Intel Corporation Centrino Wireless-N 1030 (rev 34)
0b:00.0 USB controller: Texas Instruments Device 8241 (rev 02)
#

Martin
