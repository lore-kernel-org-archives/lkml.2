Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1LFGs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:48:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab1LFGs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:48:58 -0500
Message-ID: <4EDDBC97.8040900@redhat.com>
Date: Tue, 06 Dec 2011 01:56:23 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Luciano Chavez <lnx1138@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmalloc: Check for page allocation failure before
 vmlist insertion
References: <20111205140750.GB5070@suse.de>
In-Reply-To: <20111205140750.GB5070@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 09:07 AM, Mel Gorman wrote:
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
> Reported-and-tested-by: Luciano Chavez<lnx1138@linux.vnet.ibm.com>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

