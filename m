Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2DQIqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 04:46:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51077 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab2DQIqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 04:46:01 -0400
MIME-Version: 1.0
In-Reply-To: <4F8D1B72.2000105@fold.natur.cuni.cz>
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
Date: Tue, 17 Apr 2012 01:46:01 -0700
X-Google-Sender-Auth: vFiB7abT17Vpi7gBkappv3_Kujg
Message-ID: <CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 12:27 AM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
>>
>> can you send out lspci -vvxxxx -s 00:1c.7 after removing USB 3.0 express card?
>
> No, that did not help (tried on 3.4-rc3). First I plugged in the NEC uPD720200 USB3.0 card
> and unplugged it (card removal not reported :(), saved the lspci output.
> Then I inserted the FireWire card, unplugged, again saved the lspci output.
> Finally, saved the dmesg. All three files are attached.

for USB 3.0:
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+

PresDet+: mean that card is still there. so no interrupt is generated
by chipset.

that present bit is decide by by inband link or out of band.

sometimes when out of band pres is no, present bit could be keep flip
around because in root port try to retrain to detect ...
but it is not the case.

the pin "CPPE#  PCI Express interface presence detect" should get into
hotplug FPGA in motherboard.

You may need to check with vendor about if there is any problem with
that hotplug FPGA.

        Yinghai
