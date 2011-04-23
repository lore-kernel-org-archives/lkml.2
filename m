Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab1DWPHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 11:07:48 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1732 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab1DWPHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 11:07:46 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
To: "Jonas Gorski" <jonas.gorski@gmail.com>
cc: "Arnd Bergmann" <arnd@arndb.de>, "zajec5@gmail.com" <zajec5@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "George Kashperko" <george@znau.edu.ua>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Andy Botting" <andy@andybotting.com>, "Greg KH" <greg@kroah.com>,
        "Michael Buesch" <m@bues.ch>
Subject: Re: [PATCH] drivers: brcmaxi: provide amba axi functionality in
 separate module
References: <1303331669-31293-1-git-send-email-arend@broadcom.com>
 <201104211612.49805.arnd@arndb.de> <op.vuallvn63ri7v4@arend-laptop>
 <BANLkTinUWNvkigqkOQeYsyaAKnVXOCji8w@mail.gmail.com>
Date: Sat, 23 Apr 2011 17:07:19 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vuecahou3ri7v4@arend-laptop>
In-Reply-To: <BANLkTinUWNvkigqkOQeYsyaAKnVXOCji8w@mail.gmail.com>
User-Agent: Opera Mail/11.10 (Linux)
X-WSS-ID: 61AC347A3CK20952215-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011 14:33:21 +0200, Jonas Gorski <jonas.gorski@gmail.com>  
wrote:

> On 21 April 2011 16:38, Arend van Spriel <arend@broadcom.com> wrote:
>> Would it be possible to make chipcommon driver optional (not doing the
>> initialization)?
>
> This would need to be done on a per-device/bus basis, at least for
> embedded. Consider the following setup (which is quite common for dual
> band routers):
>
> BCM4718 (bus A)
   +- MIPS74k
> +- Common Core <- provides flash write access, GPIOs, watchdog, ...
> +- 802.11 Core <- for 2.4Ghz wifi
> +- PCIe Core
>   + BCM43224 (bus B)
>     +- Common Core
>     +- 802.11 Core <- for 5Ghz wifi
>
> (I omitted any cores not relevant for the example)

The MIPS may be relevant as well ;-)

In the example above I would expect two axi bus driver instances for bus A  
and bus B.

> So eventually you want to able to drive both 802.11 cores, but can't
> exclusively claim both common cores.

I would expect to be probed twice. One call for 2.4GHz 802.11 core  
referencing to bus A and one call for 5GHz 802.11 core referencing to bus  
B.

Regarding chipcommon I agree that it requires one init sequence per  
device. I would just like to have the option to provide a custom  
initialization function for chip common (and possibly pcie) somehow.

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft

