Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1E0PbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:31:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54900 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab1E0PbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:31:13 -0400
Subject: Re: [PATCH 01/10] mm: Introduce the memory regions data structure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org
In-Reply-To: <1306499498-14263-2-git-send-email-ankita@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
	 <1306499498-14263-2-git-send-email-ankita@in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 27 May 2011 08:30:03 -0700
Message-ID: <1306510203.22505.69.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 18:01 +0530, Ankita Garg wrote:
> +typedef struct mem_region_list_data {
> +       struct zone zones[MAX_NR_ZONES];
> +       int nr_zones;
> +
> +       int node;
> +       int region;
> +
> +       unsigned long start_pfn;
> +       unsigned long spanned_pages;
> +} mem_region_t;
> +
> +#define MAX_NR_REGIONS    16 

Don't do the foo_t thing.  It's out of style and the pg_data_t is a
dinosaur.

I'm a bit surprised how little discussion of this there is in the patch
descriptions.  Why did you choose this structure?  What are the
downsides of doing it this way?  This effectively breaks up the zone's
LRU in to MAX_NR_REGIONS LRUs.  What effects does that have?

How big _is_ a 'struct zone' these days?  This patch will increase their
effective size by 16x.

Since one distro kernel basically gets run on *EVERYTHING*, what will
MAX_NR_REGIONS be in practice?  How many regions are there on the
largest systems that will need this?  We're going to be doing many
linear searches and iterations over it, so it's pretty darn important to
know.  What does this do to lmbench numbers sensitive to page
allocations?

-- Dave

