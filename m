Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1EYUXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:23:01 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49413 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1EYUW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:22:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qGP51aMTVxcDRiiABu9H61F9IKBXAyPSkwHBuS1B5g2OTydsmJDpZ2dWXQ6gFPZso7
         4WJv7u/WjCAArDd9+keb4NaLYzhDjPNGdpI2nb3j6cCCxV9XdHQKv2ERokHF+gIq7jJX
         IBnjT0OZgKjtYkMDW+mEAgA6+dZ59g9Fdgu3M=
Date: Wed, 25 May 2011 16:22:50 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu-natty
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Parag Warudkar <parag.lkml@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
In-Reply-To: <1306354818.1641.55.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.02.1105251622040.8972@ubuntu-natty>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com> <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com> <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty> <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
 <4DDD5240.2060308@fusionio.com> <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com> <4DDD55D6.1080909@fusionio.com> <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty> <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com>
 <1306354818.1641.55.camel@mulgrave.site>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 May 2011, James Bottomley wrote:

> On Wed, 2011-05-25 at 13:03 -0700, Linus Torvalds wrote:
> > On Wed, May 25, 2011 at 12:52 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> > >
> > > +static inline int sdev_early_check(struct scsi_device *sdev)
> > > +{
> > > +       if (!sdev || sdev->sdev_state == SDEV_DEL
> > > +               || sdev->sdev_state > SDEV_QUIESCE)
> > > +               return -ENXIO;
> > > +       return 0;
> > > +}
> > 
> > Can somebody explain why it's those states, and nothing else?
> 
> The states are definitely wrong.  QUIESCE shouldn't cause an error.
> 
QUIESCE is not causing an error above - > QUIESCE is which per the 
documentation is correct.

Parag
