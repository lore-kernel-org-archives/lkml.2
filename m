Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0HKOfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 10:35:47 -0400
Received: from mail.perches.com ([173.55.12.10]:2384 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab0HKOfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 10:35:46 -0400
Subject: Re: [PATCH] DRM: Replace kmalloc/memset combos with kzalloc
From: Joe Perches <joe@perches.com>
To: dave@gnu.org
Cc: Dave Airlie <airlied@redhat.com>, Dave Airlie <airlied@linux.ie>,
        eric@anholt.net, dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281532732.2067.11.camel@cowboy>
References: <1281532732.2067.11.camel@cowboy>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 07:35:44 -0700
Message-ID: <1281537344.3976.32.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 09:18 -0400, Davidlohr Bueso wrote:
> memory allocation in drm_bufs.c is followed by initializing the memory with 0.
> 
> Replace the use of kmalloc+memset with kzalloc.

Perhaps kzalloc's with a multiply could/should also be converted
to kcalloc.

> +	entry->buflist = kzalloc(count * sizeof(*entry->buflist), GFP_KERNEL);

	entry->buflist = kcalloc(count, sizeof(*entry->buflist), GFP_KERNEL);

etc.

> +	entry->buflist = kzalloc(count * sizeof(*entry->buflist), GFP_KERNEL);
> +	entry->seglist = kzalloc(count * sizeof(*entry->seglist), GFP_KERNEL);
> +	entry->buflist = kzalloc(count * sizeof(*entry->buflist),
> +	entry->buflist = kzalloc(count * sizeof(*entry->buflist),


