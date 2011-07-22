Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab1GVVbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:31:49 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:55437 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab1GVVbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:31:47 -0400
MIME-Version: 1.0
In-Reply-To: <201107222322.07843.linux@rainbow-software.org>
References: <201107222200.55834.linux@rainbow-software.org>
	<CAGoCfiwqzs70A26WgN2pJJvz2aDzY9siOcTuOCkYm3nDHB=J1Q@mail.gmail.com>
	<201107222322.07843.linux@rainbow-software.org>
Date: Fri, 22 Jul 2011 17:31:46 -0400
Message-ID: <CAGoCfiyGUR7-aPqoFOHW=DkBNxav+=34np68ZPutdQWcU4GO=A@mail.gmail.com>
Subject: Re: [PATCH] [resend] usbvision: disable scaling for Nogatech MicroCam
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Joerg Heckenbach <joerg@heckenbach-aw.de>,
        Dwaine Garden <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 5:22 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> Seems that this bug is widespread - the same problem appears also in guvcview
> and adobe flash. I think that the driver is broken too - it should return
> corrected resolution in TRY_FMT.

Well, if the driver does not return the resolution it is actually
capturing in, then that indeed is a driver bug.  That's a different
issue though than what your patch proposed.

You should make the TRY_FMT call specifying an invalid resolution and
see if it returns the real resolution the device will capture at.  If
it doesn't, then fix *that* bug.

The application needs to know the capturing resolution, so it's
possible that it does properly handle the driver passing back the real
resolution and the driver is at fault, in which case no change is
needed to the app at all.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
