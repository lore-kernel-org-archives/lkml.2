Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab2FYNaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:30:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260Ab2FYNap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:30:45 -0400
Date: Mon, 25 Jun 2012 15:30:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Yufeng Shen <miletus@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew de los Reyes <adlr@chromium.org>
Subject: Re: [PATCH] HID: magicmouse: Correct report range of major / minor
 axes
In-Reply-To: <20120625120407.GA522@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1206251530300.18612@pobox.suse.cz>
References: <1340382713-2957-1-git-send-email-miletus@chromium.org> <20120625120407.GA522@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012, Henrik Rydberg wrote:

> > In patch "HID: magicmouse: Adjust major / minor axes to scale",
> > touch_major and touch_minor axes are scaled by a factor of
> > four when reported but the max touch_major/minor is not scaled
> > accordingly. This patch scales the max touch_major/minor to
> > be consistent with the reported value.
> > 
> > Signed-off-by: Yufeng Shen <miletus@chromium.org>
> > ---
> >  drivers/hid/hid-magicmouse.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> > index 7cf3ffe..40ac665 100644
> > --- a/drivers/hid/hid-magicmouse.c
> > +++ b/drivers/hid/hid-magicmouse.c
> > @@ -426,8 +426,10 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
> >  		__set_bit(EV_ABS, input->evbit);
> >  
> >  		input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 15, 0, 0);
> > -		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 4, 0);
> > -		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 4, 0);
> > +		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255 << 2,
> > +				     4, 0);
> > +		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255 << 2,
> > +				     4, 0);
> >  		input_set_abs_params(input, ABS_MT_ORIENTATION, -31, 32, 1, 0);
> >  
> >  		/* Note: Touch Y position from the device is inverted relative
> > -- 
> > 1.7.7.3
> > 
> 
>     Acked-by: Henrik Rydberg <rydberg@euromail.se>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
