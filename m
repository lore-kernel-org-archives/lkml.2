Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1ESMGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:06:04 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:16370 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1ESMGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:06:02 -0400
X-IronPort-AV: E=Sophos;i="4.65,237,1304294400"; 
   d="scan'208";a="5842187"
Date: Thu, 19 May 2011 13:08:07 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1505C9BBF8D40@shsmsx502.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.1105191304530.12963@kaball-desktop>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com> <alpine.LFD.2.02.1105061149330.3005@ionos> <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com> <alpine.DEB.2.00.1105061526120.10886@kaball-desktop>
 <625BA99ED14B2D499DC4E29D8138F1505C8ED7FB9F@shsmsx502.ccr.corp.intel.com> <alpine.DEB.2.00.1105091301040.10886@kaball-desktop> <alpine.LFD.2.02.1105091435350.2843@ionos> <625BA99ED14B2D499DC4E29D8138F1505C8F008B68@shsmsx502.ccr.corp.intel.com>
 <625BA99ED14B2D499DC4E29D8138F1505C9BBF8D40@shsmsx502.ccr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011, Tian, Kevin wrote:
> for [1/2] I think it's still necessary as it's meaningless to migrate a percpu type irq.
> However Stefano has sent out a cleanup patch for Xen percpu irqchip which uses
> nop mask/unmask hack borrowed from uv machine to work around the issue. As
> you suggested it's better to consolidate into the common place instead of scattering
> in different places. My view on this common logic is what [1/2] tries to address, is
> it correct? If yes, would you consider taking this patch? Stefano told me that his
> patches will go in in next merge window. So I think either you can take [1/2] now and
> then I'll do cleanup after Stefano's patch is in, or I can rebase my [1/2] after Stefano's
> patch to clean both xen and uv parts. 

Actually I think Kevin's generic patch is better too.
If you ack it I'll remove my patch right away from the queue (maybe I
should remove it anyway?).
Kevin probably needs to write a cleanup patch to remove the equivalent
hack from the uv_irq.
