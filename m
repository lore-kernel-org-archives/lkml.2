Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab2HFRN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:13:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43093 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab2HFRN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:13:57 -0400
MIME-Version: 1.0
In-Reply-To: <ad942d93-489f-4bf4-96bc-8f65b1a23ea1@default>
References: <c31aaed4-9d50-4cdf-b794-367fc5850483@default>
	<CAOJsxLEhW=b3En737d5751xufW2BLehPc2ZGGG1NEtRVSo3=jg@mail.gmail.com>
	<b9bee363-321e-409a-bc8e-65ffed8a1dc5@default>
	<CAOJsxLHe6egmMWdEAGj7DGHHX-hqYMhVWDggny9CsT0H-DOL-g@mail.gmail.com>
	<f54214e7-cee4-4cbf-aad1-6c1f91867879@default>
	<CAOJsxLHyPj6KrVkB5nj-9vFBXKmn5BN4ArN_7MDmTeVEG3N3Gw@mail.gmail.com>
	<ad942d93-489f-4bf4-96bc-8f65b1a23ea1@default>
Date: Mon, 6 Aug 2012 20:13:55 +0300
X-Google-Sender-Auth: jGCccUt_v_w6ePbvd7uEfsL9Ueo
Message-ID: <CAOJsxLHwFqjFC8BqfCHA_6OPFbvNfaFkQEjfPTw=_6QsPKweNw@mail.gmail.com>
Subject: Re: [RFC/PATCH] zcache/ramster rewrite and promotion
From: Pekka Enberg <penberg@kernel.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 7:10 PM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
> Hmmm.. there's also zbud.c and tmem.c which are critical components
> of both zcache and ramster.  And there are header files as well which
> will need to either be in mm/ or somewhere in include/linux/
>
> Is there a reason or rule that mm/ can't have subdirectories?
>
> Since zcache has at least three .c files plus ramster.c, and
> since mm/frontswap.c and mm/cleancache.c are the foundation on
> which all of these are built, I was thinking grouping all six
> (plus headers) in the same mm/tmem/ subdirectory was a good
> way to keep mm/ from continuing to get more cluttered... not counting
> new zcache and ramster files, there are now 74 .c files in mm/!
> (Personally, I think a directory has too many files in it if
> "ls" doesn't fit in a 25x80 window.)
>
> Thoughts?

There's no reason we can't have subdirectories. That said, I really
don't see the point of having a separate directory called 'tmem'. It
might make sense to have mm/zcache and/or mm/ramster but I suspect
you can just fold the core code in mm/zcache.c and mm/ramster.c by
slimming down the weird Solaris-like 'tmem' abstractions.

                        Pekka
