Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2DDPAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 11:00:39 -0400
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:38875 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756354Ab2DDPAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 11:00:38 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Proposed addition to 'IIO interface' for color light sensing devices
Date: Wed, 4 Apr 2012 10:06:27 -0500
Message-ID: <B4B07CCC7B7A084E989CF9386538EA1D0120B931@exchsrvr.taosinc.com>
In-Reply-To: <4F7C08C3.7090603@cam.ac.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Proposed addition to 'IIO interface' for color light sensing devices
Thread-Index: Ac0SP0dubXATJ2t/R2aEFqMwfV67RgAM67+g
References: <B4B07CCC7B7A084E989CF9386538EA1D0120B3B3@exchsrvr.taosinc.com> <4F7C08C3.7090603@cam.ac.uk>
From: "Jon Brenner" <jbrenner@TAOSinc.com>
To: "Jonathan Cameron" <jic23@cam.ac.uk>
Cc: <jic23@kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replies in-line,


> -----Original Message-----
> From: Jonathan Cameron [mailto:jic23@cam.ac.uk]
> Sent: Wednesday, April 04, 2012 3:40 AM
> To: Jon Brenner
> Cc: jic23@kernel.org; gregkh@linuxfoundation.org;
linux-iio@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: Proposed addition to 'IIO interface' for color light
sensing devices
> 
> Not sure who else would be interested in this discussion so if anyone
can cc any
> interested parties that would be great! (
> > I would like to propose the following addition to the 'IIO device
> > interface' for color light sensing devices to accommodate CCT (AKA
> > color
> > temperature) and access to the raw RGB channel data for user
analysis.
> >
> > IIO channel type name: CCT
> >
> > The CCT ABI should be documented similar to as follows:
> > In sys-bus-iio-light:
> > What:		/sys/bus/iio/devices/device[n]/cct[_input|_raw]
> > KernelVersion:	3.3.0
> > Contact:	linux-iio@vger.kernel.org
> > Description:
> > 		This should return the correlated color temperature from
the
> RGBC
> > color sensor
> > 		expressed as SI unit (degree kelvin).
> > 		If it comes back in SI units, it should also
include_input else it
> > 		should include _raw to signify it is not in SI units.
> Works for me though the formatting of the above is somewhat different
from
> our current docs...
> >
> > IIO modifiers:
> > IIO_MOD_LIGHT_RED
> > IIO_MOD_LIGHT_GREEN
> > IIO_MOD_LIGHT_BLUE
> So these modifiers apply to intensity channels?   Colour temp is built
from
> multiple raw sensors I believe (like illuminance is often done?) Hence
it's another
> 'virtual' channel we compute?
Yes.
At channel 0 - correct?

So we now have illuminance0_input and in_cct0 - correct?

Clear uses chan 0 and as before, chan 1 - so as before intensityN_raw
mapped to both - correct?

Red is channel 1 - so we have in_intensity1_red_raw -  correct?

Green = intensity2_green_raw.. and so on correct?
> >
> > The 'clear' and IR channels are already covered by the use of
> > IIO_LIGHT and IIO ILLUMINANCE (and respective modifiers).
> > The RGB modifiers will help to express the relative frequencies to
> > their respective channel, and appear to fit well with the overall
convention.
> >
> > And last but not least, the textual modifier names "red", "green",
and
> > "blue" be accommodated within 'industrialio-core'.
> Fine with me.
> 

Proximity remains at channel 0 correct?


> >
> > Channel specific interrupt event / sources are not presented at this
> > time.
> >
> > Any thoughts or comments are welcomed.
> >
> > Jon Brenner
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-iio"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html

