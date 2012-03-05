Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab2CEK7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:59:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53734 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab2CEK7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:59:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of minchan.kim@gmail.com designates 10.68.233.65 as permitted sender) smtp.mail=minchan.kim@gmail.com; dkim=pass header.i=minchan.kim@gmail.com
Date: Mon, 5 Mar 2012 19:59:18 +0900
From: Minchan Kim <minchan@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] slub: set PG_slab on all of slab pages
Message-ID: <20120305105918.GA13252@barrios>
References: <1330505674-31610-1-git-send-email-namhyung.kim@lge.com>
 <20120304103446.GA9267@barrios>
 <4F547C90.4040007@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F547C90.4040007@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 05:42:56PM +0900, Namhyung Kim wrote:
> 2012-03-04 7:34 PM, Minchan Kim wrote:
> >Hi Namhyung,
> >
> 
> Hi Minchan,
> glad to see you here again :)

Thanks!

> 
> 
> >On Wed, Feb 29, 2012 at 05:54:34PM +0900, Namhyung Kim wrote:
> >>Unlike SLAB, SLUB doesn't set PG_slab on tail pages, so if a user would
> >>call free_pages() incorrectly on a object in a tail page, she will get
> >>i confused with the undefined result. Setting the flag would help her by
> >>emitting a warning on bad_page() in such a case.
> >>
> >>Reported-by: Sangseok Lee <sangseok.lee@lge.com>
> >>Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> >
> >I read this thread and I feel the we don't reach right point.
> >I think it's not a compound page problem.
> >We can face above problem where we allocates big order page without __GFP_COMP
> >and free middle page of it.
> >
> >Fortunately, We can catch such a problem by put_page_testzero in __free_pages
> >if you enable CONFIG_DEBUG_VM.
> >
> >Did you tried that with CONFIG_DEBUG_VM?
> >
> 
> To be honest, I don't have a real test environment which brings this
> issue in the first place. On my simple test environment, enabling
> CONFIG_DEBUG_VM emits a bug when I tried to free middle of the slab
> pages. Thanks for pointing it out.
> 
> However I guess there was a chance to bypass that test anyhow since
> it did reach to __free_pages_ok(). If the page count was 0 already,
> free_pages() will prevent it from getting to the function even
> though CONFIG_DEBUG_VM was disabled. But I don't think it's a kernel
> bug - it seems entirely our fault :( I'll recheck and talk about it
> with my colleagues.

Let me ask a question.
Could you see bad page message by PG_slab with SLUB after you apply your patch?

