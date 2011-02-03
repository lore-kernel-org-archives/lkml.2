Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab1BCTBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:01:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38674 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430Ab1BCTBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:01:36 -0500
Subject: Re: [PATCH 2/4] RTC: Fix rtc driver ioctl specific shortcutting
From: John Stultz <john.stultz@linaro.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110203084309.GA20679@pengutronix.de>
References: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
	 <1296699283-6784-3-git-send-email-john.stultz@linaro.org>
	 <20110203084309.GA20679@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 11:01:23 -0800
Message-ID: <1296759683.3336.306.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 09:43 +0100, Wolfram Sang wrote:
> On Wed, Feb 02, 2011 at 06:14:41PM -0800, John Stultz wrote:
> > Some RTC drivers enable functionality directly via their ioctl method
> > instead of using the generic ioctl handling code. With the recent
> > virtualization of the RTC layer, its now important that the generic
> > layer always be used.
> > 
> > This patch moved the rtc driver ioctl method call to after the generic
> > ioctl processing is done. This allows hardware specific features or
> > ioctls to still function, while relying on the generic code for handling
> > everything else.
> 
> I guess the documentation should be updated, too. Currently it says:
> 
> Note that many of these ioctls need not actually be implemented by your
> driver.  The common rtc-dev interface handles many of these nicely if your
> driver returns ENOIOCTLCMD.  Some common examples:
> ...
> 
> That situation has changed after your patch.

Thanks for pointing that out. Although the code and comments were not
consistent even before my rework:
ie:
	 * Drivers *SHOULD NOT* provide ioctl implementations
	 * for these requests.  Instead, provide methods to
	 * support the following code, so that the RTC's main
	 * features are accessible without using ioctls.

But clearly that wasn't the case. :)

I've got a few additional cleanup patches I'll be posting to once I'm
feeling confident the posted fix resolves the issues Marcelo was having.

If anyone else is seeing problems with these fixes,  please do let me
know.

thanks
-john


