Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2DQUZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:25:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38770 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2DQUZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:25:47 -0400
Date: Tue, 17 Apr 2012 13:25:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH linux-next] mm/hugetlb: fix warning in
 alloc_huge_page/dequeue_huge_page_vma
In-Reply-To: <20120417122819.7438.26117.stgit@zurg>
Message-ID: <alpine.DEB.2.00.1204171324500.10932@chino.kir.corp.google.com>
References: <20120417122819.7438.26117.stgit@zurg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1801852364-1334694346=:10932"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1801852364-1334694346=:10932
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 17 Apr 2012, Konstantin Khlebnikov wrote:

> This patch fixes gcc warning (and bug?) introduced in linux-next commit cc9a6c877
> ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
> 
> Local variable "page" can be uninitialized if nodemask from vma policy does not
> intersects with nodemask from cpuset. Even if it wouldn't happens it's better to
> initialize this variable explicitly than to introduce kernel oops on weird corner case.
> 
> mm/hugetlb.c: In function ‘alloc_huge_page’:
> mm/hugetlb.c:1135:5: warning: ‘page’ may be used uninitialized in this function
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Mel Gorman <mgorman@suse.de>

Acked-by: David Rientjes <rientjes@google.com>

This isn't just in -next, it's also in Linus' tree and seems like 3.4-rc4 
material to me.
--397155492-1801852364-1334694346=:10932--
