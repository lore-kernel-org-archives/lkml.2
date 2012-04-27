Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754Ab2D0Dv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 23:51:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52668 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759603Ab2D0Dv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 23:51:56 -0400
MIME-Version: 1.0
In-Reply-To: <4F99D994.5000404@fold.natur.cuni.cz>
References: <4F909CEB.3060407@fold.natur.cuni.cz>
	<CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com>
	<CAE9FiQUk8D20mEFPE0ahwfigbEOHpbRp-X0wt4DC+293msw=4Q@mail.gmail.com>
	<4F91473A.1080007@fold.natur.cuni.cz>
	<CAE9FiQUQRAfdG1J6XUVcOVkeR00vyqnCrBg1O3S_ByC3dKOUog@mail.gmail.com>
	<4F919C22.1070608@fold.natur.cuni.cz>
	<4F919CD5.7070004@fold.natur.cuni.cz>
	<CAE9FiQV_cRTDTBmQwNLJtT-N=HTAxBiphBLDmKxM-N0JKyoR-w@mail.gmail.com>
	<20120420231748.GB7069@xanatos>
	<CAE9FiQX7JCZvL9S8ZOQQaHQ4nfU0XDj=8FmOfCtcz7WFjP8=Bg@mail.gmail.com>
	<20120421132516.GC7069@xanatos>
	<CAE9FiQUuHrsNPhPWAc9koOrW6Xc+ryOhf_nv2ZyWvG9XMAdNoA@mail.gmail.com>
	<4F9711AA.1090803@fold.natur.cuni.cz>
	<CAE9FiQWFAYHTKtv1_MF-SYTrBxUg3zYbfuuxu2uGXHGmEYSf5A@mail.gmail.com>
	<4F99C74D.9050807@fold.natur.cuni.cz>
	<CAE9FiQVmnah5y1-+jAcB-0X424spO8vCNj-EjFTKpi+S=e_Low@mail.gmail.com>
	<4F99D994.5000404@fold.natur.cuni.cz>
Date: Thu, 26 Apr 2012 20:51:55 -0700
X-Google-Sender-Auth: 2YsWnRnYhqkbr3nTCb66nSGIK4A
Message-ID: <CAE9FiQXdPdk31gP0rVBFJnyroCX0NaVtFws6J34janZMrErqNA@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 4:26 PM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
> Yinghai Lu wrote:
>> On Thu, Apr 26, 2012 at 3:08 PM, Martin Mokrejs
>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>>
>>>
>>> Yinghai Lu wrote:
>>>>
>>>> Can you try boot the system without loading xhci driver ?
>>>
>>> Bingo! Physical express card removal started to be notified correctly.
>>
>> good, please get lspci -vvxxx -s 00:1c.7
>> before removing that express card
>> on both case.
>>
>> We can compare those two to find out why.
>
> Attached. Well, I told you in the very beginning of this looong thread it
> happens only with the USB3.0 card but not Firewire nor COM+LPT card. ;)

only have difference on DevStatus...

not sure how that card could make difference on surprise removal.

--- lspci_00.1c.7__card_inserted_no_xhci.txt    2012-04-26
20:41:43.000000000 -0700
+++ lspci_00.1c.7__card_inserted_with_xhci.txt  2012-04-26
20:41:48.000000000 -0700
@@ -15,7 +15,7 @@
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
-               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
+               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled-
Retrain- CommClk+
@@ -49,7 +49,7 @@
 10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
-40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
+40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 08
 50: 43 00 11 70 60 b2 3c 00 28 10 40 00 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
@@ -62,7 +62,7 @@
 e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 87 0f 06 08 00 00 00 00
 100: 00 00 00 00 00 00 00 00 00 40 00 00 11 00 06 00
-110: 01 00 00 00 00 20 00 00 00 00 00 00 00 00 00 00
+110: 00 00 00 00 00 20 00 00 00 00 00 00 00 00 00 00
 120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 130: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 140: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
