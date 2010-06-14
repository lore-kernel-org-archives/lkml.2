Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0FNPNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:13:46 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35709 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378Ab0FNPNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:13:45 -0400
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page
 cache control
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100614084810.GT5191@balbir.in.ibm.com>
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
	 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
	 <4C10B3AF.7020908@redhat.com> <20100610142512.GB5191@balbir.in.ibm.com>
	 <1276214852.6437.1427.camel@nimitz>
	 <20100611045600.GE5191@balbir.in.ibm.com> <4C15E3C8.20407@redhat.com>
	 <20100614084810.GT5191@balbir.in.ibm.com>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 08:12:56 -0700
Message-Id: <1276528376.6437.7176.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 14:18 +0530, Balbir Singh wrote:
> 1. A slab page will not be freed until the entire page is free (all
> slabs have been kfree'd so to speak). Normal reclaim will definitely
> free this page, but a lot of it depends on how frequently we are
> scanning the LRU list and when this page got added.

You don't have to be freeing entire slab pages for the reclaim to have
been useful.  You could just be making space so that _future_
allocations fill in the slab holes you just created.  You may not be
freeing pages, but you're reducing future system pressure.

If unmapped page cache is the easiest thing to evict, then it should be
the first thing that goes when a balloon request comes in, which is the
case this patch is trying to handle.  If it isn't the easiest thing to
evict, then we _shouldn't_ evict it.

-- Dave


