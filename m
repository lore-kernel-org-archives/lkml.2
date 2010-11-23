Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab0KWMgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:36:38 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:10585 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab0KWMgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:36:37 -0500
X-IronPort-AV: E=Sophos;i="4.59,241,1288569600"; 
   d="scan'208";a="3003220"
Date: Tue, 23 Nov 2010 12:36:39 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen/events: Use PIRQ instead of GSI value when unmapping
 MSI/MSI-X irqs.
In-Reply-To: <1290185334-29814-1-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.00.1011231236210.2373@kaball-desktop>
References: <1290185334-29814-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010, Konrad Rzeszutek Wilk wrote:
> When we allocate a vector for MSI/MSI-X we save away the PIRQ, and the
> vector value. When we unmap (de-allocate) the MSI/MSI-X vector(s) we
> need to provide the PIRQ and the vector value. What we did instead
> was to provide the GSI (which was zero) and the vector value, and we
> got these unhappy error messages:
> 
> (XEN) irq.c:1575: dom0: pirq 0 not mapped
> [    7.733415] unmap irq failed -22
> 
> This patches fixes this and we use the PIRQ value instead of the GSI
> value.
> 
> CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> P.S.
> Stefano, I've tested this on domain zero. The path on PVonHVM looks correct,
> but I would appreciate you taking a look at this.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

