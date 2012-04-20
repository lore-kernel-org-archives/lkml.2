Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab2DTQBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:01:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54717 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab2DTQBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:01:47 -0400
MIME-Version: 1.0
In-Reply-To: <4F91473A.1080007@fold.natur.cuni.cz>
References: <4F6A483D.50702@fold.natur.cuni.cz>
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
	<CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com>
	<CAE9FiQUk8D20mEFPE0ahwfigbEOHpbRp-X0wt4DC+293msw=4Q@mail.gmail.com>
	<4F91473A.1080007@fold.natur.cuni.cz>
Date: Fri, 20 Apr 2012 09:01:46 -0700
X-Google-Sender-Auth: ePUN_GZ9lyShL4VXrx2ePMQcoTE
Message-ID: <CAE9FiQUQRAfdG1J6XUVcOVkeR00vyqnCrBg1O3S_ByC3dKOUog@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 4:23 AM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
> Yinghai Lu wrote:
>> On Thu, Apr 19, 2012 at 2:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Thu, Apr 19, 2012 at 4:16 PM, Martin Mokrejs
>>>> I just tried something similar under linux, with all the patches I accumulated for 3.4-rc3
>>>> and posted in my previous emails. It seems linux flips some value so on every second card
>>>> removal it really does realize it was just unplugged.
>>>
>>> that is really looks like silicon problem.
>>>
>> please check attached patch. Hope link change bit is flip around...
>> if there is change, we could add some logic:
>>    check if the device is there, or will reset link to normal state.
>
> I don't think it helped but maybe you will see some difference:

No, the interrupt still get delayed.

>
> Complete dmesg is attached. OK, the "60sec" delay is when xhci_hcd gives away its attempts.
> I am not knowlegeable of the kernel at all but it is my impression that because of the
> card presence detection there is no way to prevent that. But, if I get it right, now when I
> pluging the card+USB disk in it into the computer before those "60sec" it gets detected,
> so my problem is gone (xhci cancels the timeout because a "new card" was popped in with a "new"
> device.
>
> So, although I am now not sure whether I need your last patch, for the practical purpose that
> I want to plugin a new card with a device into my computer, it works now. (added Sarah Sharp
> into CC: just to make her aware of this scenario, no problem with xhci_hcd in my eyes)
> ;)

please try to "safely remove the card" before removing the card physically like:

echo 1 > /sys/bus/pci/devices/0000:11:00.0/remove

that will stop the drivers and remove pci device in the kernel.

Yinghai
