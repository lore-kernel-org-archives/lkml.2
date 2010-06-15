Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0FOHwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:52:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36772 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0FOHwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:52:14 -0400
Date: Tue, 15 Jun 2010 13:22:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, kvm <kvm@vger.kernel.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page cache
 control
Message-ID: <20100615075210.GB4306@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100610142512.GB5191@balbir.in.ibm.com>
 <1276214852.6437.1427.camel@nimitz>
 <20100611045600.GE5191@balbir.in.ibm.com>
 <4C15E3C8.20407@redhat.com>
 <20100614084810.GT5191@balbir.in.ibm.com>
 <1276528376.6437.7176.camel@nimitz>
 <20100614165853.GW5191@balbir.in.ibm.com>
 <1276535371.6437.7417.camel@nimitz>
 <20100614171624.GY5191@balbir.in.ibm.com>
 <4C1727EC.2020500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4C1727EC.2020500@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2010-06-15 10:12:44]:

> On 06/14/2010 08:16 PM, Balbir Singh wrote:
> >* Dave Hansen<dave@linux.vnet.ibm.com>  [2010-06-14 10:09:31]:
> >
> >>On Mon, 2010-06-14 at 22:28 +0530, Balbir Singh wrote:
> >>>If you've got duplicate pages and you know
> >>>that they are duplicated and can be retrieved at a lower cost, why
> >>>wouldn't we go after them first?
> >>I agree with this in theory.  But, the guest lacks the information about
> >>what is truly duplicated and what the costs are for itself and/or the
> >>host to recreate it.  "Unmapped page cache" may be the best proxy that
> >>we have at the moment for "easy to recreate", but I think it's still too
> >>poor a match to make these patches useful.
> >>
> >That is why the policy (in the next set) will come from the host. As
> >to whether the data is truly duplicated, my experiments show up to 60%
> >of the page cache is duplicated.
> 
> Isn't that incredibly workload dependent?
> 
> We can't expect the host admin to know whether duplication will
> occur or not.
>

I was referring to cache = (policy) we use based on the setup. I don't
think the duplication is too workload specific. Moreover, we could use
aggressive policies and restrict page cache usage or do it selectively
on ballooning. We could also add other options to make the ballooning
option truly optional, so that the system management software decides. 

-- 
	Three Cheers,
	Balbir
