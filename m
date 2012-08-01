Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab2HAUzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:55:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab2HAUzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:55:38 -0400
Message-ID: <5019975B.6010708@redhat.com>
Date: Wed, 01 Aug 2012 16:53:47 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rafael Aquini <aquini@linux.com>
Subject: Re: [PATCH v4 1/3] mm: introduce compaction and migration for virtio
 ballooned pages
References: <cover.1342485774.git.aquini@redhat.com> <49f828a9331c9b729fcf77226006921ec5bc52fa.1342485774.git.aquini@redhat.com> <20120718054824.GA32341@bbox> <20120720194858.GA16249@t510.redhat.com> <20120723023332.GA6832@bbox> <20120723181952.GA27373@t510.redhat.com>
In-Reply-To: <20120723181952.GA27373@t510.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 02:19 PM, Rafael Aquini wrote:

> In a glance, I believe this whole dance you're suggesting might just be too much
> of an overcomplication, and the best approach would be simply teaching the
> hotplug bits about the ballooned corner case just like it's being done to
> compaction/migration. However, I'll look at it carefully before making any other
> adjustments/propositions over here.

Compaction and hotplug do essentially the same thing
here: "collect all the movable pages from a page block,
and move them elsewhere".

Whether or not it is easier for them to share code, or
to duplicate a few lines of code, is something that can
be looked into later.
