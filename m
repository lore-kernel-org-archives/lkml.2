Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab2FZQxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:53:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39241 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab2FZQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:53:05 -0400
Date: Tue, 26 Jun 2012 18:52:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/4] mm: introduce compaction and migration for virtio ballooned pages
Message-ID: <20120626165258.GY11413@one.firstfloor.org>
References: <cover.1340665087.git.aquini@redhat.com> <7f83427b3894af7969c67acc0f27ab5aa68b4279.1340665087.git.aquini@redhat.com> <20120626101729.GF8103@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626101729.GF8103@csn.ul.ie>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> What shocked me actually is that VM_BUG_ON code is executed on
> !CONFIG_DEBUG_VM builds and has been since 2.6.36 due to commit [4e60c86bd:
> gcc-4.6: mm: fix unused but set warnings]. I thought the whole point of
> VM_BUG_ON was to avoid expensive and usually unnecessary checks. Andi,
> was this deliberate?

The idea was that the compiler optimizes it away anyways.

I'm not fully sure what putback_balloon_page does, but if it just tests
a bit (without non variable test_bit) it should be ok.

-Andi
