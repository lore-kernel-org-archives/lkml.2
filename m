Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab1EIMhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:37:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:46905 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1EIMhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:37:04 -0400
Date: Mon, 9 May 2011 14:36:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
In-Reply-To: <alpine.DEB.2.00.1105091301040.10886@kaball-desktop>
Message-ID: <alpine.LFD.2.02.1105091435350.2843@ionos>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com> <alpine.LFD.2.02.1105061149330.3005@ionos> <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com> <alpine.DEB.2.00.1105061526120.10886@kaball-desktop>
 <625BA99ED14B2D499DC4E29D8138F1505C8ED7FB9F@shsmsx502.ccr.corp.intel.com> <alpine.DEB.2.00.1105091301040.10886@kaball-desktop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 May 2011, Stefano Stabellini wrote:

> On Mon, 9 May 2011, Tian, Kevin wrote:
> > yes, with your patch this issue disappears, since you explicitly make mask/unmask as
> > a nop for xen_percpu_chip, which effectively avoids them from undesired unmask
> > when doing the migration. Though it works, it's not intuitive as to me it's an
> > workaround to make Xen chip implementation adapting to specific fixup_irqs logic.
> 
> I have been tring to follow the example of existing supported drivers.
> The only x86 driver I could find that uses handle_percpu_irq is uv_irq
> that does exatly the same thing.

Which is a good enough argument to make that change at the common code
level instead of having fancy workarounds here and there.

Thanks,

	tglx

