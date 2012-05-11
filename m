Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab2EKIbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:31:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42538 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab2EKIbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:31:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1205110054520.2801@eggly.anvils>
References: <alpine.LSU.2.00.1205110054520.2801@eggly.anvils>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 11 May 2012 10:30:56 +0200
Message-ID: <CA+1xoqcChazS=TRt6-7GjJAzQNFLFXmO623rWwjRkdD5x3k=iw@mail.gmail.com>
Subject: Re: [PATCH] mm: raise MemFree by reverting percpu_pagelist_fraction
 to 0
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 10:00 AM, Hugh Dickins <hughd@google.com> wrote:
> Commit 93278814d359 "mm: fix division by 0 in percpu_pagelist_fraction()"
> mistakenly initialized percpu_pagelist_fraction to the sysctl's minimum 8,
> which leaves 1/8th of memory on percpu lists (on each cpu??); but most of
> us expect it to be left unset at 0 (and it's not then used as a divisor).

I'm a bit confused about this, does it mean that once you set
percpu_pagelist_fraction to a value above the minimum, you can no
longer set it back to being 0?
