Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab0GVQOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:14:00 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49607 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0GVQNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:13:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6051"; a="48153594"
Date: Thu, 22 Jul 2010 09:13:53 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, alan@lxorguk.ukuu.org.uk,
        randy.dunlap@oracle.com, dwalker@codeaurora.org, mel@csn.ul.ie,
        linux-arm-msm@vger.kernel.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
Message-ID: <20100722161351.GB10255@codeaurora.org>
References: <20100713094244.7eb84f1b@lxorguk.ukuu.org.uk>
 <20100713174519D.fujita.tomonori@lab.ntt.co.jp>
 <20100713090223.GB20590@n2100.arm.linux.org.uk>
 <20100714105922D.fujita.tomonori@lab.ntt.co.jp>
 <20100722035026.GB14176@codeaurora.org>
 <20100722075151.GD6802@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722075151.GD6802@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 08:51:51AM +0100, Russell King - ARM Linux wrote:
> On Wed, Jul 21, 2010 at 08:50:26PM -0700, Zach Pfeffer wrote:
> > On Wed, Jul 14, 2010 at 10:59:43AM +0900, FUJITA Tomonori wrote:
> > > On Tue, 13 Jul 2010 10:02:23 +0100
> > > 
> > > Zach Pfeffer said this new VCM infrastructure can be useful for
> > > video4linux. However, I don't think we need 3,000-lines another
> > > abstraction layer to solve video4linux's issue nicely.
> > 
> > Its only 3000 lines because I haven't converted the code to use
> > function pointers.
> 
> I don't understand - you've made this claim a couple of times.  I
> can't see how converting the code to use function pointers (presumably
> to eliminate those switch statements) would reduce the number of lines
> of code.
> 
> Please explain (or show via new patches) how does converting this to
> function pointers significantly reduce the number of lines of code.
> 
> We might then be able to put just _one_ of these issues to bed.

Aye. Its getting worked on. Once its done I'll push it.

> 
> > Getting back to the point. There is no API that can handle large
> > buffer allocation and sharing with low-level attribute control for
> > virtual address spaces outside the CPU.
> 
> I think we've dealt with the attribute issue to death now.  Shall we
> repeat it again?

I think the only point of agreement is that all mappings must have
compatible attributes, the issue of multiple mappings is still
outstanding, as is needing more fine grained control of the attributes
of a set of compatible mappings (I still need to digest your examples
a little).

> 
> > The DMA API et al. take a CPU centric view of virtual space
> > management, sharing has to be explicitly written and external virtual
> > space management is left up to device driver writers.
> 
> I think I've also shown that not to be the case with example code.
> 
> The code behind the DMA API can be changed on a per-device basis
> (currently on ARM we haven't supported that because no one's asked
> for it yet) so that it can support multiple IOMMUs even of multiple
> different types.

I'm seeing that now. As I become more familiar with the DMA API the
way forward may become more clear to me. I certainly appreciate the
time you've spent discussing things and the code examples you've
listed. For example, it fairly clear how I can use a scatter list to
describe a mapping of big buffers. I can start down this path and see
what shakes out.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
