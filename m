Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab1LPDa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 22:30:57 -0500
Received: from netrider.rowland.org ([192.131.102.5]:36475 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751629Ab1LPDa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 22:30:56 -0500
Date: Thu, 15 Dec 2011 22:30:55 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Contreras <felipe.contreras@gmail.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH 1/3] usb: musb: fix pm_runtime mismatches
In-Reply-To: <CAMP44s3eeTOBRiFwEL3FypDY_+-MReqYJJVO1URNrnFVFXzvDg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1112152228030.22491-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011, Felipe Contreras wrote:

> >> --- a/drivers/usb/musb/omap2430.c
> >> +++ b/drivers/usb/musb/omap2430.c
> >> @@ -385,6 +385,7 @@ static void omap2430_musb_disable(struct musb *musb)
> >>
> >>  static int omap2430_musb_exit(struct musb *musb)
> >>  {
> >> +     pm_runtime_put(musb->controller);
> >>       del_timer_sync(&musb_idle_timer);
> >>
> >>       omap2430_low_level_exit(musb);
> >
> > Should these calls be pm_runtime_put_sync() instead of
> > pm_runtime_put()?
> 
> I don't see why... The thing failed, it's not going to be used any
> more so better let PM deactivate the device.

It's not a big deal.  The difference is that pm_runtime_put_sync()
avoids an extra context switch when suspending the device.  A minor
optimization, that's all.

Alan Stern

