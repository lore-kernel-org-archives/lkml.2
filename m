Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab2ECMTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:19:23 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:43659 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab2ECMTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:19:22 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApB8AOR2ok9V5qg+PGdsb2JhbABFii+nUQSBIBkBAQEBNzSCCQEBBAE6HCMFCwgDRhQlChouh20JunQTixWEfWMElX2GBo0n
X-IronPort-AV: E=Sophos;i="4.75,524,1330902000"; 
   d="scan'208";a="109348764"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 3 May 2012 14:23:59 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephane Chatty <chatty@enac.fr>
Subject: Re: [PATCH v3 0/6] hid: Introduce device groups
Message-ID: <20120503122359.GA11552@polaris.bitmath.org>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1205011300540.1856@pobox.suse.cz>
 <CAN+gG=GGVFDgf_PkovS+_OX26LH0Q19_FwwkGP2pSwnoX4d_Ug@mail.gmail.com>
 <alpine.LNX.2.00.1205021044240.14613@pobox.suse.cz>
 <CAN+gG=HHxzYPSD+1i5JS8HmkxusHi=e6im48VzXHy2KsFoce+w@mail.gmail.com>
 <CAN+gG=HDZJf+73SoddWar_pRPH2NvFrvpVuAaRC8_frXmGQYfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=HDZJf+73SoddWar_pRPH2NvFrvpVuAaRC8_frXmGQYfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm currently on the bug fix I told you earlier. However, I found a
> more problematic bug in the hid_groups functionality.
> 
> Some device, like the Perixx peripad, present several interfaces
> (mouse, keyboard and multitouch).
> The hid groups functionality detects the HID field Contact ID, and
> then forwards all interfaces to hid-multitouch. The point is that
> hid-multitouch does not know how to handle mice and keyboards, and
> then fails handling the interfaces of the device.

I am a bit unclear as to which devices this applies to, but I see two
possible solutions:

1) Add the devices in question back to the have_special_drivers list.

2) Add the interface type to the group descision, which should
probably be done anyway. I have a patch in the pipe that, will send it
later today.

> This particular device is then fully broken (as anyone pumped the events).
> I also noticed the same problem (but less problematic) with cypress
> panels: it presents different vendor interfaces and they are handled
> by hid-multitouch.

It would be great if you could test soution 1) before on a device -
something seems wrong if those interfaces were handled by hid-generic
before, but before getting the logic straight, it does not hurt to
try. :-)

Thanks,
Henrik
