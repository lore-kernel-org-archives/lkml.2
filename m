Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066Ab0JGDPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 23:15:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41751 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab0JGDPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 23:15:04 -0400
Date: Thu, 7 Oct 2010 08:44:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        containers@lists.linux-foundation.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Restrict size of page_cgroup->flags
Message-ID: <20101007031459.GL4195@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101006142314.GG4195@balbir.in.ibm.com>
 <20101007095458.a992969e.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101007095458.a992969e.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* nishimura@mxp.nes.nec.co.jp <nishimura@mxp.nes.nec.co.jp> [2010-10-07 09:54:58]:

> On Wed, 6 Oct 2010 19:53:14 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > I propose restricting page_cgroup.flags to 16 bits. The patch for the
> > same is below. Comments?
> > 
> > 
> > Restrict the bits usage in page_cgroup.flags
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > Restricting the flags helps control growth of the flags unbound.
> > Restriciting it to 16 bits gives us the possibility of merging
> > cgroup id with flags (atomicity permitting) and saving a whole
> > long word in page_cgroup
> > 
> I agree that reducing the size of page_cgroup would be good and important.
> But, wouldn't it be better to remove ->page, if possible ?
>

Without the page pointer, how do we go from pc to page for reclaim? 

-- 
	Three Cheers,
	Balbir
