Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab0DPUDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 16:03:33 -0400
Received: from mail.atheros.com ([12.36.123.2]:50081 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab0DPUDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 16:03:31 -0400
From: David Quan <David.Quan@Atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "yanmin.zhang@intel.com" <yanmin.zhang@intel.com>,
       "shaohua.li@intel.com" <shaohua.li@intel.com>,
       Sameer Nanda <snanda@google.com>,
       Jonathan May <Jonathan.May@Atheros.com>
Date: Fri, 16 Apr 2010 13:03:28 -0700
Subject: RE: Power consumption on 802.11 / ASPM / device measurements
Thread-Topic: Power consumption on 802.11 / ASPM / device measurements
Thread-Index: Acrdnpa/fmhWDcq7QGaTqJSKBSQYggAAMLUg
Message-ID: <93781E992CBA7843962D8B0E7D683F3C1116A1A28B@SC1EXMB-MBCL.global.atheros.com>
References: <n2q43e72e891004161253wbb9afe61y539206f010e91a78@mail.gmail.com>
In-Reply-To: <n2q43e72e891004161253wbb9afe61y539206f010e91a78@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is a very complicated issue.
Different system have different limitation.
it is not a one size fits all.


So we let the BIOS of each system with the different chipset control this, and we work with that team
to make sure the correct settings work together for both RC and endpoint.

It should not be controlled by the endpoint as endpoint can get plug into many different systems and endpoint 
will not know the limitations of each system/chipset in the system.

I highly recommend you all not to touch the aspm settings from the endpoint, point of view and let the system bios 
do what it has been programmed to do.

David


-----Original Message-----
From: Luis R. Rodriguez [mailto:mcgrof@gmail.com] 
Sent: Friday, April 16, 2010 12:54 PM
To: linux-wireless
Cc: linux-kernel@vger.kernel.org; yanmin.zhang@intel.com; shaohua.li@intel.com; Sameer Nanda; Jonathan May; David Quan
Subject: Power consumption on 802.11 / ASPM / device measurements

We've been accumulating a few power consumption related documents on
the wireless wiki for a while now. One which I saw was missing was for
actual power consumption and review of new PCI-E features which should
be taken into consideration when debugging power consumption or
reviewing it. ASPM is something that I can say I found little to no
documentation for when looking into it so I've done a brain dump of
what I recall from it, the code review of it, and some e-mail
exchanges I've had with Jonathan May @ Atheros.

I've stashed together all the power consumption docs at:

http://wireless.kernel.org/en/users/Documentation/Power-consumption

You'll see there some ASPM docs now and some ath9k specific power
consumption metrics/ASPM details. Please review and enhance as you see
fit.

Yanmin, Shaohua, I see CONFIG_PCIEASPM still marked as experimental,
I'm curious if this is still really that experimental and if there are
plans for it go out of experimental. Also I am little puzzled with
some of the aspm.c code, I see we fill the pci device struct with
capability stuff via pcie_aspm_cap_init() but I also see ASPM
capability stuff exposed on kernels without CONFIG_PCIEASPM (albeit I
see it always disabled on my system at home), so are we filling the
capability elsewhere? I think there are some boxes without this kernel
config enabled and where ASPM capability info is exposed and does show
up as enabled, could be wrong.

Also curious -- how often are BIOSes buggy enough for ASPM to get
disabled by mistake on the modern devices? And for systems that have
no Bios (*cough* ChromeOS) how is this handled?

 Luis
