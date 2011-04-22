Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab1DVWdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:33:36 -0400
Received: from solo.fdn.fr ([80.67.169.19]:51249 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab1DVWdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:33:35 -0400
Date: Sat, 23 Apr 2011 00:33:32 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: konrad.wilk@oracle.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH REPOST] pv-grub: Fix for incorrect dom->p2m_host[] list initialization
Message-ID: <20110422223331.GB5124@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Daniel Kiper <dkiper@net-space.pl>, konrad.wilk@oracle.com,
	stefano.stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
	linux-kernel@vger.kernel.org
References: <20110422212545.GA22846@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110422212545.GA22846@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Daniel Kiper, le Fri 22 Apr 2011 23:25:45 +0200, a écrit :
> If pfn of newly allocated page is less than currently requested pfn
> then relevant earlier allocated mfn is overwritten which leads to
> domain crash later.

Oops, good catch! And unfortunately it happens seldomly... I guess it
may be the culprit for a fair number of other issues.

> +	if (new_pfn < i)
> +		for (new_pfn = i; new_pfn < dom->total_pages; ++new_pfn)
> +			if (dom->p2m_host[new_pfn] == new_mfn)
> +				break;

Instead of looking for the page, which takes a linear time for each page
and thus potentially quadratic time, we should probably rather record
which PFN the MFNs < allocated have been moved to?

Samuel
