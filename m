Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1DROJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:09:06 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:9910 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab1DROI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:08:57 -0400
X-IronPort-AV: E=Sophos;i="4.64,232,1301875200"; 
   d="scan'208";a="5355988"
Date: Mon, 18 Apr 2011 15:09:21 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 2/4] x86,xen: introduce
 x86_init.mapping.pagetable_reserve
In-Reply-To: <alpine.DEB.2.00.1104141746430.10886@kaball-desktop>
Message-ID: <alpine.DEB.2.00.1104181507180.10886@kaball-desktop>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com> <4DA5EAE4.2060406@linux.intel.com> <alpine.DEB.2.00.1104141218110.22672@kaball-desktop> <4DA70A4A.4030805@zytor.com>
 <alpine.DEB.2.00.1104141746430.10886@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Stefano Stabellini wrote:
> On Thu, 14 Apr 2011, H. Peter Anvin wrote:
> > On 04/14/2011 04:30 AM, Stefano Stabellini wrote:
> > > 
> > > I hope that the other email I have just sent clarifies the purpose of
> > > the hook.
> > > 		
> > 
> > You're commingling rationale and (proposed) semantics.  BOTH need to be
> > stated clearly.
> 
> Sorry I didn't answer the right question straight away.
> The semantics follow:
> 
> 
> 
> It is as if there is an implicit pvop after find_early_table_space
> that exports the range pgt_buf_start - pgt_buf_top.
> The range indicated is used, and it is the only range used, for the initial
> kernel pagetable pages.
> The range indicated is an overestimate.
> It is implicit because we use the pgt_buf_* variables directly but
> nonetheless it was in the first version of the patch.
> 
> After the pagetable setup done by kernel_physical_mapping_init, we know
> exactly how many pages we actually used for the initial kernel
> pagetables and how many are left unused.
> 
> The purpose of the second pvop (x86_init.mapping.pagetable_reserve) is
> to notify sub-architectures of the actual range used for initial kernel
> pagetable pages and partially revoke the previous indication.
> 
> 
> 
> If you agree with the proposed semantics above, I'll add the description
> to the commit message as well as the code. I could also modify the
> syntax of the new pvop call to better suit the semantics and/or restore
> the first pvop call.
> 

ping?


Sorry, I don't mean to be pushy, it is just that I'll be AFK for 12 days
starting from next Friday and I think that this issue should really be
fixed in time for the 2.6.39 release, otherwise no 2.6.39 kernels will
be able to boot on any xen system.
