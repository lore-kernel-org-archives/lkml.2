Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab1DZO3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:29:08 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:54383 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab1DZO3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:29:06 -0400
Date: Tue, 26 Apr 2011 16:25:35 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Daniel Kiper <dkiper@net-space.pl>, konrad.wilk@oracle.com,
        stefano.stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH REPOST] pv-grub: Fix for incorrect dom->p2m_host[] list initialization
Message-ID: <20110426142535.GA27417@router-fw-old.local.net-space.pl>
References: <20110422212545.GA22846@router-fw-old.local.net-space.pl> <20110422223331.GB5124@const.famille.thibault.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422223331.GB5124@const.famille.thibault.fr>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 12:33:32AM +0200, Samuel Thibault wrote:
> Hello,
>
> Daniel Kiper, le Fri 22 Apr 2011 23:25:45 +0200, a ?crit :
> > If pfn of newly allocated page is less than currently requested pfn
> > then relevant earlier allocated mfn is overwritten which leads to
> > domain crash later.
>
> Oops, good catch! And unfortunately it happens seldomly... I guess it
> may be the culprit for a fair number of other issues.

I discovered that issue on domU i386. It does not affect x86_64
in my environment. However, as you stated above that issue in some
circumstances could lead to mysterious system crashes or data
corruptions.

> > +	if (new_pfn < i)
> > +		for (new_pfn = i; new_pfn < dom->total_pages; ++new_pfn)
> > +			if (dom->p2m_host[new_pfn] == new_mfn)
> > +				break;
>
> Instead of looking for the page, which takes a linear time for each page
> and thus potentially quadratic time, we should probably rather record
> which PFN the MFNs < allocated have been moved to?

I am going to post new time optimized version
of that patch today or tommorow.

Daniel
