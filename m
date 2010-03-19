Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0CSIcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 04:32:21 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64886 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab0CSIcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 04:32:20 -0400
Date: Fri, 19 Mar 2010 17:30:25 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, andi.kleen@intel.com, fengguang.wu@intel.com
Subject: Re: [PATCH 1/2] pagemap: add #ifdefs CONFIG_HUGETLB_PAGE on code
	walking hugetlb vma
Message-ID: <20100319083025.GA13107@spritzerA.linux.bs1.fc.nec.co.jp>
References: <1268979996-12297-1-git-send-email-n-horiguchi@ah.jp.nec.com> <20100319152934.c4243698.kamezawa.hiroyu@jp.fujitsu.com> <20100319065334.GB12389@spritzerA.linux.bs1.fc.nec.co.jp> <20100319161504.2c5c65b5.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100319161504.2c5c65b5.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 04:15:04PM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 19 Mar 2010 15:53:34 +0900
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> 
> > On Fri, Mar 19, 2010 at 03:29:34PM +0900, KAMEZAWA Hiroyuki wrote:
> > > On Fri, 19 Mar 2010 15:26:35 +0900
> > > Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> > > 
> > > > If !CONFIG_HUGETLB_PAGE, pagemap_hugetlb_range() is never called.
> > > > So put it (and its calling function) into #ifdef block.
> > > > 
> > > > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > > 
> > > Hmm? What is benefit ? Is this broken now ?
> > > 
> > 
> > Not broken, but this is needed to avoid build error with patch 2/2 applied,
> > where I move huge_pte_offset() (not defined when !HUGETLB_PAGE)
> > into pagemap_hugetlb_range().
> > 
> 
> I think this should be merged with 2/2....if necessary.
> 

I split them for ease of review.
Also removing unused code is beneficial as it reduces kernel binary size.

But if you really want, I can merge them into one patch.

Thanks,
Naoya Horiguchi
