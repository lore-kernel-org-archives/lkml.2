Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1A0PUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:20:04 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:42287 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1A0PUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:20:03 -0500
Date: Thu, 27 Jan 2011 16:19:21 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, linux-kernel@vger.kernel.org,
        stable@kernel.org, x86@kernel.org, xen-devel@lists.xensource.com,
        jeremy@goop.org, konrad.wilk@oracle.com, mingo@redhat.com,
        mingo@elte.hu
Subject: Re: [PATCH] xen: convert p2m to a 3 level tree - partial revert
Message-ID: <20110127151921.GB23746@router-fw-old.local.net-space.pl>
References: <20110127144843.GA23746@router-fw-old.local.net-space.pl> <4D41883A.3020603@canonical.com> <4D418907.2030708@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D418907.2030708@canonical.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 27, 2011 at 04:02:31PM +0100, Stefan Bader wrote:
> On 01/27/2011 03:59 PM, Stefan Bader wrote:
> > On 01/27/2011 03:48 PM, Daniel Kiper wrote:
> >> Hi,
> >>
> >> Durning work on Xen memory hotplug I discoverd that
> >> 2.6.38-rc2 does not boot on domU. After some investigation
> >> it appeared that 58e05027b530ff081ecea68e38de8d59db8f87e0
> >> commit changed CONFIG_XEN_MAX_DOMAIN_MEMORY constant value
> >> to 128. This change does not allow to boot kernel on domU
> >> with small memory size (I could confirm that it is even
> >> not possible to boot kernel on domU with 2 GiB). Guest
> >> crash silently without any warning. Durning further
> >> research I found out that there is another commit published
> >> recently (8e1b4cf2108488ccfb9a3e7ed7cd85a435e01d4b) which attempts
> >> to fix this issue, however, it does not work on my platform.
> >> I decided to reenable CONFIG_XEN_MAX_DOMAIN_MEMORY option in
> >> kernel config and enable users to choose resonable values for
> >> their machines until better fix will be published. I think this
> >> solution is good because allow users to boot domU with newest
> >> kernel and allow developers to continue their work without
> >> time presure which could lead to new bugs.
> >
> > Have you tried with a version that contains
> >
> > commit 8e1b4cf2108488ccfb9a3e7ed7cd85a435e01d4b
> > Author: Stefan Bader <stefan.bader@canonical.com>
> > Date:   Thu Jan 20 15:38:23 2011 +0100
> >
> >     xen: p2m: correctly initialize partial p2m leaf
> >
> > I still may need to send a follow up to add a matching RESERVE_BRK, but at least
> > I was able to boot small DomU's again.
> >
> > -Stefan
> >> This patch applies cleanly to current Linus' kernel tree.
>
> Sorry, did not read careful enough. So you did. Maybe you could actually try to
> make the additional change of
>
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -61,6 +61,7 @@ static RESERVE_BRK_ARRAY(unsigned long *, p2m_top_mfn_p, P2M_T
>
>  RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PE
>  RESERVE_BRK(p2m_mid_mfn, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MI
> +RESERVE_BRK(p2m_node, PAGE_SIZE);
>
>  static inline unsigned p2m_top_index(unsigned long pfn)
>  {
>
> This one I missed and probably that has more effects on big memory values.

No, it does not work (CONFIG_XEN_MAX_DOMAIN_MEMORY=128).

Daniel
