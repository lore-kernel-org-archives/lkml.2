Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1LFU0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:26:09 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45208 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab1LFU0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:26:06 -0500
Date: Tue, 6 Dec 2011 12:26:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>,
        Luciano Chavez <lnx1138@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmalloc: Check for page allocation failure before
 vmlist insertion
In-Reply-To: <20111205140750.GB5070@suse.de>
Message-ID: <alpine.DEB.2.00.1112061225380.28251@chino.kir.corp.google.com>
References: <20111205140750.GB5070@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, Mel Gorman wrote:

> Commit [f5252e00: mm: avoid null pointer access in vm_struct via
> /proc/vmallocinfo] adds newly allocated vm_structs to the vmlist
> after it is fully initialised. Unfortunately, it did not check that
> __vmalloc_area_node() successfully populated the area. In the event
> of allocation failure, the vmalloc area is freed but the pointer to
> freed memory is inserted into the vmlist leading to a a crash later
> in get_vmalloc_info().
> 
> This patch adds a check for ____vmalloc_area_node() failure within
> __vmalloc_node_range. It does not use "goto fail" as in the previous
> error path as a warning was already displayed by __vmalloc_area_node()
> before it called vfree in its failure path.
> 
> Credit goes to Luciano Chavez for doing all the real work of
> identifying exactly where the problem was.
> 
> If accepted, this should be considered a -stable candidate.
> 

Right, for 3.1.x.

> Reported-and-tested-by: Luciano Chavez <lnx1138@linux.vnet.ibm.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David Rientjes <rientjes@google.com>
