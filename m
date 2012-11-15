Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2KOJOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:14:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660Ab2KOJO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:14:29 -0500
Date: Thu, 15 Nov 2012 10:14:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/14] Input: introduce EV_MSC Timestamp
In-Reply-To: <20121114163357.GA29131@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1211151014030.15877@pobox.suse.cz>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com> <1352908766-4492-10-git-send-email-benjamin.tissoires@gmail.com> <20121114163357.GA29131@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Dmitry Torokhov wrote:

> On Wed, Nov 14, 2012 at 04:59:21PM +0100, Benjamin Tissoires wrote:
> > Some devices provides the actual timestamp (hid_dg_scan_time in win8 ones)
> > computed by the hardware itself. This value is global to the frame and is
> > not specific to the multitouch protocol.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> > Reviewed-by: Henrik Rydberg <rydberg@euromail.se>
> 
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> I take it will go through Jiri's tree, right?

Yup, I am taking it together with the rest of the series, and including 
your Ack. Thanks a lot.

> 
> > ---
> >  Documentation/input/event-codes.txt | 11 +++++++++++
> >  include/linux/input.h               |  1 +
> >  2 files changed, 12 insertions(+)
> > 
> > diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
> > index 53305bd..f1ea2c6 100644
> > --- a/Documentation/input/event-codes.txt
> > +++ b/Documentation/input/event-codes.txt
> > @@ -196,6 +196,17 @@ EV_MSC:
> >  EV_MSC events are used for input and output events that do not fall under other
> >  categories.
> >  
> > +A few EV_MSC codes have special meaning:
> > +
> > +* MSC_TIMESTAMP:
> > +  - Used to report the number of microseconds since the last reset. This event
> > +    should be coded as an uint32 value, which is allowed to wrap around with
> > +    no special consequence. It is assumed that the time difference between two
> > +    consecutive events is reliable on a reasonable time scale (hours).
> > +    A reset to zero can happen, in which case the time since the last event is
> > +    unknown.  If the device does not provide this information, the driver must
> > +    not provide it to user space.
> > +
> >  EV_LED:
> >  ----------
> >  EV_LED events are used for input and output to set and query the state of
> > diff --git a/include/linux/input.h b/include/linux/input.h
> > index ba48743..25354f3 100644
> > --- a/include/linux/input.h
> > +++ b/include/linux/input.h
> > @@ -858,6 +858,7 @@ struct input_keymap_entry {
> >  #define MSC_GESTURE		0x02
> >  #define MSC_RAW			0x03
> >  #define MSC_SCAN		0x04
> > +#define MSC_TIMESTAMP		0x05
> >  #define MSC_MAX			0x07
> >  #define MSC_CNT			(MSC_MAX+1)
> >  
> > -- 
> > 1.8.0
> > 
> 
> -- 
> Dmitry
> 

-- 
Jiri Kosina
SUSE Labs
