Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab1CZCc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 22:32:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44497 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab1CZCc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 22:32:57 -0400
Date: Sat, 26 Mar 2011 02:32:52 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [RFC PATCHv3 3/4] drivers/otp: convert bfin otp to generic OTP
Message-ID: <20110326023252.GZ3130@pulham.picochip.com>
References: <1301073283-30821-1-git-send-email-jamie@jamieiles.com>
 <1301073283-30821-4-git-send-email-jamie@jamieiles.com>
 <AANLkTin+Uvw8=CN+2oawAUHGot8gdM5u98S4zC8QoB=u@mail.gmail.com>
 <20110326001143.GX3130@pulham.picochip.com>
 <AANLkTimfjaviwQg5XD9HwtXMOPXq_=N_WOwpQyPf4L_9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimfjaviwQg5XD9HwtXMOPXq_=N_WOwpQyPf4L_9@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 10:11:40PM -0400, Mike Frysinger wrote:
> >> > +static const struct otp_region_ops bfin_region_ops = {
> >> > +       .read_word      = bfin_region_read_word,
> >> > +       .write_word     = bfin_region_write_word,
> >> > +       .get_size       = bfin_region_get_size,
> >> > +       .get_fmt        = bfin_region_get_fmt,
> >> > +       .ioctl          = bfin_region_ioctl,
> >> > +};
> >>
> >> hmm, i just realized this stuff is per-region.  wouldnt the
> >> read/write/ioctl make more sense as per-device ?
> >
> > No, I don't think so.  The file_operations are all based on the regions
> > rather than the device so I think it makes sense to have these as region
> > based operations.  We could make them per device and pass the region as
> > a parameter but I'm not sure that it gains us anything.
> 
> for a device that exports more than one region, you dont need to
> duplicate the structure.  as you add in more regions, the amount of
> duplication increases.
> 
> how many regions does your device export ?  does it need different
> read/write behavior for each ?

The current devices are up to 8 regions and whilst the behaviour is the 
same for each it does need to know what region it's operating on so it 
can set the redundancy correctly.

We could move the read and write methods into some device ops but they'd 
need to take an otp_region as a parameter.  Also, at the moment we don't 
duplicate the structure as we're just keeping a pointer to it but I'm 
happy to move these into the device ops if you have a strong preference.

Jamie
