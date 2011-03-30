Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1C3Bkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:40:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754963Ab1C3Bkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:40:32 -0400
Date: Tue, 29 Mar 2011 18:41:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH]mmap: add alignment for some variables
Message-Id: <20110329184110.0086924e.akpm@linux-foundation.org>
In-Reply-To: <1301449000.3981.52.camel@sli10-conroe>
References: <1301277536.3981.27.camel@sli10-conroe>
	<m2oc4v18x8.fsf@firstfloor.org>
	<1301360054.3981.31.camel@sli10-conroe>
	<20110329152434.d662706f.akpm@linux-foundation.org>
	<1301446882.3981.33.camel@sli10-conroe>
	<20110329180611.a71fe829.akpm@linux-foundation.org>
	<1301447843.3981.48.camel@sli10-conroe>
	<20110329182544.6ad4eccb.akpm@linux-foundation.org>
	<1301449000.3981.52.camel@sli10-conroe>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 09:36:40 +0800 Shaohua Li <shaohua.li@intel.com> wrote:

> > how is it that this improves things?
> Hmm, it actually is:
> struct percpu_counter {
>  	spinlock_t lock;
>  	s64 count;
>  #ifdef CONFIG_HOTPLUG_CPU
>  	struct list_head list;	/* All percpu_counters are on a list */
>  #endif
>  	s32 __percpu *counters;
>  } __attribute__((__aligned__(1 << (INTERNODE_CACHE_SHIFT))))
> so lock and count are in one cache line.

____cacheline_aligned_in_smp would achieve that?
