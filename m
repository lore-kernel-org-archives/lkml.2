Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1BVPei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:34:38 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:46007 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753177Ab1BVPeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:34:37 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: z6zLZXYVM1kPPML46_kOW4B0b5rTf84d2KhaEreSmIzOjhY
 9ltKEBKsrpqoD566k6Sc6vlYPrQf5_MIFvdkorz9QPxvFQmORYOz4YfsqQ54
 C00HZgoWiAGUUEHEpFBkfUlyQBDErVYwl4JMeACBX1AECS9UgKKY_kkBvl2F
 8L8KIZWr3g371cHUlof7SZHHnVccvNE0LuDN_t.qGpuFeHx3Dnf2gTW27XnD
 yzCNiv87ax9JO9Kr1gRN1fRL9LRMtPkW7D4EEmIUNl5trRvPHGMkJA4w_PM1
 q7JzUEyNjjPxW3jLHwZ4LhsTbOcG.fQ6T99yizVOmEqRZ4g--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 22 Feb 2011 09:34:33 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, aarcange@redhat.com, lwoodman@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] Fix interleaving for transparent hugepages
In-Reply-To: <1298315270-10434-2-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1102220933500.16060@router.home>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org> <1298315270-10434-2-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 21 Feb 2011, Andi Kleen wrote:

> @@ -1830,7 +1830,7 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
>  	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
>  		unsigned nid;
>
> -		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
> +		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT << order);

Should be PAGE_SHIFT + order.
x
