Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0L3Q1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 11:27:55 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:41057 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab0L3Q1y (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 30 Dec 2010 11:27:54 -0500
Date: Thu, 30 Dec 2010 11:26:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH R2 5/7] xen/balloon: Protect before CPU exhaust by
 event/x process
Message-ID: <20101230162611.GA24313@dumpdata.com>
References: <20101229170541.GJ2743@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101229170541.GJ2743@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -static int increase_reservation(unsigned long nr_pages)
> +static enum bp_state increase_reservation(unsigned long nr_pages)
>  {
> +	enum bp_state state = BP_DONE;
> +	int rc;
>  	unsigned long  pfn, i, flags;
>  	struct page   *page;
> -	long           rc;

How come? Is it just a cleanup?
