Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab2FZNRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:17:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab2FZNRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:17:51 -0400
Message-ID: <4FE9B677.8040409@redhat.com>
Date: Tue, 26 Jun 2012 09:17:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 1/4] mm: introduce compaction and migration for virtio
 ballooned pages
References: <cover.1340665087.git.aquini@redhat.com> <7f83427b3894af7969c67acc0f27ab5aa68b4279.1340665087.git.aquini@redhat.com>
In-Reply-To: <7f83427b3894af7969c67acc0f27ab5aa68b4279.1340665087.git.aquini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 07:25 PM, Rafael Aquini wrote:
> This patch introduces helper functions that teach compaction and migration bits
> how to cope with pages which are part of a guest memory balloon, in order to
> make them movable by memory compaction procedures.
>
> Signed-off-by: Rafael Aquini<aquini@redhat.com>

The function fill_balloon in drivers/virtio/virtio_balloon.c
should probably add __GFP_MOVABLE to the gfp mask for alloc_pages,
to keep the pageblock where balloon pages are allocated marked
as movable.

-- 
All rights reversed
