Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1JJMCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:02:20 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:33158 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753820Ab1JJMCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:02:18 -0400
MIME-Version: 1.0
In-Reply-To: <CADMYwHzZWTgSEwr9gMJrK2mZgC2WiiGC9Pp6saZGx=PY-N=ueg@mail.gmail.com>
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
	<201110071827.06366.arnd@arndb.de>
	<CADMYwHzZWTgSEwr9gMJrK2mZgC2WiiGC9Pp6saZGx=PY-N=ueg@mail.gmail.com>
Date: Mon, 10 Oct 2011 07:02:17 -0500
Message-ID: <CAO8GWq=zzXzPcWfuPFRi1jx7pgReL82-K2xFPS1TGekvEiQecQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCHv16 0/9] Contiguous Memory Allocator
From: "Clark, Rob" <rob@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linaro-mm-sig@lists.linaro.org,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 1:58 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Fri, Oct 7, 2011 at 6:27 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> IMHO it would be good to merge the entire series into 3.2, since
>> the ARM portion fixes an important bug (double mapping of memory
>> ranges with conflicting attributes) that we've lived with for far
>> too long, but it really depends on how everyone sees the risk
>> for regressions here. If something breaks in unfixable ways before
>> the 3.2 release, we can always revert the patches and have another
>> try later.
>
> I didn't thoroughly review the patches, but I did try them out (to be
> precise, I tried v15) on an OMAP4 PandaBoard, and really liked the
> result.
>
> The interfaces seem clean and convenient and things seem to work (I
> used a private CMA pool with rpmsg and remoteproc, but also noticed
> that several other drivers were utilizing the global pool). And with
> this in hand we can finally ditch the old reserve+ioremap approach.
>
> So from a user perspective, I sure do hope this patch set gets into
> 3.2; hopefully we can just fix anything that would show up during the
> 3.2 cycle.
>
> Marek, Michal (and everyone involved!), thanks so much for pushing
> this! Judging from the history of this patch set and the areas that it
> touches (and from the number of LWN articles ;) it looks like a
> considerable feat.
>
> FWIW, feel free to add my
>
> Tested-by: Ohad Ben-Cohen <ohad@wizery.com>

Marek, I guess I forgot to mention earlier, but I've been using CMA
for a couple of weeks now with omapdrm driver, so you can also add my:

Tested-by: Rob Clark <rob@ti.com>

BR,
-R

> (small and optional comment: I think it'd be nice if
> dma_declare_contiguous would fail if called too late, otherwise users
> of that misconfigured device will end up using the global pool without
> easily knowing that something went wrong)
>
> Thanks,
> Ohad.
>
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
>
