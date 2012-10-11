Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2JKGui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 02:50:38 -0400
Received: from foo.stuge.se ([212.116.89.98]:33326 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751584Ab2JKGuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 02:50:35 -0400
Message-ID: <20121011065033.2168.qmail@stuge.se>
Date: Thu, 11 Oct 2012 08:50:33 +0200
From: Peter Stuge <peter@stuge.se>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: REGRESSION: usbdevfs:
	Use-scatter-gather-lists-for-large-bulk-transfers
Mail-Followup-To: Henrik Rydberg <rydberg@euromail.se>,
	Hans de Goede <hdegoede@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121010203118.GA792@polaris.bitmath.org> <20121010203459.20663.qmail@stuge.se> <20121011054403.GA1680@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011054403.GA1680@polaris.bitmath.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik Rydberg wrote:
> > What is the programming cable and software that uses it?
> 
> The programmer is impact, using libusbx-1.0.14-1.

Do you know for a fact that your version calls libusb-1.0? Did you
establish this with e.g. strace? ISE 11.1 impact uses only libusb.so,
ie. libusb-0.1.

Depending on what distribution you are using you may or may not have
libusb-compat-0.1, without which the libusbx package isn't involved
at all.

Many distributions still ship libusb-0.1.12 or some patched variant
thereof, which of course knows nothing about the kernel changes.



> The patch is pretty generic, so I am suprised the problem has not
> shown up earlier.

There are several explanations. There is clearly a problem with Hans'
patch(es) for some cases, but those are perhaps not so common.

I've reviewed Hans' patch that he added to libusbx and which is in
libusbx-1.0.14, but I am not sure that it is correct, which is why
I haven't included it in libusb yet.

But it isn't certain that is is involved at all. If your impact
version uses libusb.so like in ISE 11.1 then it will not be. One way
to test is by trying to generate a libusb debug log. See
https://libusb.org/wiki/debug for instructions which are for libusb,
but which work also for libusbx since the code is nearly the same.
(Just replace the repository to clone from.)

Another factor is the host controller. Is the device connected to a
USB 3.0 port or a USB 2.0 port? USB 3.0 still has some gotchas which
may or may not be what you are seeing.


Looking forward to more information

//Peter
