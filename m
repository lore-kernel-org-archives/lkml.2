Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab0FVOuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 10:50:54 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34698 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab0FVOuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 10:50:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kojWioCYCARFM/3KWqEVsXCZwr2XcXaqsKDN456Jxe6mnv9XZb4FCon/1cWsxzr0Ju
         KIfxpRRJveXJNnwP1QiuozSW1kEsrsSVeNpwRgBZOlILnbQ8QFnfMpask0DUd3dbEmyA
         gapTNPaSPbyBzJZRGI0KRogpchDGREYAJdmAw=
Subject: Re: 2.6.34 Crash in dmaengine_put()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTimsDSrEL8vT877pLYSa4A338p4Y8w0Ya6Xm7BFJ@mail.gmail.com>
References: <AANLkTilCW2iqsNaWM9NYIomy8OxGC9jG40KpLcKMYTqL@mail.gmail.com>
	 <20100621202854.de928e0a.akpm@linux-foundation.org>
	 <AANLkTimsDSrEL8vT877pLYSa4A338p4Y8w0Ya6Xm7BFJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 16:43:24 +0200
Message-ID: <1277217804.3057.428.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 22 juin 2010 à 08:08 -0600, Jeffrey Merkey a écrit :

Please dont top post on lkml (or netdev) messages

> OK.  This bug occurs if you OR in the IFF_UP flag while creating
> virtual interfaces without going through the normal ifup/ifdown
> scripts.  Looks like a hole.  I will post the trace shortly.  It's
> easy to reproduce, take the dummy net driver, OR in the IFF_UP flag in
> dummy_setup, and watch the kernel crash.
> 

Then dont do that ?

No need to send us a trace, unless you use a pristine kernel.

IFF_UP changes rules are very strict, dont try to avoid them and claim
there is a hole or something wrong.

Check __dev_open() , __dev_close() and __dev_change_flags() were OR/AND
IFF_UP is done by core network.

Net drivers are not allowed to change IFF_UP themselves.

(DE-600 & DE-620 being the exceptions to confirm this rule, of course)


> Jeff
> 
> On Mon, Jun 21, 2010 at 9:28 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Mon, 21 Jun 2010 20:57:40 -0600 Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
> >
> >> If someone sets the IFF_UP flags in the netdev structure without going
> >> through ifup userspace stuff, during unregister of the the netdev
> >> the dmaengine-put code will decrement the reference counter negative,
> >> and crash at BUG! in the driver/dma/dmaengine.c code.  This seems
> >> busted.
> >>
> >
> > Please send a copy of the kernel BUG trace.
> >
> -


