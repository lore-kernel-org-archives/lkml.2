Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab0IADhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 23:37:06 -0400
Received: from ozlabs.org ([203.10.76.45]:52496 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab0IADhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 23:37:04 -0400
Date: Wed, 1 Sep 2010 13:32:37 +1000
From: Anton Blanchard <anton@samba.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] zram: various improvements and cleanups
Message-ID: <20100901033237.GA18958@kryten>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281374816-904-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Nitin,

I gave zram a try on a ppc64 box with a 64kB PAGE_SIZE. It looks like the
xvmalloc allocator fails when we add in a large enough block (in this case
65532 bytes).

flindex ends up as 127 which is larger than BITS_PER_LONG. We continually call
grow_block inside find_block and fail:

zram: Error allocating memory for compressed page: 0, size=467

Anton
