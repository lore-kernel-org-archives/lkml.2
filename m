Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab0IOEfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 00:35:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab0IOEfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 00:35:14 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v2] After swapout/swapin private dirty mappings are reported clean in smaps
Date: Wed, 15 Sep 2010 10:08:05 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: Richard Guenther <rguenther@suse.de>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com,
        Michael Matz <matz@novell.com>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org
References: <201009142242.29245.knikanth@suse.de> <201009142244.59080.knikanth@suse.de> <20100915092504.C9DC.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100915092504.C9DC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009151008.05129.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 September 2010 05:56:36 KOSAKI Motohiro wrote:
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 439fc1f..06fc468 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -368,7 +368,11 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long
> > addr, unsigned long end, mss->shared_clean += PAGE_SIZE;
> >  			mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
> >  		} else {
> > -			if (pte_dirty(ptent))
> > +			/*
> > +			 * File-backed pages, now anonymous are dirty
> > +			 * with respect to the file.
> > +			 */
> > +			if (pte_dirty(ptent) || (vma->vm_file && PageAnon(page)))
> >  				mss->private_dirty += PAGE_SIZE;
> >  			else
> >  				mss->private_clean += PAGE_SIZE;
> 
> This is risky than v1. number of dirties are used a lot of application.
> 

This is exactly to help those applications, as currently after swap-out and 
swap-in, the same pages are accounted as "Private_Clean:" instead of 
"Private_Dirty:".

Thanks
Nikanth
