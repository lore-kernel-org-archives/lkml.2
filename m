Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab1IINAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:00:50 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:43373 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758817Ab1IINAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:00:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAOULuOax5OX-oZKBdEuBGVQaSX55sQY8tbKAPD-WFKEr7fRNtQ@mail.gmail.com>
References: <CAC9WiBg8ecC0oborzCH=0oaok2FK7QvZhV_UNAxFPkVJ+wFP=Q@mail.gmail.com>
	<CAOULuOb41-TZuN=kj6whg_wn4cw3k01K3aHJ_X9Ha4iTD3ainw@mail.gmail.com>
	<CAC9WiBhbXN86sFPBp9Q8tP6ZPUxMZHsi0fFs1T=Y+1FfGusGxQ@mail.gmail.com>
	<CAOULuOax5OX-oZKBdEuBGVQaSX55sQY8tbKAPD-WFKEr7fRNtQ@mail.gmail.com>
Date: Fri, 9 Sep 2011 15:00:47 +0200
Message-ID: <CAC9WiBiWsxCqnGUMHUKKWrLp+XLxOf=+53XLFmaYOeOQWDFSeA@mail.gmail.com>
Subject: Re: Some issues/regression when upgrading to 3.1-rc5
From: Francis Moreau <francis.moro@gmail.com>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 1:58 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> Hi
>
> On Wed, Sep 7, 2011 at 2:51 AM, Francis Moreau <francis.moro@gmail.com> wrote:
>> Hello,
>>
>> On Wed, Sep 7, 2011 at 12:24 AM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>>> On Tue, Sep 6, 2011 at 5:15 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>>>>
>>>> [   13.335961] cfg80211: Calling CRDA to update world regulatory domain
>>>> [   13.386127] b43-phy0: Broadcom 4313 WLAN found (core revision 24)
>>>> [   13.510112] bcma: PLL enable timeout
>>>> [   13.510125] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 10, Type
>>>> 8, Revision 1)
>>>> [   13.510148] b43: probe of bcma0:0 failed with error -95
>>>> [   13.510194] Broadcom 43xx driver loaded [ Features: PMNLS,
>>>> Firmware-ID: FW13 ]
>
>>
>> unloading b43/bcma and loading brcmsmac doesn't help. Looks like the
>> latter doesn't support my card anymore.
>>
>> From dmesg:
>>
>> [ 3828.183927] brcmsmac: module is from the staging directory, the
>> quality is unknown, you have been warned.
>>
>> and that's it.
>
> 4313 is supported in brcmsmac - are you sure the firmware is at the
> right place and getting loaded?

Ok the issue was that I need to unload b43 _and_ bcma before loading brcmsmac.

> I recall for example having to deal with firmware in kernel specific
> directory - /lib/`uname -r`/firmware for example which means you will
> need to copy the firmware to new kernel specific directory.
>
> Secondly try to make sure b43/bcma are blacklisted and never loaded at all.
>

Well IMHO, there's a probleme here: b43/bcma claims some devices
(notably 4313) which is marked as broken ! Well that's not quite
exact, actually it's the phy dev used with the 4313 which is marked as
broken, see CONFIG_B43_PHY_LCN in drivers/net/wireless/b43/Kconfig.

I posted an email on linux-wireless mailing list but haven't got any
answer so far.

Thanks
-- 
Francis
