Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1IGQKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:10:20 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48303 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab1IGQKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:10:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAC9WiBhbXN86sFPBp9Q8tP6ZPUxMZHsi0fFs1T=Y+1FfGusGxQ@mail.gmail.com>
References: <CAC9WiBg8ecC0oborzCH=0oaok2FK7QvZhV_UNAxFPkVJ+wFP=Q@mail.gmail.com>
	<CAOULuOb41-TZuN=kj6whg_wn4cw3k01K3aHJ_X9Ha4iTD3ainw@mail.gmail.com>
	<CAC9WiBhbXN86sFPBp9Q8tP6ZPUxMZHsi0fFs1T=Y+1FfGusGxQ@mail.gmail.com>
Date: Wed, 7 Sep 2011 07:58:41 -0400
Message-ID: <CAOULuOax5OX-oZKBdEuBGVQaSX55sQY8tbKAPD-WFKEr7fRNtQ@mail.gmail.com>
Subject: Re: Some issues/regression when upgrading to 3.1-rc5
From: Parag Warudkar <parag.lkml@gmail.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Sep 7, 2011 at 2:51 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> On Wed, Sep 7, 2011 at 12:24 AM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>> On Tue, Sep 6, 2011 at 5:15 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>>>
>>> [   13.335961] cfg80211: Calling CRDA to update world regulatory domain
>>> [   13.386127] b43-phy0: Broadcom 4313 WLAN found (core revision 24)
>>> [   13.510112] bcma: PLL enable timeout
>>> [   13.510125] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 10, Type
>>> 8, Revision 1)
>>> [   13.510148] b43: probe of bcma0:0 failed with error -95
>>> [   13.510194] Broadcom 43xx driver loaded [ Features: PMNLS,
>>> Firmware-ID: FW13 ]

>
> unloading b43/bcma and loading brcmsmac doesn't help. Looks like the
> latter doesn't support my card anymore.
>
> From dmesg:
>
> [ 3828.183927] brcmsmac: module is from the staging directory, the
> quality is unknown, you have been warned.
>
> and that's it.

4313 is supported in brcmsmac - are you sure the firmware is at the
right place and getting loaded?
I recall for example having to deal with firmware in kernel specific
directory - /lib/`uname -r`/firmware for example which means you will
need to copy the firmware to new kernel specific directory.

Secondly try to make sure b43/bcma are blacklisted and never loaded at all.

Can't think of any other reason why it would suddenly stop working.

Hope this helps,

Parag
