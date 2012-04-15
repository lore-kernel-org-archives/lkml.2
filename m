Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab2DOMq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 08:46:26 -0400
Received: from smtp1.su.se ([130.237.162.112]:46375 "EHLO smtp.su.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751837Ab2DOMqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 08:46:25 -0400
X-Spam-Flag: NO
X-Spam-Score: -4
Message-ID: <4F8AC31B.8010304@debian.org>
Date: Sun, 15 Apr 2012 14:46:19 +0200
From: Per Olofsson <pelle@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10]: Hibernation: fix the number of pages used for hibernate/thaw
 buffering
References: <1334052489.2178.9.camel@shrek.rexursive.com>  <b84d15d8-f35b-4296-927b-86a722541072@email.android.com>  <4F870317.1030408@debian.org> <1334266210.2573.8.camel@shrek.rexursive.com>
In-Reply-To: <1334266210.2573.8.camel@shrek.rexursive.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-04-12 23:30, Bojan Smojver skrev:
> I was thinking more like this:
> ----------------------
> unsigned long read_pages = 0;
> 
> [...]
> 
> if (low_free_pages() > snapshot_get_image_size())
>        read_pages = (low_free_pages() - snapshot_get_image_size()) / 2;
> read_pages = clamp_val(read_pages, LZO_MIN_RD_PAGES, LZO_MAX_RD_PAGES);
> ----------------------
> 
> Where LZO_MIN_RD_PAGES and LZO_MAX_RD_PAGES are set to 1024 and 8192,
> respectively (this was picked empirically).
> 
> Because we don't really know how many highmem pages are in the image
> (this is figured out by prepare_image() function, half way through
> reading the image - so way after this calculation is done), we assume
> the worst case scenario. And that is that there are no highmem pages in
> the image.
> 
> Given that we cannot use pages from highmem for buffers anyway, the
> above should be careful enough. Of course, there is still some
> possibility of running out of pages, but the kernel is usually in a
> pretty good shape memory-wise on image load, so we should be able to
> squeeze a few MBs out of it, at least.

OK, I see your point now.

Yet another reason to switch to 64-bit then I guess :-)

-- 
Pelle
