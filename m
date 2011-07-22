Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab1GVVo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:44:56 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:40848 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932297Ab1GVVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:44:55 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] [resend] usbvision: disable scaling for Nogatech MicroCam
Date: Fri, 22 Jul 2011 23:44:39 +0200
User-Agent: KMail/1.9.10
Cc: Joerg Heckenbach <joerg@heckenbach-aw.de>,
        Dwaine Garden <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <201107222200.55834.linux@rainbow-software.org> <201107222322.07843.linux@rainbow-software.org> <CAGoCfiyGUR7-aPqoFOHW=DkBNxav+=34np68ZPutdQWcU4GO=A@mail.gmail.com>
In-Reply-To: <CAGoCfiyGUR7-aPqoFOHW=DkBNxav+=34np68ZPutdQWcU4GO=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107222344.46003.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 July 2011 23:31:46 Devin Heitmueller wrote:
> On Fri, Jul 22, 2011 at 5:22 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> > Seems that this bug is widespread - the same problem appears also in guvcview
> > and adobe flash. I think that the driver is broken too - it should return
> > corrected resolution in TRY_FMT.
> 
> Well, if the driver does not return the resolution it is actually
> capturing in, then that indeed is a driver bug.  That's a different
> issue though than what your patch proposed.
> 
> You should make the TRY_FMT call specifying an invalid resolution and
> see if it returns the real resolution the device will capture at.  If
> it doesn't, then fix *that* bug.

It does not, there's no code that would do that. I actually fixed that only
to find out that the scaling is unusable at least with the MicroCam because
of black horizontal lines that appear in the image (amount of the lines
depend on the scaling factor). So I just disabled the scaling completely for
MicroCam.

I also don't know if the multiple-of-64 width limit is valid for all
usbvision devices - that's why I haven't posted patch to fix this.

> The application needs to know the capturing resolution, so it's
> possible that it does properly handle the driver passing back the real
> resolution and the driver is at fault, in which case no change is
> needed to the app at all.
> 
> Devin
> 



-- 
Ondrej Zary
