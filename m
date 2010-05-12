Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab0ELE6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 00:58:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab0ELE6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 00:58:36 -0400
Date: Wed, 12 May 2010 00:58:27 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Alasdair G Kergon <agk@redhat.com>
cc: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix hard-coded disk header chunk size for persistent
 snapshot
In-Reply-To: <20100512013909.GD2377@agk-dp.fab.redhat.com>
Message-ID: <Pine.LNX.4.64.1005120055020.1551@hs20-bc2-1.build.redhat.com>
References: <4BEA0472.1060300@jp.fujitsu.com> <20100512013909.GD2377@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 May 2010, Alasdair G Kergon wrote:

> On Wed, May 12, 2010 at 10:29:22AM +0900, Tomohiro Kusumi wrote:
> > This patch fixes hard-coded value for the size of a chunk that includes
> > disk header for persistent snapshot. It should be changed to existing
> > macro NUM_SNAPSHOT_HDR_CHUNKS instead of using hard-coded value 1.
>  
> Any more places too?  (E.g. persistent_commit_merge)
> 
> Alasdair

I think the expression in persistent_commit_merge should be changed to:
ps->next_free = area_location(ps, ps->current_area) +
                ps->current_committed + 1;

It is numerically the same, but will avoid trouble if 
NUM_SNAPSHOT_HDR_CHUNKS is increased.

Mikulas
