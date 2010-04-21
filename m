Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0DUVK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:10:59 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:43716 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab0DUVK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:10:57 -0400
X-Greylist: delayed 1063 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2010 17:10:57 EDT
Date: Wed, 21 Apr 2010 23:10:52 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Dan Carpenter <error27@gmail.com>,
       Izik Eidus <ieidus@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] ksm: check for ERR_PTR from follow_page()
Message-ID: <20100421211052.GE5336@cmpxchg.org>
References: <20100421102759.GA29647@bicker> <4BCF18A8.8080809@redhat.com> <20100421174615.GO32034@random.random> <20100421205305.GO20640@cmpxchg.org> <20100421205807.GV32034@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421205807.GV32034@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 10:58:07PM +0200, Andrea Arcangeli wrote:
> On Wed, Apr 21, 2010 at 10:53:05PM +0200, Johannes Weiner wrote:
> > + * Returns the mapped (struct page *), %NULL if no mapping exists, or
> > + * an error pointer if there is a mapping to something not represented
> > + * by a page descriptor (see also vm_normal_page()).
> 
> where exactly in vm_normal_page? Note I already checked vm_normal_page
> before sending the prev email and I didn't immediately see.  I search
> return and they all return NULL except the return pfn_to_page(pfn), so
> is pfn_to_page that returns -EFAULT (the implementations I checked
> don't but there are plenty that I didn't check...).

It's not vm_normal_page() that returns -EFAULT.  It is follow_page()
that translates NULL from vm_normal_page() into -EFAULT.
