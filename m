Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab2JXI6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:58:41 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:49799 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933474Ab2JXI6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:58:38 -0400
Date: Wed, 24 Oct 2012 11:58:33 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/2] slab: commonize slab_cache field in struct page
In-Reply-To: <1350914737-4097-2-git-send-email-glommer@parallels.com>
Message-ID: <alpine.LFD.2.02.1210241158190.13035@tux.localdomain>
References: <1350914737-4097-1-git-send-email-glommer@parallels.com> <1350914737-4097-2-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Glauber Costa wrote:
> Right now, slab and slub have fields in struct page to derive which
> cache a page belongs to, but they do it slightly differently.
> 
> slab uses a field called slab_cache, that lives in the third double
> word. slub, uses a field called "slab", living outside of the
> doublewords area.
> 
> Ideally, we could use the same field for this. Since slub heavily makes
> use of the doubleword region, there isn't really much room to move
> slub's slab_cache field around. Since slab does not have such strict
> placement restrictions, we can move it outside the doubleword area.
> 
> The naming used by slab, "slab_cache", is less confusing, and it is
> preferred over slub's generic "slab".
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@kernel.org>
> CC: David Rientjes <rientjes@google.com>

Applied, thanks!
