Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab2DQCsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 22:48:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39660 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2DQCsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 22:48:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com>
References: <4F6A483D.50702@fold.natur.cuni.cz>
	<CAE9FiQVnErU-cska4gpinyj-LOup-U+3vsEG2z_-7h6kyREYtw@mail.gmail.com>
	<4F6A5A53.305@fold.natur.cuni.cz>
	<CAE9FiQXP7fO9OGN557jdofFFiFj96wL--ZA8X3UPEJ6o9JLvBw@mail.gmail.com>
	<4F8BEB1D.9080903@fold.natur.cuni.cz>
	<CAE9FiQXoX3J6P_9Tun_XbkK3egvSeBZxAtC13HacFDO0fwmZaA@mail.gmail.com>
	<4F8C6E4E.1000205@fold.natur.cuni.cz>
	<CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com>
	<CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com>
Date: Mon, 16 Apr 2012 19:48:43 -0700
X-Google-Sender-Auth: P_ZMaIXEPRmWMgioOpYiUDlu65M
Message-ID: <CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 6:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Apr 16, 2012 at 1:53 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Mon, Apr 16, 2012 at 12:09 PM, Martin Mokrejs
>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>>>>> On Wed, Mar 21, 2012 at 3:46 PM, Martin Mokrejs
>>>>>   I had some Ooopses with 3.4-rc2 but now I have tested 3.4-rc3. Still, linux
>>>>> does NOT realize that I have removed an ExpressCard from the slot. It realizes
>>>>> that only when I pluging the card back again. Actually, this is a case of a
>>>>> NEC chipset base USB3.0 card.
>>>>>
>>>>>  In contrast, kernel DOES recognize that I unplugged a FireWire card from the
>>>>> same slot.
>>>>>
>>>>>  This is a Dell Vostro 3550 laptop. Below is what syslog logged with my comment.
>>>>> Empty lines between the log entries are inserted whe I either inserted or removed
>>>>> a card. Probably a bit more will be in the attached dmesg file.
>>
>> so the interrupt for removal get generated, but pcie_isr() is delayed
>> when another surprise is generated...
>>
>
> please try to revert
> commit 486b10b9f43500741cd63a878d0ef23cd87fc66d
> Author: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Date:   Mon Nov 7 20:56:50 2011 +0900
>
>    PCI: pciehp: Handle push button event asynchronously
>
>    Use non-ordered workqueue for attention button events.
>
>    Attention button events on each slot can be handled asynchronously. So
>    we should use non-ordered workqueue. This patch also removes ordered
>    workqueue in pciehp as a result.
>
> to see if there is any difference.

can you send out lspci -vvxxxx -s 00:1c.7 after removing USB 3.0 express card?

Yinghai
