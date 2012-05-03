Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab2ECROM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:14:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61654 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2ECROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:14:08 -0400
Date: Thu, 3 May 2012 19:14:02 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mfd: add LM3533 lighting-power core driver
Message-ID: <20120503171402.GG15752@localhost>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-2-git-send-email-jhovold@gmail.com>
 <20120503103848.GB3955@opensource.wolfsonmicro.com>
 <20120503112803.GA15752@localhost>
 <20120503113801.GE3955@opensource.wolfsonmicro.com>
 <20120503150040.GC15752@localhost>
 <20120503152407.GK3955@opensource.wolfsonmicro.com>
 <20120503165437.GF15752@localhost>
 <20120503165748.GS3955@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503165748.GS3955@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 05:57:49PM +0100, Mark Brown wrote:
> On Thu, May 03, 2012 at 06:54:37PM +0200, Johan Hovold wrote:
> > On Thu, May 03, 2012 at 04:24:07PM +0100, Mark Brown wrote:
> 
> > > I'm not sure exactly which control that is?
> 
> > That would be the output_lvled[n] (n = 1..5) attributes. For example, to
> > have all five low-voltage sinks blink synchronously, you could assign 0
> > to all these five attributes, and set a timer trigger for the led device
> > which has id 0.
> 
> Sorry, I meant "what exactly does this do in hardware".

>From the datasheet (page 14):

	"CONTROL BANK MAPPING
	 Control of the LM3533's current sinks is not done directly, but
	 through the programming of Control Banks. The current sinks are
	 then assigned to the programmed Control Bank. This allows for
	 a wide variety of current control possibilities where LEDs can
	 be grouped and controlled via specific Control Banks (see
	 Figure 3)."

It is the control banks that has a brightness settings or can be
programmed to blink, that is, they correspond to the logical LEDs and
backlights.

Assigning a current sink to a control bank corresponds, then, to
setting, for example, output_lvled3 to (led) 1.

[ Figure 3 on page 16 of the data sheet may be instructive. In the
  figure,  BANK A and B corresponds to the two backlight devices, and
  BANK C through F corresponds to the four led devices. Note that there
  are more outputs (current sinks) than control banks. ]

Thanks,
Johan
