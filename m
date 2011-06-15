Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab1FOLx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 07:53:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58263 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1FOLxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 07:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ffwll.ch; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:date
         :message-id:subject:from:to:cc:content-type;
        b=dae5CudbqUMJeNh3rNATixkWc34cWYT+Iu/l7QbTsD+JXuqx8wrdTgxPIM5XDSrl+s
         gPzLqoEyIzRx3uoV11ZR1y3JZB2oTol2MtqQH4qQlF9x8PscZ+FBMekVhSWcpgFbKWWi
         xascSZmzmBxmjbOiULsUncfje7ShmPt6+nlTA=
MIME-Version: 1.0
X-Originating-IP: [212.120.32.74]
In-Reply-To: <201106142030.07549.arnd@arndb.de>
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
	<201106141803.00876.arnd@arndb.de>
	<op.vw2r3xrj3l0zgt@mnazarewicz-glaptop>
	<201106142030.07549.arnd@arndb.de>
Date: Wed, 15 Jun 2011 13:53:22 +0200
Message-ID: <BANLkTi=XTJuF4np7+rYHzJqWK20OxMrBsw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory
 Allocator added
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Nazarewicz <mina86@mina86.com>, Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Jesse Barker <jesse.barker@linaro.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 20:30, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 14 June 2011 18:58:35 Michal Nazarewicz wrote:
>> Ah yes, I forgot that separate regions for different purposes could
>> decrease fragmentation.
>
> That is indeed a good point, but having a good allocator algorithm
> could also solve this. I don't know too much about these allocation
> algorithms, but there are probably multiple working approaches to this.

imo no allocator algorithm is gonna help if you have comparably large,
variable-sized contiguous allocations out of a restricted address range.
It might work well enough if there are only a few sizes and/or there's
decent headroom. But for really generic workloads this would require
sync objects and eviction callbacks (i.e. what Thomas Hellstrom pushed
with ttm).

So if this is only a requirement on very few platforms and can be
cheaply fixed with multiple cma allocation areas (heck, we have
slabs for the same reasons in the kernel), it might be a sensible
compromise.
-Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
