Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab0FBOMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:12:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38855 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755184Ab0FBOMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:12:40 -0400
Subject: Re: [PATCH v2 0/3] kmemleak: Fix false positive with special scan
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: linux-kernel@vger.kernel.org, ext-phil.2.carmody@nokia.com,
       linux-omap@vger.kernel.org
In-Reply-To: <20100602.143458.232754971.Hiroshi.DOYU@nokia.com>
References: <20100602.143458.232754971.Hiroshi.DOYU@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 02 Jun 2010 15:12:29 +0100
Message-ID: <1275487949.23442.9.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jun 2010 14:12:29.0301 (UTC) FILETIME=[A293F250:01CB025D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 12:34 +0100, Hiroshi DOYU wrote:
> From: ext Catalin Marinas <catalin.marinas@arm.com>
> > Can we not add a new prio tree (or just use the existing one) for
> > pointer aliases? The advantage is that you only have a single function
> > to call, something like kmemleak_add_alias() and you do it at the point
> > the value was converted.
> 
> Actually I considered the above aliasing a little bit but I gave up
> soon.
> 
> I was afraid that this method might consume way more memory since this
> just adds another member for "struct kmemleak_object", but adding a
> single member for all objects. The number of kmemleak_object is
> usually numerous.

We could use a different tree with a "struct kmemleak_alias" structure
which is much smaller. Something like below:

struct kmemleak_alias {
	struct list_head alias_list;
	struct prio_tree_node tree_node;
	struct kmemleak_object *object;
}

And an alias_list member would be added to kmemleak_object as well.

Would the alias tree need to allow overlapping? Like different IOMMU
mappings with the same address (but pointing to different physical
memory).

-- 
Catalin

