Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab0FNRkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:40:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37474 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab0FNRkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:40:20 -0400
Date: Mon, 14 Jun 2010 23:10:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, kvm <kvm@vger.kernel.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page cache
 control
Message-ID: <20100614174008.GA5191@balbir.in.ibm.com>
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
 <4C164C22.1050503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4C164C22.1050503@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2010-06-14 18:34:58]:

> On 06/14/2010 06:12 PM, Dave Hansen wrote:
> >On Mon, 2010-06-14 at 14:18 +0530, Balbir Singh wrote:
> >>1. A slab page will not be freed until the entire page is free (all
> >>slabs have been kfree'd so to speak). Normal reclaim will definitely
> >>free this page, but a lot of it depends on how frequently we are
> >>scanning the LRU list and when this page got added.
> >You don't have to be freeing entire slab pages for the reclaim to have
> >been useful.  You could just be making space so that _future_
> >allocations fill in the slab holes you just created.  You may not be
> >freeing pages, but you're reducing future system pressure.
> 
> Depends.  If you've evicted something that will be referenced soon,
> you're increasing system pressure.
>

I don't think slab pages care about being referenced soon, they are
either allocated or freed. A page is just a storage unit for the data
structure. A new one can be allocated on demand.
 
 

-- 
	Three Cheers,
	Balbir
