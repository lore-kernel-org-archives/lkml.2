Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1EXRJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:09:34 -0400
Received: from mail.perches.com ([173.55.12.10]:1962 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab1EXRJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:09:33 -0400
Subject: Re: [PATCH] drivers: Use kzalloc instead of 'kmalloc+memset',
 where possible.
From: Joe Perches <joe@perches.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <BANLkTikQjH5pdenTNRxyBwegbkRj0vGHLg@mail.gmail.com>
References: <1306172407.8198.3.camel@localhost.localdomain>
	 <1306173085.8687.38.camel@Joe-Laptop>
	 <BANLkTikQjH5pdenTNRxyBwegbkRj0vGHLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 10:09:31 -0700
Message-ID: <1306256971.2298.37.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 22:59 +0600, Rakib Mullick wrote:
> On 5/23/11, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2011-05-23 at 23:40 +0600, Rakib Mullick wrote:
> >> Following patch removes the uses of 'kmalloc+memset' from various
> >> drivers subsystems, which is replaced by kzalloc. kzalloc take care of
> >> setting allocated memory with null, so it helps to get rid from using
> >> memset.
> >> diff --git a/drivers/gpu/drm/drm_scatter.c b/drivers/gpu/drm/drm_scatter.c
> > []
> >> -	entry->pagelist = kmalloc(pages * sizeof(*entry->pagelist), GFP_KERNEL);
> >> +	entry->pagelist = kzalloc(pages * sizeof(*entry->pagelist), GFP_KERNEL);
> > Perhaps it's better to use:
> > 	entry->pagelist =  kcalloc(pages, sizeof(*entry->pagelist), GFP_KERNEL);
> >> -	entry->busaddr = kmalloc(pages * sizeof(*entry->busaddr), GFP_KERNEL);
> >> +	entry->busaddr = kzalloc(pages * sizeof(*entry->busaddr), GFP_KERNEL);
> > here too.
> Is there any significant benefit of using kcalloc here?

Overflow and tradition.

static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
{
	if (size != 0 && n > ULONG_MAX / size)
		return NULL;
	return __kmalloc(n * size, flags | __GFP_ZERO);
}


