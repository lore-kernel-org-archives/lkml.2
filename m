Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2HGNfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:35:08 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:24622 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2HGNfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:35:06 -0400
MIME-Version: 1.0
Message-ID: <b16eb976-6b02-4ba5-b0b8-219f25c99c0d@default>
Date: Tue, 7 Aug 2012 06:34:30 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: RE: [RFC/PATCH] zcache/ramster rewrite and promotion
References: <c31aaed4-9d50-4cdf-b794-367fc5850483@default>
 <CAOJsxLEhW=b3En737d5751xufW2BLehPc2ZGGG1NEtRVSo3=jg@mail.gmail.com>
 <b9bee363-321e-409a-bc8e-65ffed8a1dc5@default>
 <CAOJsxLHe6egmMWdEAGj7DGHHX-hqYMhVWDggny9CsT0H-DOL-g@mail.gmail.com>
 <f54214e7-cee4-4cbf-aad1-6c1f91867879@default>
 <CAOJsxLHyPj6KrVkB5nj-9vFBXKmn5BN4ArN_7MDmTeVEG3N3Gw@mail.gmail.com>
 <ad942d93-489f-4bf4-96bc-8f65b1a23ea1@default>
 <CAOJsxLHwFqjFC8BqfCHA_6OPFbvNfaFkQEjfPTw=_6QsPKweNw@mail.gmail.com>
In-Reply-To: <CAOJsxLHwFqjFC8BqfCHA_6OPFbvNfaFkQEjfPTw=_6QsPKweNw@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pekka Enberg [mailto:penberg@kernel.org]
> Subject: Re: [RFC/PATCH] zcache/ramster rewrite and promotion
> 
> On Mon, Aug 6, 2012 at 7:10 PM, Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> > Hmmm.. there's also zbud.c and tmem.c which are critical components
> > of both zcache and ramster.  And there are header files as well which
> > will need to either be in mm/ or somewhere in include/linux/
> >
> > Is there a reason or rule that mm/ can't have subdirectories?
> >
> > Since zcache has at least three .c files plus ramster.c, and
> > since mm/frontswap.c and mm/cleancache.c are the foundation on
> > which all of these are built, I was thinking grouping all six
> > (plus headers) in the same mm/tmem/ subdirectory was a good
> > way to keep mm/ from continuing to get more cluttered... not counting
> > new zcache and ramster files, there are now 74 .c files in mm/!
> > (Personally, I think a directory has too many files in it if
> > "ls" doesn't fit in a 25x80 window.)
> >
> > Thoughts?
> 
> There's no reason we can't have subdirectories. That said, I really
> don't see the point of having a separate directory called 'tmem'. It
> might make sense to have mm/zcache and/or mm/ramster but I suspect
> you can just fold the core code in mm/zcache.c and mm/ramster.c by
> slimming down the weird Solaris-like 'tmem' abstractions.

I'm not sure I understand... what is Solaris-like about tmem?
And what would you slim down?

While I agree one can often glom three separate 1000-line .c files
into a single 3000-line .c file, I recently spent some time moving
the other direction to, I thought, improve readability.  Do kernel
developers have a preference for huge .c files rather than smaller
logically-separated moderate-sized files in a subdirectory?

Thanks,
Dan
