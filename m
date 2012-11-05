Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab2KENch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:32:37 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:46297 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab2KENcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:32:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAN+gG=H1L6vwvxxAR6t2-Lz4aW0tbvLvDKvY-8f-M-qqm35mMw@mail.gmail.com>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-12-git-send-email-benjamin.tissoires@gmail.com>
	<20121029225748.GA15632@polaris.bitmath.org>
	<CAN+gG=GNucfg4-wCBZQtz0yJDjpTD_56Js3d68nm8VFi1UhZAA@mail.gmail.com>
	<20121105125731.GA814@polaris.bitmath.org>
	<CAN+gG=H1L6vwvxxAR6t2-Lz4aW0tbvLvDKvY-8f-M-qqm35mMw@mail.gmail.com>
Date: Mon, 5 Nov 2012 14:32:34 +0100
Message-ID: <CAN+gG=H5OVWXY4Dzy04Zj8gqTSWOAsGyV2P3sXS_aztWFYZdbQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] HID: hid-multitouch: get rid of usbhid depedency
 for general path
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

grrr.... damn new gmail interface, I clicked on the wrong button.

sorry for the noise.

On Mon, Nov 5, 2012 at 2:28 PM, Benjamin Tissoires
<benjamin.tissoires@gmail.com> wrote:
> Hi Henrik,
>
> On Mon, Nov 5, 2012 at 1:57 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> Hi Benjamin,
>>
>>> >> This patch factorizes the hid set_feature command by using
>>> >> hid_device->hid_output_raw_report instead of direclty relying on
>>> >> usbhid. This makes the driver usb independant.
>>> >>
>>> >> However I still can't remove the 2 usb related headers because the
>>> >> function mt_resume has a specific patch for usb devices.
>>> >>
>>> >> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>>> >> ---
>>> >>  drivers/hid/hid-multitouch.c | 63 ++++++++++++++++++++++++++------------------
>>> >>  1 file changed, 37 insertions(+), 26 deletions(-)
>>> >
>>> > In my drawer, I have a patchset that aims to remove all usbhid
>>> > dependence, from all the drivers. Perhaps the attached patch is
>>> > something to consider here?
>>>
>>> yep, removing usbhid dependencies is a good thing.
>>> See my review below :)
>>
>> I have a tentative patch taking your comments into account, and it is
>> likely that we want to go that way. However, as to not hold up your
>> patchset, perhaps we could do without it for now.

so, Yes, this is not my blocking patch that prevents me from sending
the new patchset. I intend to let you clean this up with your new
patch.
The v3 is on it's way!

>>
>> Regarding the hardwired usbhid dependency, I think the solution is to
>> move that code to usbhid itself.

yes, maybe, but at the beginning, we didn't want to patch it that way
because it was only specific to one hid-multitouch device (though
armless for the other multitouch devices).
So maybe you will have to add a quirk in usbhid or sth like that.

Cheers,
Benjamin

>>
>> Thanks,
>> Henrik
