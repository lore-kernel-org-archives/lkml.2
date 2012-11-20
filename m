Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2KTUvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:51:36 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:49597 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab2KTUvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:51:35 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgJdAM3sq1BV5h1yPGdsb2JhbABEilq4ABcDAQEBAR8ZDSeCHgEBBAE6HCMQCANGFCUKGi6HbAqvFpA+FJA1YQOVfYV7g06JaQ
X-IronPort-AV: E=Sophos;i="4.83,288,1352070000"; 
   d="scan'208";a="155623317"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 20 Nov 2012 21:51:47 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 14/14] HID: hid-multitouch: forwards MSC_TIMESTAMP
Message-ID: <20121120205147.GA4658@polaris.bitmath.org>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352908766-4492-15-git-send-email-benjamin.tissoires@gmail.com>
 <20121114195852.GA14840@polaris.bitmath.org>
 <50A40CB3.8070105@gmail.com>
 <20121116200926.GA652@polaris.bitmath.org>
 <CAN+gG=F=bHdJF0=0LHGuVQ+ObHvWKJnL0GYcAEWBeD+Z-yyGSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=F=bHdJF0=0LHGuVQ+ObHvWKJnL0GYcAEWBeD+Z-yyGSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> > In addition, it would make perfect sense to extend the validity of the
> > hardware time with the event time for longer intervals. The relative
> > error only makes a difference on milisecond intervals.
> >
> > A patch that seamlessly extends the validity of the hardware time,
> > ideally using the event time, seems like a viable solution.
> 
> Just to be sure:
> When I receive scan_time, I increment timestamp with the device value.
> When not, I find out the number of counter wrap I missed with the
> kernel timer (jiffies) to get the actual device time.
> 
> Is that ok for you?

If the device has no scan time, then no scan time is reported, of
course.  If the scan time delta _and_ the actual time delta are both
below logical_max (say), then increase the counter with the scan time
delta. Else, if the actual time delta is below 2^31, increase the
counter with the actual time delta. Else set the counter to zero.

This ought to give us the sought-after accuracy for small times, the
sought-after extension for intermediate times, and a clear definition
of unknown time.

Cheers,
Henrik
