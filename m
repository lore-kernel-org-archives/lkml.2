Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1EQRe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:34:28 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3714 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab1EQRe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:34:27 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4DD2B178.3050907@broadcom.com>
Date: Tue, 17 May 2011 19:33:44 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "Greg KH" <greg@kroah.com>,
        =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "George Kashperko" <george@znau.edu.ua>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King" <rmk@arm.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
        "Andy Botting" <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V7] bcma: add Broadcom specific AMBA bus driver
References: <1304960206-8832-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1304960206-8832-1-git-send-email-zajec5@gmail.com>
X-WSS-ID: 61CC6DD63IC2396796-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2011 06:56 PM, Rafał Miłecki wrote:
> Broadcom has released cards based on a new AMBA-based bus type. From a
> programming point of view, this new bus type differs from AMBA and does
> not use AMBA common registers. It also differs enough from SSB. We
> decided that a new bus driver is needed to keep the code clean.
>
> In its current form, the driver detects devices present on the bus and
> registers them in the system. It allows registering BCMA drivers for
> specified bus devices and provides them basic operations. The bus driver
> itself includes two important bus managing drivers: ChipCommon core
> driver and PCI(c) core driver. They are early used to allow correct
> initialization.
>
> Currently code is limited to supporting buses on PCI(e) devices, however
> the driver is designed to be used also on other hosts. The host
> abstraction layer is implemented and already used for PCI(e).
>
> Support for PCI(e) hosts is working and seems to be stable (access to
> 80211 core was tested successfully on a few devices). We can still
> optimize it by using some fixed windows, but this can be done later
> without affecting any external code. Windows are just ranges in MMIO
> used for accessing cores on the bus.
Hi Rafał,

Just some minor feedback on coding style. I wanted to make a change in 
host_pci.c to avoid changing the PCI BAR window and noticed following:
1. indentation is all spaces.
2. initial indent is 7 spaces, and subsequent indents are 8 spaces.
3. pointer assignment: ptr =&var;
4. output parameter: foo(bar,&yabar);

I am not sure whether checkpatch.pl triggers on any of these, but can we 
fix at least items 1) and 2).

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


