Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1LBLgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 06:36:48 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42022 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab1LBLgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 06:36:47 -0500
Message-ID: <1322825802.2607.10.camel@edumazet-laptop>
Subject: Re: [PATCH 1/3] slub: set a criteria for slub node partial adding
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: cl@linux.com, penberg@kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Fri, 02 Dec 2011 12:36:42 +0100
In-Reply-To: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 02 décembre 2011 à 16:23 +0800, Alex Shi a écrit :
> From: Alex Shi <alexs@intel.com>
> 
> Times performance regression were due to slub add to node partial head
> or tail. That inspired me to do tunning on the node partial adding, to
> set a criteria for head or tail position selection when do partial
> adding.
> My experiment show, when used objects is less than 1/4 total objects
> of slub performance will get about 1.5% improvement on netperf loopback
> testing with 2048 clients, wherever on our 4 or 2 sockets platforms,
> includes sandbridge or core2.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  mm/slub.c |   18 ++++++++----------
>  1 files changed, 8 insertions(+), 10 deletions(-)
> 

netperf (loopback or ethernet) is a known stress test for slub, and your
patch removes code that might hurt netperf, but benefit real workload.

Have you tried instead this far less intrusive solution ?

if (tail == DEACTIVATE_TO_TAIL ||
    page->inuse > page->objects / 4)
         list_add_tail(&page->lru, &n->partial);
else
         list_add(&page->lru, &n->partial);



