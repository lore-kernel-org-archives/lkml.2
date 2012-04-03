Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2DCKy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 06:54:29 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:42473 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2DCKy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 06:54:28 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuesAATWek9V5qnhPGdsb2JhbABFig2sTQOBDxkBAQEBNzSCCQEBBAEnExwjBQsIA0YUJQoaLodpCbshE4s2hDpjBJVihgCNGg
X-IronPort-AV: E=Sophos;i="4.75,362,1330902000"; 
   d="scan'208";a="7051271"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 3 Apr 2012 12:55:54 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] hid: Extending the device-driver matching mechanism
Message-ID: <20120403105554.GA14201@polaris.bitmath.org>
References: <1333436730-13008-1-git-send-email-rydberg@euromail.se>
 <CAN+gG=EvmTFKmKGaC6T-RKYhUy8U0NqWxqz-k_Gr_w5_rm57Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=EvmTFKmKGaC6T-RKYhUy8U0NqWxqz-k_Gr_w5_rm57Bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> So, I made a few tests yesterday, and I have now a clearer idea about
> this solution:
> 
> generally, I like it. Furthermore, it should help us build new classes
> of devices without involving hid-core, which is great.
> However, I have a few minors concerns, and a major one.
> 
> The major one comes with patch 3: introducing the hid_parse function
> in usbhid is great but it interferes with report_fixup mechanism. That
> means that several drivers won't work with this solution.

Yes, as noted in the commit message, that part is a work in
progress. Going through all the drivers using report_fixup, the
majority only uses device information, some use a driver-specific
quirk which again boils down to a specific device. All drivers are
present in the special_driver list in hid-core.

The simplest solution is probably to defer parsing for drivers known
from the device list. Even better would be if there was a mechanism to
avoid that list altogether... considering the USB/BT device as
separate from the HID device, it might even make sense to split the
drivers that way. Most drivers would drive the HID devices,
kickstarted by the generic usbhid driver. Some drivers would need to
intervene on the USB/BT level instead, for instance by fixing up the
reports.

> Now the minors:
> - as mentioned, the patches do not apply on Jiri's tree, which means
> that we are missing the detection of the serial protocol (see comment
> in patch 4).

Ok, thanks. In a couple of weeks I should rebase the patches to 3.4,
and will deal with it then.

> - shouldn't we introduce the same behavior for bluetooth (hidp)
> devices -> to be able to separate the handling of the magicmouse for
> instance)?

Yes, although I have not looked into the details yet.

> - as the hid_parse function is already called, shouldn't we remove the
> calls in the other drivers?

Maybe, maybe not - it depends on if there will be a deferral
mechanism. Hopefully it will become clear as we go along.

Thanks!
Henrik
