Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1BVPnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:43:04 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:31333 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754285Ab1BVPnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:43:02 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 86nMzdMVM1laR_M1bKyNsYDJzjUYfGUbNvEjh_x_4KyHi2L
 a6UTgGuu8QvcRrWQ9VqN7HJ.CCnbyNQGG5Y.HaK0nhh9FN1OsJrYf28IuHFo
 N2H2upc0VsQsNxWaC.qMSKQsB3q5BgFhQjKzZ1mxmlfO.nrM88nKASb4LOPs
 VFUKBV_KdXhDPP1nrSJRbPMYzpWn7IR3CDn.y_enmsyJC2d_RsoCXUwp53ol
 t0R551QqTjFN6ga_hOVucUv2Hrd1.17AIh7NOVCQvmJukntObJ7pSbPhHl.w
 hhW2xdJ7cGQJzycpDfW0hYdy.5m7xuyz9g1ApGInk7aKdwrY-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 22 Feb 2011 09:42:58 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, aarcange@redhat.com, lwoodman@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/8] Change alloc_pages_vma to pass down the policy node
 for local policy
In-Reply-To: <1298315270-10434-3-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1102220941200.16060@router.home>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org> <1298315270-10434-3-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Andi Kleen wrote:

> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1524,10 +1524,9 @@ static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy)
>  }
>
>  /* Return a zonelist indicated by gfp for node representing a mempolicy */
> -static struct zonelist *policy_zonelist(gfp_t gfp, struct mempolicy *policy)
> +static struct zonelist *policy_zonelist(gfp_t gfp, struct mempolicy *policy,
> +	int nd)
>  {
> -	int nd = numa_node_id();
> -
>  	switch (policy->mode) {
>  	case MPOL_PREFERRED:
>  		if (!(policy->flags & MPOL_F_LOCAL))
> @@ -1679,7 +1678,7 @@ struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
>  		zl = node_zonelist(interleave_nid(*mpol, vma, addr,
>  				huge_page_shift(hstate_vma(vma))), gfp_flags);
>  	} else {
> -		zl = policy_zonelist(gfp_flags, *mpol);
> +		zl = policy_zonelist(gfp_flags, *mpol, numa_node_id());
>  		if ((*mpol)->mode == MPOL_BIND)
>  			*nodemask = &(*mpol)->v.nodes;
>  	}

If we do that then why not also consolidate the MPOL_INTERLEAVE
treatment also in policy_zonelist()? Looks awfully similar now and Would
simplify the code and likely get rid of some functions.

