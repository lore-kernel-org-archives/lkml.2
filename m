Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab0L3WFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 17:05:55 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:51937 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0L3WFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 17:05:54 -0500
Date: Thu, 30 Dec 2010 23:02:28 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH R2 5/7] xen/balloon: Protect before CPU exhaust by event/x process
Message-ID: <20101230220228.GA17191@router-fw-old.local.net-space.pl>
References: <20101229170541.GJ2743@router-fw-old.local.net-space.pl> <20101230162611.GA24313@dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101230162611.GA24313@dumpdata.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 30, 2010 at 11:26:11AM -0500, Konrad Rzeszutek Wilk wrote:
> > -static int increase_reservation(unsigned long nr_pages)
> > +static enum bp_state increase_reservation(unsigned long nr_pages)
> >  {
> > +	enum bp_state state = BP_DONE;
> > +	int rc;
> >  	unsigned long  pfn, i, flags;
> >  	struct page   *page;
> > -	long           rc;
>
> How come? Is it just a cleanup?

I forgot to move it to separate patch. When I was working
on protection before CPU exhaust I discovered that
HYPERVISOR_memory_op() returns int and rc could be
declared as int not as long.

Daniel
