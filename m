Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab0JGEIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 00:08:09 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42637 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab0JGEIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 00:08:07 -0400
Date: Thu, 7 Oct 2010 09:38:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        containers@lists.linux-foundation.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Restrict size of page_cgroup->flags
Message-ID: <20101007040802.GO4195@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101006142314.GG4195@balbir.in.ibm.com>
 <20101007095458.a992969e.nishimura@mxp.nes.nec.co.jp>
 <20101007031459.GL4195@balbir.in.ibm.com>
 <20101007124706.c602649e.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101007124706.c602649e.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* nishimura@mxp.nes.nec.co.jp <nishimura@mxp.nes.nec.co.jp> [2010-10-07 12:47:06]:

> On Thu, 7 Oct 2010 08:44:59 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * nishimura@mxp.nes.nec.co.jp <nishimura@mxp.nes.nec.co.jp> [2010-10-07 09:54:58]:
> > 
> > > On Wed, 6 Oct 2010 19:53:14 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > I propose restricting page_cgroup.flags to 16 bits. The patch for the
> > > > same is below. Comments?
> > > > 
> > > > 
> > > > Restrict the bits usage in page_cgroup.flags
> > > > 
> > > > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > > 
> > > > Restricting the flags helps control growth of the flags unbound.
> > > > Restriciting it to 16 bits gives us the possibility of merging
> > > > cgroup id with flags (atomicity permitting) and saving a whole
> > > > long word in page_cgroup
> > > > 
> > > I agree that reducing the size of page_cgroup would be good and important.
> > > But, wouldn't it be better to remove ->page, if possible ?
> > >
> > 
> > Without the page pointer, how do we go from pc to page for reclaim? 
> > 
> We store page_cgroups in arrays now, so I suppose we can implement pc_to_pfn()
> using the similar calculation as page_to_pfn() does.
> IIRC, KAMEZAWA-san talked about it in another thread.
>

Yes, correct we do. Your suggestions, IIUC is to reuse part of the
flags to store the section number where the pc belongs and then use
that to remove ->page pointer.

-- 
	Three Cheers,
	Balbir
