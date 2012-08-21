Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2HUPUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:20:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51472 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2HUPU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:20:28 -0400
Message-ID: <1345562411.23018.111.camel@twins>
Subject: Re: [PATCH v8 1/5] mm: introduce a common interface for balloon
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
        Minchan Kim <minchan@kernel.org>, paulmck <paulmck@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2012 17:20:11 +0200
In-Reply-To: <e24f3073ef539985dea52943dcb84762213a0857.1345519422.git.aquini@redhat.com>
References: <cover.1345519422.git.aquini@redhat.com>
	 <e24f3073ef539985dea52943dcb84762213a0857.1345519422.git.aquini@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 09:47 -0300, Rafael Aquini wrote:
> +       mapping = rcu_access_pointer(page->mapping);
> +       if (mapping)
> +               mapping = mapping->assoc_mapping; 

The comment near rcu_access_pointer() explicitly says:

 * Return the value of the specified RCU-protected pointer, but omit the
 * smp_read_barrier_depends() and keep the ACCESS_ONCE().  This is useful
 * when the value of this pointer is accessed, but the pointer is not
 * dereferenced,

Yet you dereference the pointer... smells like fail to me.
