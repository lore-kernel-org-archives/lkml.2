Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab2EMRJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 13:09:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46209 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab2EMRJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 13:09:09 -0400
Date: Sun, 13 May 2012 20:12:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] iommu: off by one in dmar_get_fault_reason()
Message-ID: <20120513171214.GD16984@mwanda>
References: <20120512105935.GA19472@elgon.mountain>
 <4FAE595A.6010605@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAE595A.6010605@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 02:36:42PM +0200, walter harms wrote:
> 
> 
> Am 12.05.2012 12:59, schrieb Dan Carpenter:
> > fault_reason == ARRAY_SIZE(irq_remap_fault_reasons) + 0x20 - 0x20 is one
> > past the end of the array.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> > index 5ef65cf..9390f3f 100644
> > --- a/drivers/iommu/dmar.c
> > +++ b/drivers/iommu/dmar.c
> > @@ -1057,7 +1057,7 @@ static const char *irq_remap_fault_reasons[] =
> >  
> >  const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
> >  {
> > -	if (fault_reason >= 0x20 && (fault_reason <= 0x20 +
> > +	if (fault_reason >= 0x20 && (fault_reason < 0x20 +
> >  				     ARRAY_SIZE(irq_remap_fault_reasons))) {
> >  		*fault_type = INTR_REMAP;
> >  		return irq_remap_fault_reasons[fault_reason - 0x20];
> 
> perhaps this is more readable:
> if (fault_reason >= 0x20 && (fault_reason - 0x20 < ARRAY_SIZE(irq_remap_fault_reasons)))
> 

Yeah.  Probably you're way is nicer.

regards,
dan carpenter

