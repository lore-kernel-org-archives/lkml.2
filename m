Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab2HFQLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:11:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50178 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab2HFQLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:11:36 -0400
MIME-Version: 1.0
Message-ID: <ad942d93-489f-4bf4-96bc-8f65b1a23ea1@default>
Date: Mon, 6 Aug 2012 09:10:26 -0700 (PDT)
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
In-Reply-To: <CAOJsxLHyPj6KrVkB5nj-9vFBXKmn5BN4ArN_7MDmTeVEG3N3Gw@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pekka Enberg [mailto:penberg@kernel.org]
> Subject: Re: [RFC/PATCH] zcache/ramster rewrite and promotion
> 
> On Mon, Aug 6, 2012 at 5:07 PM, Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> > I'm OK with placing it wherever kernel developers want to put
> > it, as long as the reason is not NIMBY-ness. [1]  My preference
> > is to keep all the parts together, at least for the review phase,
> > but if there is a consensus that it belongs someplace else,
> > I will be happy to move it.
> 
> I'd go for core code in mm/zcache.c and mm/ramster.c, and move the
> clustering code under net/ramster or drivers/ramster.

Hi Pekka --

Thanks for the quick feedback!

Hmmm.. there's also zbud.c and tmem.c which are critical components
of both zcache and ramster.  And there are header files as well which
will need to either be in mm/ or somewhere in include/linux/

Is there a reason or rule that mm/ can't have subdirectories?

Since zcache has at least three .c files plus ramster.c, and
since mm/frontswap.c and mm/cleancache.c are the foundation on
which all of these are built, I was thinking grouping all six
(plus headers) in the same mm/tmem/ subdirectory was a good
way to keep mm/ from continuing to get more cluttered... not counting
new zcache and ramster files, there are now 74 .c files in mm/!
(Personally, I think a directory has too many files in it if
"ls" doesn't fit in a 25x80 window.)

Thoughts?
Dan
