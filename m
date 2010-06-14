Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab0FNQ7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:59:04 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58058 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab0FNQ7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:59:01 -0400
Date: Mon, 14 Jun 2010 22:28:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page cache
 control
Message-ID: <20100614165853.GW5191@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
 <4C10B3AF.7020908@redhat.com>
 <20100610142512.GB5191@balbir.in.ibm.com>
 <1276214852.6437.1427.camel@nimitz>
 <20100611045600.GE5191@balbir.in.ibm.com>
 <4C15E3C8.20407@redhat.com>
 <20100614084810.GT5191@balbir.in.ibm.com>
 <1276528376.6437.7176.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1276528376.6437.7176.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen <dave@linux.vnet.ibm.com> [2010-06-14 08:12:56]:

> On Mon, 2010-06-14 at 14:18 +0530, Balbir Singh wrote:
> > 1. A slab page will not be freed until the entire page is free (all
> > slabs have been kfree'd so to speak). Normal reclaim will definitely
> > free this page, but a lot of it depends on how frequently we are
> > scanning the LRU list and when this page got added.
> 
> You don't have to be freeing entire slab pages for the reclaim to have
> been useful.  You could just be making space so that _future_
> allocations fill in the slab holes you just created.  You may not be
> freeing pages, but you're reducing future system pressure.
> 
> If unmapped page cache is the easiest thing to evict, then it should be
> the first thing that goes when a balloon request comes in, which is the
> case this patch is trying to handle.  If it isn't the easiest thing to
> evict, then we _shouldn't_ evict it.
>

Like I said earlier, a lot of that works correctly as you said, but it
is also an idealization. If you've got duplicate pages and you know
that they are duplicated and can be retrieved at a lower cost, why
wouldn't we go after them first?

-- 
	Three Cheers,
	Balbir
