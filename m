Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1JLMDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:03:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51993 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab1JLMDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:03:12 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1110101102330.21957@sister.anvils>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
	<20110705144140.23872.86541.stgit@localhost.localdomain>
	<alpine.LSU.2.00.1107071742250.10362@sister.anvils>
	<20110708093859.299958df@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1107080917430.1781@sister.anvils>
	<20110711172517.46907e62@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1107111033440.1752@sister.anvils>
	<CAMeQTsb7ZMbyt8avYNOiBssERmk6vEbg7RR6TQw7CaD55MK22A@mail.gmail.com>
	<alpine.LSU.2.00.1110101102330.21957@sister.anvils>
Date: Wed, 12 Oct 2011 14:03:10 +0200
Message-ID: <CAMeQTsYYfBs+Z=2NZqN-9X=XpCT5cboA3DL0=FM0zr6a=ztAUA@mail.gmail.com>
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device independant
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Clark <rob.clark@linaro.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 8:37 PM, Hugh Dickins wrote:
> I was surprised to see drivers/staging/gma500 appearing still to use
> read_cache_page_gfp().  I assumed that since nobody was complaining,
> it must be on a currently unusable path.  But you have code coming up,
> that now enables that path?

Yes, I have a couple of patches for getting SDVO to properly set up DDC.
It seems we hit that path when framebuffer size exceeds a certain limit.

> Am I right to think that your immediate problem is just the oops in
> __read_cache_page(), that you're not yet about to hit the 4GB issue?

Correct, I have only seen 1GB and 2GB platforms so far. But the driver
does support platforms that I haven't got my hands on yet.

> I haven't rushed to address the 4GB issue, but what I have in mind is
> killing two-and-a-half birds with one stone, by putting a little cookie
> into the swapper_space radix_tree when we free a swapcache page, that
> specifies node/zone and hashes object/offset.
>
> NUMA mempolicies are too complex to be encapsulated in a sizeof(long)
> cookie, but it should improve the common case after swapin; while
> solving your 4GB GEM case, and vastly speeding up swapoff.
>
> Here's the kind of patch I imagined would be going in for gma500, that
> specifies __GFP_DMA32 on the mapping, so even swapoff can know that
> this object needs its pages below 4GB (even before my recent changes,
> swapoff would have broken you by inserting higher pages in the cache)
> - once I implement that.  But I've not tested this patch at all...

There are some other issues with SDVO when running at higher resolutions
that triggers the path. Will test your patch as soon as I get those things
sorted out, though it looks ok to me.

Thanks
Patrik
