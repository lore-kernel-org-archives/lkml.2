Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab1EWRv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:51:28 -0400
Received: from mail.perches.com ([173.55.12.10]:1895 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159Ab1EWRv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:51:27 -0400
Subject: Re: [PATCH] drivers: Use kzalloc instead of 'kmalloc+memset',
 where possible.
From: Joe Perches <joe@perches.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1306172407.8198.3.camel@localhost.localdomain>
References: <1306172407.8198.3.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 10:51:25 -0700
Message-ID: <1306173085.8687.38.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 23:40 +0600, Rakib Mullick wrote:
> Following patch removes the uses of 'kmalloc+memset' from various
> drivers subsystems, which is replaced by kzalloc. kzalloc take care of
> setting allocated memory with null, so it helps to get rid from using
> memset.
> diff --git a/drivers/gpu/drm/drm_scatter.c b/drivers/gpu/drm/drm_scatter.c
[]
> -	entry->pagelist = kmalloc(pages * sizeof(*entry->pagelist), GFP_KERNEL);
> +	entry->pagelist = kzalloc(pages * sizeof(*entry->pagelist), GFP_KERNEL);

Perhaps it's better to use:

	entry->pagelist =  kcalloc(pages, sizeof(*entry->pagelist), GFP_KERNEL);

> -	entry->busaddr = kmalloc(pages * sizeof(*entry->busaddr), GFP_KERNEL);
> +	entry->busaddr = kzalloc(pages * sizeof(*entry->busaddr), GFP_KERNEL);

here too.

