Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1EXKl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:41:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36980 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1EXKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:41:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6355"; a="93041142"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <BD27AEAC-1E6D-480C-9E18-A970B992AD75@ti.com> <Pine.LNX.4.44L0.1105231710590.2020-100000@iolanthe.rowland.org> <00ed01cc19d6$e1fef520$a5fcdf60$@org> <20110524101817.GB14371@legolas.emea.dhcp.ti.com> <010501cc19fd$b8738320$295a8960$@org> <20110524103325.GC14371@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110524103325.GC14371@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Tue, 24 May 2011 13:43:09 +0300
Message-ID: <011d01cc19ff$616055c0$24210140$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwZ/fqtb2O5th1kSgewJyV0fWZ3LgAAGxIw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe

> > Yes :) The driver->speed is updated in usb_composite_probe() if
> > CONFIG_USB_GADGET_SUPERSPEED is defined.
> >
> > So, are we ok with this solution? The module parameter I mean?
> > Are you going to try the v13 in your branch? Please let me know how
> it
> > goes and of course if you have any comments.
> 
> I think it still gives the possibility for failure. I would rather not
> take that until all gadget drivers are fixed. We can help you doing
> that and we only change driver->speed after all gadget drivers have
> their "sensible defaults" SuperSpeed descriptors.

By "until all gadget drivers are fixed" you mean until all gadget drivers
provide SS descriptors? This will take for ever... 
I wasn't about to modify all gadget drivers and to add SS descriptors for
them. I can add default values (as generate_ss_descriptors() did if you
remember) but I don't think this is the right approach because as you said -
different gadget drivers might have different SS descriptors and I don't
feel confident enough to set these values. Nor do I have the ability to test
each of the gadget drivers the way I would like to after this change.
The only gadget driver I felt confident adding SS descriptors for is UASP,
which I tested properly.

Actually if the CONFIG_USB_GADGET_SUPERSPEED is turned off, which is the
default of it, the speed won't be updated and all these series won't be
functional so I don't see any possibilities for failure in such
configuration. Or am I missing something?


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum





