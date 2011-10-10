Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1JJG6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:58:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37815 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1JJG6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:58:35 -0400
MIME-Version: 1.0
In-Reply-To: <201110071827.06366.arnd@arndb.de>
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com> <201110071827.06366.arnd@arndb.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 10 Oct 2011 08:58:14 +0200
X-Google-Sender-Auth: Ub5MbHs9obXmDsbvTYg8fv5dQmo
Message-ID: <CADMYwHzZWTgSEwr9gMJrK2mZgC2WiiGC9Pp6saZGx=PY-N=ueg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCHv16 0/9] Contiguous Memory Allocator
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jesse Barker <jesse.barker@linaro.org>, Mel Gorman <mel@csn.ul.ie>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 6:27 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> IMHO it would be good to merge the entire series into 3.2, since
> the ARM portion fixes an important bug (double mapping of memory
> ranges with conflicting attributes) that we've lived with for far
> too long, but it really depends on how everyone sees the risk
> for regressions here. If something breaks in unfixable ways before
> the 3.2 release, we can always revert the patches and have another
> try later.

I didn't thoroughly review the patches, but I did try them out (to be
precise, I tried v15) on an OMAP4 PandaBoard, and really liked the
result.

The interfaces seem clean and convenient and things seem to work (I
used a private CMA pool with rpmsg and remoteproc, but also noticed
that several other drivers were utilizing the global pool). And with
this in hand we can finally ditch the old reserve+ioremap approach.

So from a user perspective, I sure do hope this patch set gets into
3.2; hopefully we can just fix anything that would show up during the
3.2 cycle.

Marek, Michal (and everyone involved!), thanks so much for pushing
this! Judging from the history of this patch set and the areas that it
touches (and from the number of LWN articles ;) it looks like a
considerable feat.

FWIW, feel free to add my

Tested-by: Ohad Ben-Cohen <ohad@wizery.com>

(small and optional comment: I think it'd be nice if
dma_declare_contiguous would fail if called too late, otherwise users
of that misconfigured device will end up using the global pool without
easily knowing that something went wrong)

Thanks,
Ohad.
