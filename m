Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab0K1O15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 09:27:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45615 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab0K1O1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 09:27:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=ns4jG+WJQmdG5TN02hghAMFjTb81fT/d9J0Lr0XrfriCXrf5FUoOTnRXxNgvGd1dik
         f/zk2Mtiy2IG2szmjG/7pPnRVVCtDqCrl7/1FKfMDViriWfJNNXooss0q+/czOsz7kWi
         qu3GlWy+RGeQXZVwsLLZ2s/eHWJdheaefqpUI=
Subject: Re: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org
In-Reply-To: <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
References: <1290941875.13526.15.camel@cai.gentoo>
	 <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
	 <1290951770.13526.18.camel@cai.gentoo>
	 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Sun, 28 Nov 2010 22:29:05 +0800
Message-ID: <1290954545.13526.27.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-11-28日的 09:05 -0500，jonsmirl@gmail.com写道：
> On Sun, Nov 28, 2010 at 8:42 AM, Microcai <microcai@fedoraproject.org> wrote:
> > 在 2010-11-28日的 08:24 -0500，Theodore Tso写道：
> >> On Nov 28, 2010, at 5:57 AM, Microcai wrote:
> >>
> >> > Hi, there
> >> >
> >> >     I'm implementing the UNICODE font of the framebuffer console, (see
> >> > http://lkml.org/lkml/2010/11/26/50 in case you do not got my email). But
> >> > current vt code is too bugy, too many direct assumes about vt buffer,
> >> > This makes me so hard to hack.  There is TODO telling me to add UNICODE
> >> > support, but no room for such code, that's why my patch is so tricky.
> >> >
> >> >     And the code itself, if you'll excuse me, it isn't as beautiful as rest
> >> > of the kernel.
> >> >     So, it really really need a clean rewrite.I'm ganna take is hard job.
> >> >     And, please tell me if is worth to do so.
> >>
> >> Yes, the console is code is very old.   But please be aware that lots of code (both in the kernel and in userspace) has dependencies upon how the code behaves.   So changing it in a way that does not break backwards compatibility is hard.  i.e., it is hard to hack for a reason.
> >>
> >> I would recommend an incremental rewrite (i.e., one patch at a time), as opposed to a rewrite from scratch.   Because people will want to be assured that things haven't broken in a horrible way as a result of a complete rewrite...
> >>
> >> -- Ted
> >>
> >
> > Yeah, I'd also like to rewrite it incrementally. But... who will accept
> > that incrementally patch ? It just seems that incremental patch will be
> > horrible at the beginning...... It will be discard without a
> > reason .....
> 
> You can use CONFIG_VT to remove the entire VT subsystem. It might be
> easier for you to write an alternative VT system that could be enabled
> with a different flag.
> 
> The VT system is very old code from the earliest days of Linux.
> Thousands of things depend on it both in the kernel and user space. It
> will be very hard to make significant changes to it that don't break
> lots of dependent code.
> 
> Another model to consider... Remove the VT subsystem. Replace it will
> a Unicode VT system built in user space. Using the existing kernel
> code, leave a single user console in the kernel that would only be
> used for system maintenance. Normal users would never see this console
> unless their system was really messed up.
> 
> 

So, here is the design according to your description  .. 

JUST export /dev/fb and /dev/pts and /dev/console
The kernel use /dev/console, but invisible. 
The rest of the world uses /dev/pts

Make init using /dev/fb to display boot message, and agetty runs
on /dev/pts

Another user-space program use /dev/fb to display all /dev/pts , you can
use alt+Fx to switch between them (kernel no longer handles console
switch).

So, there is no virtual console ... . Just as windows  (who uses cmd.exe
to display console )

kernel just deal with BYTE stream, no need for font handling .....

Will you agree with that kind of system ? 





