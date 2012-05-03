Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2ECNuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:50:16 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:47814 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2ECNuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:50:14 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiZ3AAqMok9V5qg+PGdsb2JhbABEii+nIASBIRkBAQEBNzSCCQEBBAE6HCMFCwgDRhQlChouh20Juj0TixWEfWMElX2GBo0n
X-IronPort-AV: E=Sophos;i="4.75,524,1330902000"; 
   d="scan'208";a="104721918"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 3 May 2012 15:54:52 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephane Chatty <chatty@enac.fr>
Subject: Re: [PATCH v3 0/6] hid: Introduce device groups
Message-ID: <20120503135452.GA12050@polaris.bitmath.org>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1205011300540.1856@pobox.suse.cz>
 <CAN+gG=GGVFDgf_PkovS+_OX26LH0Q19_FwwkGP2pSwnoX4d_Ug@mail.gmail.com>
 <alpine.LNX.2.00.1205021044240.14613@pobox.suse.cz>
 <CAN+gG=HHxzYPSD+1i5JS8HmkxusHi=e6im48VzXHy2KsFoce+w@mail.gmail.com>
 <CAN+gG=HDZJf+73SoddWar_pRPH2NvFrvpVuAaRC8_frXmGQYfA@mail.gmail.com>
 <20120503122359.GA11552@polaris.bitmath.org>
 <CAN+gG=GS_aQ35ekF71oCjZXquB4X3xJvzq2_fT2d7nM+iBK=Zg@mail.gmail.com>
 <20120503131904.GA11741@polaris.bitmath.org>
 <CAN+gG=GU8NGJ70Yx8_roeA4LCohcmym7wEspbv4d_xMqbrP5hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=GU8NGJ70Yx8_roeA4LCohcmym7wEspbv4d_xMqbrP5hw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > 2) Add the interface type to the group descision, which should
> >> > probably be done anyway. I have a patch in the pipe that, will send it
> >> > later today.
> >>
> >> A simpler solution consists in adding the macros HID_USB_MT_DEVICE(v,
> >> p) and HID_BLUETOOTH_MT_DEVICE(v, p) as you had introduced in a
> >> earlier patch (I don't know why it disappeared).
> >
> > No, the specific entries in the hid-multitouch device list matches any
> > group, so those defines were simplified away in the second version.
> 
> disagree: a device can present several interface (because it has
> several "devices") and only those presenting Contact ID can and should
> be handled by hid-multitouch.

Obviously this is only a problem for the devices with mixed
interfaces, but for those, solution 2) together with specifying the
group as you suggest should work. We can definitely change all devices
in the list, it just was not necessary before (or so I thought).

> The think is that they do match hid-generic (they get the group
> HID_GROUP_GENERIC).
> However they also match hid-multitouch (as hid-multitouch does not ask
> for a particular group). So, if hid-multitouch is loaded __before__
> hid-generic, it will be given the device whatever the match with
> hid-generic.

I suppose what you describe here is how it was working before the
device groups. Ok, I see what to do now. I will be back shortly with a
patch which should make USB_DEVICE_ID_TOPSEED2_PERIPAD_701 work, and
let's take it from there.

Thanks for testing,
Henrik
