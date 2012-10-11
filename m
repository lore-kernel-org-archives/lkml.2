Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2JKFlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:41:35 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:43248 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab2JKFld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:41:33 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoaJAFtbdlBV5h1yPGdsb2JhbABEikyzbgR7GQEBAQEfGQ0ngiABAQQBOhwjBQsIAxQELhQlChoKCYd+Crh6FIszLwOFDmADkjuDMIVyjS4
X-IronPort-AV: E=Sophos;i="4.80,570,1344204000"; 
   d="scan'208";a="427194664"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 11 Oct 2012 07:44:03 +0200
To: Peter Stuge <peter@stuge.se>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: REGRESSION: usbdevfs:
 Use-scatter-gather-lists-for-large-bulk-transfers
Message-ID: <20121011054403.GA1680@polaris.bitmath.org>
References: <20121010203118.GA792@polaris.bitmath.org>
 <20121010203459.20663.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010203459.20663.qmail@stuge.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 10:34:59PM +0200, Peter Stuge wrote:
> Hej Henrik,
> 
> Henrik Rydberg wrote:
> > commit 3d97ff63f8997761f12c8fbe8082996c6eeaba1a
> > Author: Hans de Goede <hdegoede@redhat.com>
> > Date:   Wed Jul 4 09:18:03 2012 +0200
> > 
> >     usbdevfs: Use scatter-gather lists for large bulk transfers
> >     
> > breaks an usb programming cable over here. The problem is reported as
> > "bulk tranfer failed" [sic] by the tool, and bisection leads to this
> > commit. Reverting on top of 3.6 solves it for me.
> > 
> > I am happy to test alternatives.
> 
> In order to make full use of the new kernel commit you also need
> changes in libusb, if the tool uses libusb, but I agree that the
> kernel change must under no circumstance cause existing userland
> software to regress.

Indeed.

> What is the programming cable and software that uses it?

The programmer is impact, using libusbx-1.0.14-1. The device runs the
xusbdfwu firmware. The (usb 2.0) bulk endpoint says wMaxPacketSize
1x512 bytes, and bInterval 0.

The patch is pretty generic, so I am suprised the problem has not
shown up earlier.

Henrik
