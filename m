Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab0HaU6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 16:58:47 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46985 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab0HaU6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 16:58:45 -0400
Subject: Re: [PATCH 4/6 v2] HID: magicmouse: remove axis data filtering
From: Chase Douglas <chase.douglas@canonical.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Michael Poole <mdpoole@troilus.org>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C7D6739.5000601@euromail.se>
References: <1283280068-12285-1-git-send-email-chase.douglas@canonical.com>
	 <1283280068-12285-4-git-send-email-chase.douglas@canonical.com>
	 <4C7D6739.5000601@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 16:58:39 -0400
Message-ID: <1283288319.2255.103.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 22:34 +0200, Henrik Rydberg wrote:
> On 08/31/2010 08:41 PM, Chase Douglas wrote:
> 
> > The Magic Mouse device is very precise. No driver filtering of input
> > data needs to be performed.
> > 
> > Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> > Acked-by: Michael Poole <mdpoole@troilus.org>
> > ---
> 
> 
> I am still not sure this is a good idea. Bandwidth from MT devices is a big
> deal. A statement roughly how much data comes out of mtdev (which does the
> filtering for type A devices) before and after this change would be reassuring.

As it is right now, hid-magicmouse doesn't support MT slots. I think all
the fuzz code ends up comparing in the MT case is between one touch and
another touch, not between one touch's current location and its previous
location. If I'm correct, then it means a fuzz > 0 is incorrect for
non-slotted MT devices.

In fact, the code in drivers/input/input.c around line 194 looks like it
discards defuzzing in this case, so one could say this patch is making
things more correct :).

Now a fuzz > 0 for the non-MT ABS axes may be useful, but this device
exhibits no jitter, and we're not really worried about bandwidth in the
single touch case.

-- Chase

> >  drivers/hid/hid-magicmouse.c |   10 +++++-----
> >  1 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> > index 98bbc53..0fe2464 100644
> > --- a/drivers/hid/hid-magicmouse.c
> > +++ b/drivers/hid/hid-magicmouse.c
> > @@ -357,11 +357,11 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
> >  		__set_bit(EV_ABS, input->evbit);
> >  
> >  		input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 15, 0, 0);
> > -		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 4, 0);
> > -		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 4, 0);
> > -		input_set_abs_params(input, ABS_MT_ORIENTATION, -32, 31, 1, 0);
> > +		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
> > +		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 0, 0);
> > +		input_set_abs_params(input, ABS_MT_ORIENTATION, -32, 31, 0, 0);
> >  		input_set_abs_params(input, ABS_MT_POSITION_X, -1100, 1358,
> > -				4, 0);
> > +				0, 0);
> >  		/* Note: Touch Y position from the device is inverted relative
> >  		 * to how pointer motion is reported (and relative to how USB
> >  		 * HID recommends the coordinates work).  This driver keeps
> > @@ -369,7 +369,7 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
> >  		 * inverse of the reported Y.
> >  		 */
> >  		input_set_abs_params(input, ABS_MT_POSITION_Y, -1589, 2047,
> > -				4, 0);
> > +				0, 0);
> >  	}
> >  
> >  	if (report_undeciphered) {


