Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2FZX6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:58:00 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60229 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab2FZX57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:57:59 -0400
Date: Tue, 26 Jun 2012 19:57:55 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] mm: introduce compaction and migration for virtio
 ballooned pages
Message-ID: <20120626235754.GB14782@localhost.localdomain>
References: <cover.1340665087.git.aquini@redhat.com>
 <7f83427b3894af7969c67acc0f27ab5aa68b4279.1340665087.git.aquini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f83427b3894af7969c67acc0f27ab5aa68b4279.1340665087.git.aquini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#if defined(CONFIG_VIRTIO_BALLOON) || defined(CONFIG_VIRTIO_BALLOON_MODULE)
> +/*
> + * Balloon pages special page->mapping.
> + * users must properly allocate and initiliaze an instance of balloon_mapping,

initialize

> + * and set it as the page->mapping for balloon enlisted page instances.
> + *
> + * address_space_operations necessary methods for ballooned pages:
> + *   .migratepage    - used to perform balloon's page migration (as is)
> + *   .invalidatepage - used to isolate a page from balloon's page list
> + *   .freepage       - used to reinsert an isolated page to balloon's page list
> + */
> +struct address_space *balloon_mapping;
> +EXPORT_SYMBOL(balloon_mapping);

Why don't you call this kvm_balloon_mapping - and when other balloon
drivers use it, then change it to something more generic. Also at that
future point the other balloon drivers might do it a bit differently so
it might be that will be reworked completly.
