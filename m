Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1CYWz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:55:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44345 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1CYWz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:55:26 -0400
Date: Fri, 25 Mar 2011 22:55:23 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [RFC PATCHv3 1/4] drivers/otp: add initial support for OTP memory
Message-ID: <20110325225523.GW3130@pulham.picochip.com>
References: <1301073283-30821-1-git-send-email-jamie@jamieiles.com>
 <1301073283-30821-2-git-send-email-jamie@jamieiles.com>
 <AANLkTinLBbKaw=DwVFgORtQ=uA+zkF8QUUKj6uiqLaMw@mail.gmail.com>
 <20110325224726.GU3130@pulham.picochip.com>
 <AANLkTi=XGNdLq4=cp3iv++rg=yXUVsp4mjcW7CVuQZUV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=XGNdLq4=cp3iv++rg=yXUVsp4mjcW7CVuQZUV@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 06:50:36PM -0400, Mike Frysinger wrote:
> On Fri, Mar 25, 2011 at 18:47, Jamie Iles wrote:
> > On Fri, Mar 25, 2011 at 05:58:05PM -0400, Mike Frysinger wrote:
> >> On Fri, Mar 25, 2011 at 13:14, Jamie Iles wrote:
> >> > +/* We'll allow OTP devices to be named otpa-otpz. */
> >> > +#define MAX_OTP_DEVICES                26
> >>
> >> mmm is that still true ?
> >
> > I think so - the actual devices should be otpa-otpz, but when you
> > register regions they could be otpa1, otpa2, otpb1, otpb2 etc.
> >
> >>
> >> > +static unsigned long registered_otp_map[BITS_TO_LONGS(MAX_OTP_DEVICES)];
> >> > +static DEFINE_MUTEX(otp_register_mutex);
> >>
> >> do we really need this ?  if we let the minor number dictate
> >> availability, then we can increment until that errors/wraps, and we
> >> dont need to do any tracking ...
> >
> > OK, so it would be nice to get rid of this but afaict we still need to
> > do some accounting of available minor numbers in the range that we've
> > allocated.  We could do a simple increment % 255 for the minor number
> > but if OTP devices are removed at runtime then that may get fragmented
> > and we would need to do retries of device_register() which feels a bit
> > too easy to mess up.
> >
> > Certainly allocating one major number for OTP devices then allocating
> > the minors one by one would be much better than what I have now.
> >
> > We probably also want it so that if you remove the OTP device that has
> > had regions called otpaN then reinsert it they doesn't suddenly become
> > otpbN.
> 
> yeah that's true.  guess i'll leave it be then ;).

OK, but it still might be worth pruning it down to a single major number 
or is that something worth doing later on if it becomes needed?

> whatever naming is picked in /dev/ should match the stuff in /sys/ btw ...

I think that's working ok.  On my system I have:

	/sys/bus/otp/devices/otpa/otpa1/
	/sys/bus/otp/devices/otpa/otpa2/

and

	/dev/otpa1
	/dev/otpa2

Jamie
