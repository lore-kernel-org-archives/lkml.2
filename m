Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab1A1Rjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:39:51 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59771 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1A1Rjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:39:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QwHj76CmzqyJLrst+T/Xt6+i1xmvCCuOdZ/gqgxDpptPfwh/5hlGBQIuF9n7ZFKq5/
         fEidGZCWyZ3/UOEfScFn1xV0UgNmvzRnbEWBt3KF4vKOU0Dj/wlhQ7pIV+3Z+QXHb7VS
         pdl7qFGHbxbv66rdNkijU4Ep07JGhuByLf4AU=
Date: Fri, 28 Jan 2011 09:39:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Ping Cheng <pingc@wacom.com>, Jiri Kosina <jkosina@suse.cz>,
        Chris Bagwell <chris@cnpbagwell.com>, Rafi Rubin <rafi@seas.upenn.edu>,
        Stephane Chatty <chatty@lii-enac.fr>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] input: evdev: Add EVIOC mechanism to extract the MT
 slot state
Message-ID: <20110128173936.GD6252@core.coreip.homeip.net>
References: <1296124547-3323-1-git-send-email-benjamin.tissoires@enac.fr>
 <1296124547-3323-3-git-send-email-benjamin.tissoires@enac.fr>
 <20110127120945.GC15626@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127120945.GC15626@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 01:09:45PM +0100, Henrik Rydberg wrote:
> On Thu, Jan 27, 2011 at 11:35:47AM +0100, Benjamin Tissoires wrote:
> > This patch adds the ability to extract the MT slot state sequentially
> > via EVIOCGABS. The slot parameter is first selected by calling
> > EVIOCSABS with ABS_MT_SLOT as argument, followed by a set of EVIOCGABS
> > calls. The slot selection is local to the evdev client handler, and
> > does not affect the actual input state.
> 
> Ok - it seemed like a reasonable idea at the time, but..
> 
> > @@ -767,9 +769,10 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
> >  			if (size < sizeof(struct input_absinfo))
> >  				abs.resolution = 0;
> >  
> > -			/* We can't change number of reserved MT slots */
> > -			if (t == ABS_MT_SLOT)
> > -				return -EINVAL;
> > +			if (t == ABS_MT_SLOT) {
> > +				client->slot = abs.value;
> > +				return 0;
> > +			}
> 
> ...this just does not look right. Perhaps there should really be a
> different ioctl to retrieve the slot values instead. Dmitry?
> 

Yes, a separate ioctl with explicit slot number is much better option.
Then it is automatically multi-thread safe and just does not look
ugly as hell.

Thanks.

-- 
Dmitry
