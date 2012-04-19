Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab2DSVsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:48:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50745 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225Ab2DSVs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:48:26 -0400
MIME-Version: 1.0
In-Reply-To: <4F909CEB.3060407@fold.natur.cuni.cz>
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
	<4F909CEB.3060407@fold.natur.cuni.cz>
Date: Thu, 19 Apr 2012 14:48:25 -0700
X-Google-Sender-Auth: hpyIjoFIA_7Q2whYM_3bzEKqITQ
Message-ID: <CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 4:16 PM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
>
>
> Yinghai Lu wrote:
>> On Wed, Apr 18, 2012 at 1:29 PM, Martin Mokrejs
>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>> Yinghai Lu wrote:
>>>> On Wed, Apr 18, 2012 at 10:53 AM, Martin Mokrejs
>>>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>>>>> After you remove USB3 expresscard, you need to
>>>>>>
>>>>>> echo 1 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>>>>> then
>>>>>> echo 0 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>>>>
>>
>> sometimes it report correctly. sometime it does not.
>
> I realized with Win 7 that if the Express Card with the two USB 3.0 ports has an external drive
> connected, its removal gets "always" detected. Probably because USB is polling for the disk and
> realizes that is is gone?
>
> Second observation is that in Device manager if I open the USB controllers list, I see for
> this card a USB HUB and a USB controller (two lines in the listig). If I remove the card
> the listing doesn't get updated. When I open the ROOT HUB properties, on the General tab
> is claimed that it is working well and the system does not realize the card is unplugged
> a long while already. But, if I open properties of the HOST CONTROLLER, it I think updates
> the "General tab" and says something about code 45. And after closing tgis HOST CONTROLLER
> window, the Device manager windows gets refreshed and the two lines related to the card
> disappear.

ok, other OS have same problem.

>
>
>
> I just tried something similar under linux, with all the patches I accumulated for 3.4-rc3
> and posted in my previous emails. It seems linux flips some value so on every second card
> removal it really does realize it was just unplugged.
...

that is really looks like silicon problem.

> Maybe the above is helpful?
> Martin
> P.S.: Meanwhile am waiting for an answer from Dell.

thinkpad 420 only can use acpiphp, because bios does give PCI CAP
control to OS via _OSC, pciehp could not used.

Yinghai
