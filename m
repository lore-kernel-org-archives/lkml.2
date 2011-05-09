Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1EIMBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:01:17 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:65135 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab1EIMBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:01:16 -0400
X-IronPort-AV: E=Sophos;i="4.64,340,1301875200"; 
   d="scan'208";a="5659327"
Date: Mon, 9 May 2011 13:02:47 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1505C8ED7FB9F@shsmsx502.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.1105091301040.10886@kaball-desktop>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com> <alpine.LFD.2.02.1105061149330.3005@ionos> <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com> <alpine.DEB.2.00.1105061526120.10886@kaball-desktop>
 <625BA99ED14B2D499DC4E29D8138F1505C8ED7FB9F@shsmsx502.ccr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 May 2011, Tian, Kevin wrote:
> yes, with your patch this issue disappears, since you explicitly make mask/unmask as
> a nop for xen_percpu_chip, which effectively avoids them from undesired unmask
> when doing the migration. Though it works, it's not intuitive as to me it's an
> workaround to make Xen chip implementation adapting to specific fixup_irqs logic.

I have been tring to follow the example of existing supported drivers.
The only x86 driver I could find that uses handle_percpu_irq is uv_irq
that does exatly the same thing.
