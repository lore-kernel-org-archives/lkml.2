Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab1DGI6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 04:58:46 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3021 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1DGI6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 04:58:44 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        =?utf-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
cc: "George Kashperko" <george@znau.edu.ua>, "Arnd Bergmann" <arnd@arndb.de>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
 <op.vtisojsk3ri7v4@arend-laptop>
 <BANLkTinubrmryu=Bco5_AVcj_arn7SWZxw@mail.gmail.com>
 <op.vti9ote53ri7v4@arend-laptop>
 <BANLkTin-u=U_-cUH9oCco0LjEBuQmh4wag@mail.gmail.com>
 <BANLkTi=x89+52cMeutOB7J--QQta+mX_wg@mail.gmail.com>
 <1302123428.20093.6.camel@maggie>
 <BANLkTimGSoYzp0Z4vyCS_H5PDKhgjYuLBA@mail.gmail.com>
 <1302124112.20093.11.camel@maggie>
 <BANLkTik76dwwnmmPzXL9Kkk7fdt01QPzZA@mail.gmail.com>
 <1302124737.27258.7.camel@dev.znau.edu.ua>
 <BANLkTi=4-LgrkjG96+Ar3SjMOsKh-dMuLg@mail.gmail.com>
 <1302134429.27258.32.camel@dev.znau.edu.ua>
 <BANLkTinfM0QLFwcKZXfWQ_jNYfBJg_et-Q@mail.gmail.com>
 <1302162886.10725.4.camel@maggie>
Date: Thu, 7 Apr 2011 10:58:25 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vtj8jn133ri7v4@arend-laptop>
In-Reply-To: <1302162886.10725.4.camel@maggie>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 6183A2EA3I87430941-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Apr 2011 09:54:46 +0200, Michael Büsch <mb@bu3sch.de> wrote:

>> Ahh, so while talking about 4 windows, I guess you counted fixes
>> windows as well. That would be right, matching my knowledge.
>>
>> When asking question about amount of cores we may want to use
>> simultaneously I didn't think about ChipCommon or PCIe. The real
>> problem would be to support for example two 802.11 cores and one
>> ethernet core at the same time. That gives us 3 cores while we have
>> only 2 sliding windows.
>
> Would that really be a problem? Think of it. This combination
> will only be available on embedded devices. But do we have windows
> on embedded devices? I guess not. If AXI is similar to SSB, the MMIO
> of all cores will always be mapped. So accesses can be done
> without switch or lock.

Agree. For embedded systems there is no need to switch cores. Each core  
register space and wrapper register space is mapped. In the brcm80211 we  
have the concept of fast versus slow host interface. The criteria for fast  
host interface is based on following expression:

fast_host_bus = (host_bus_coretype == PCIE_CORE_ID) ||
	((host_bus_coretype == PCI_CORE_ID) && (host_bus_corerev >= 13))

If this is true, chipcommon and pci/pcie registers are accessed without  
sliding the window using the fixed offsets Rafał mentioned earlier. The  
BAR0 window size is 16KB.

> I do really think that engineers at broadcom are clever enough
> to design a hardware that does not require expensive window sliding
> all the time while operating.
>

If a bigger window is clever enough ;-)

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

