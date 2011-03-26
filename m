Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1CZCkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 22:40:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36076 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1CZCkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 22:40:14 -0400
Date: Sat, 26 Mar 2011 02:40:10 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jamie Iles <jamie@jamieiles.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Message-ID: <20110326024010.GA3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <AANLkTinQ_M92zDZx_Jfe=rvPO0Gr4kHhXZUATvgVBywh@mail.gmail.com>
 <20110325225220.GV3130@pulham.picochip.com>
 <201103260002.19291.arnd@arndb.de>
 <20110326002159.GY3130@pulham.picochip.com>
 <AANLkTinYd+4vtSBmBGHJwbCgFiZttSTtgQaQ0txwoUxt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinYd+4vtSBmBGHJwbCgFiZttSTtgQaQ0txwoUxt@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 10:16:48PM -0400, Mike Frysinger wrote:
> On Fri, Mar 25, 2011 at 20:21, Jamie Iles wrote:
> > For the actual ioctl() we should assume byte addressing rather than
> > words though and do the conversion in the driver so we can cope with
> > devices that don't have 64-bit words and do the locking on a looping
> > word-by-word basis.
> >
> >        struct otp_lock_req {
> >                __u32   start_addr;
> >                __u32   byte_count;
> >        };
> 
> i would add an ABI field here too so if in the future we want to add
> stuff, we can do so without adding new ioctls.  like "u16 version; u16
> flags;".  then in the ioctl, if version isnt 0, we return ENOTSUP.  in
> the future, we can add flags or bump the version.

Sounds like a good idea.

> > Mike, would this be OK with you if we used a different ioctl() to the
> > one bfin-otp is using currently?  I notice that it's using the OTPLOCK
> > ioctl() from MTD but I think it's using the argument in a different way.
> 
> i re-used OTPLOCK because it's exactly the name i wanted and it was
> easier than carving out my own namespace, but the args are different.
> i can see how people might find this undesirable.

OK, well seeing as we're making this generic we may as well reserve a 
range of ioctls.  I'll reserve a few of them and add OTP_LOCK_AREA for 
now.

Jamie
