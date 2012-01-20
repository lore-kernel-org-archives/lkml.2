Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2ATQtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:49:02 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58357 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab2ATQs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:48:59 -0500
Date: Fri, 20 Jan 2012 08:48:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] hid-multitouch: add support for trackpads
Message-ID: <20120120164849.GA6520@core.coreip.homeip.net>
References: <1326887468-5148-1-git-send-email-benjamin.tissoires@enac.fr>
 <1326887468-5148-2-git-send-email-benjamin.tissoires@enac.fr>
 <20120120160948.GA18530@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120160948.GA18530@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 05:09:48PM +0100, Henrik Rydberg wrote:
> Hi Benjamin,
> 
> > @@ -389,9 +404,19 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
> >  				td->last_field_index = field->index;
> >  			return -1;
> >  		}
> > +		case HID_DG_TOUCH:
> > +			/* Legacy devices use TIPSWITCH and not TOUCH.
> > +			 * Let's just ignore this field. */
> > +			return -1;
> >  		/* let hid-input decide for the others */
> >  		return 0;
> >  
> > +	case HID_UP_BUTTON:
> > +		code = ((usage->hid - 1) & HID_USAGE) + BTN_MOUSE;
> 
> Why '+' here instead of '|' is  beyond me...

Because it is an offset for the range. The fact that it is on power 2
boundary and we can use "|" is purely coincidential here.

Maybe we should even write it as:

		code = BTN_MOUSE + ((usage->hid - 1) & HID_USAGE);

Thanks,
Dmitry

-- 
Dmitry
