Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2EAGbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:31:24 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:56584 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2EAGbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:31:23 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiSLAOKCn09V5qnhPGdsb2JhbABEiiulPIFhBIEbGQEBAQEeGQ0nggkBAQUnExwTAQ8QCAMYLhQlChoTiBG6IROLEoR9YwSVfYYGjSc
X-IronPort-AV: E=Sophos;i="4.75,509,1330902000"; 
   d="scan'208";a="30019098"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 1 May 2012 08:35:48 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <Benjamin_Tissoires@logitech.com>,
        Stephane Chatty <chatty@enac.fr>
Subject: Re: [PATCH v3 5/6] hid-multitouch: Switch to device groups
Message-ID: <20120501063548.GA2154@polaris.bitmath.org>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
 <1335175627-2270-6-git-send-email-rydberg@euromail.se>
 <CAN+gG=EWHi18kb1q2xQg8mfS9o6BHVLVdU+KYUcWdM4L3gJybA@mail.gmail.com>
 <20120430183023.GA5585@polaris.bitmath.org>
 <CAN+gG=Ekz8HMBP0ZOSts5ek9x38FW7v177K-p-kVBvCCkh6kOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=Ekz8HMBP0ZOSts5ek9x38FW7v177K-p-kVBvCCkh6kOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 08:51:28PM +0200, Benjamin Tissoires wrote:
> On Mon, Apr 30, 2012 at 20:30, Henrik Rydberg <rydberg@euromail.se> wrote:
> >> I remarked a small regression in this patch: the detection of the
> >> serial protocol is not handled anymore. I was indeed relying on the
> >> fact that the parameter "id" in mt_probe was null to know that the
> >> device was not already in the list of known devices.
> >
> > I see. Will this suffice?
> 
> Yes, but I'd rather do the test against either id->product or
> id->driver_data as we may use HID_ANY_ID for vendors specific
> handling. For instance, I had the confirmation from EETI (eGalax) that
> they will always use the same protocol for their usb products, thus
> the same quirks could be handled by HID_DEVICE(BUS_USB,
> HID_GROUP_MULTITOUCH, USB_VENDOR_ID_DWAV, HID_ANY_ID).

Sounds good. I am sending out a fourth version of the patch which will
enable this possibility as well.

On a different note, I wonder why the various slot allocations, sysfs
entries and post-parse settings are done after the device has been
started?

Thanks for testing,
Henrik
