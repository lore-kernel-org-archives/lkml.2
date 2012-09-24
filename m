Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2IXMoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:44:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:37883 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2IXMob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:44:31 -0400
Message-ID: <1348490649.11847.59.camel@twins>
Subject: Re: [PATCH v10 1/5] mm: introduce a common interface for balloon
 pages mobility
From: Peter Zijlstra <peterz@infradead.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2012 14:44:09 +0200
In-Reply-To: <89c9f4096bbad072e155445fcdf1805d47ddf48e.1347897793.git.aquini@redhat.com>
References: <cover.1347897793.git.aquini@redhat.com>
	 <89c9f4096bbad072e155445fcdf1805d47ddf48e.1347897793.git.aquini@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-17 at 13:38 -0300, Rafael Aquini wrote:
> +static inline void assign_balloon_mapping(struct page *page,
> +                                         struct address_space
> *mapping)
> +{
> +       page->mapping = mapping;
> +       smp_wmb();
> +}
> +
> +static inline void clear_balloon_mapping(struct page *page)
> +{
> +       page->mapping = NULL;
> +       smp_wmb();
> +} 

barriers without a comment describing the data race are a mortal sin.
