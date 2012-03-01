Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab2CAHak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 02:30:40 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51407 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab2CAHaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 02:30:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of namhyung@gmail.com designates 10.68.138.130 as permitted sender) smtp.mail=namhyung@gmail.com; dkim=pass header.i=namhyung@gmail.com
Subject: Re: [PATCH -next] slub: set PG_slab on all of slab pages
From: Namhyung Kim <namhyung@gmail.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1202290922210.32268@router.home>
References: <1330505674-31610-1-git-send-email-namhyung.kim@lge.com>
	 <alpine.DEB.2.00.1202290922210.32268@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Mar 2012 16:30:31 +0900
Message-ID: <1330587031.1762.46.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-02-29, 09:24 -0600, Christoph Lameter wrote:
> On Wed, 29 Feb 2012, Namhyung Kim wrote:
> 
> > Unlike SLAB, SLUB doesn't set PG_slab on tail pages, so if a user would
> > call free_pages() incorrectly on a object in a tail page, she will get
> > confused with the undefined result. Setting the flag would help her by
> > emitting a warning on bad_page() in such a case.
> 
> NAK
> 
> You cannot free a tail page of a compound higher order page independently.
> You must free the whole compound.
> 

I meant freeing a *slab object* resides in a compound page using buddy
system API (e.g. free_pages). I know it's definitely a programming
error. However there's no safety net to protect and/or warn such a
misbehavior AFAICS - except for head page which has PG_slab set - when
it happened by any chance.

Without it, it might be possible to free part of tail pages silently,
and cause unexpected not-so-funny results some time later. It should be
hard to find out.

When I ran such a bad code using SLAB, I was able to be notified
immediately. That's why I'd like to add this patch to SLUB too. In
addition, it will give more correct value for slab pages when
using /proc/kpageflags IMHO.


-- 
Regards,
Namhyung Kim


