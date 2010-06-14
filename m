Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab0FNRQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:16:51 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34725 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab0FNRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:16:49 -0400
Date: Mon, 14 Jun 2010 22:46:24 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page cache
 control
Message-ID: <20100614171624.GY5191@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
 <4C10B3AF.7020908@redhat.com>
 <20100610142512.GB5191@balbir.in.ibm.com>
 <1276214852.6437.1427.camel@nimitz>
 <20100611045600.GE5191@balbir.in.ibm.com>
 <4C15E3C8.20407@redhat.com>
 <20100614084810.GT5191@balbir.in.ibm.com>
 <1276528376.6437.7176.camel@nimitz>
 <20100614165853.GW5191@balbir.in.ibm.com>
 <1276535371.6437.7417.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1276535371.6437.7417.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen <dave@linux.vnet.ibm.com> [2010-06-14 10:09:31]:

> On Mon, 2010-06-14 at 22:28 +0530, Balbir Singh wrote:
> > If you've got duplicate pages and you know
> > that they are duplicated and can be retrieved at a lower cost, why
> > wouldn't we go after them first?
> 
> I agree with this in theory.  But, the guest lacks the information about
> what is truly duplicated and what the costs are for itself and/or the
> host to recreate it.  "Unmapped page cache" may be the best proxy that
> we have at the moment for "easy to recreate", but I think it's still too
> poor a match to make these patches useful.
>

That is why the policy (in the next set) will come from the host. As
to whether the data is truly duplicated, my experiments show up to 60%
of the page cache is duplicated. The first patch today is again
enabled by the host. Both of them are expected to be useful in the
cache != none case.

The data I have shows more details including the performance and
overhead.

-- 
	Three Cheers,
	Balbir
