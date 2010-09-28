Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab0I1OBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:01:12 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:4637 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab0I1OBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:01:11 -0400
X-IronPort-AV: E=Sophos;i="4.57,247,1283731200"; 
   d="scan'208";a="2076471"
Date: Tue, 28 Sep 2010 15:00:58 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ingo Molnar <mingo@elte.hu>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "sct@redhat.com" <sct@redhat.com>
Subject: Re: [PATCH 12/12] xen/mtrr: Add mtrr_if support for Xen mtrr
In-Reply-To: <20100928123925.GA18208@elte.hu>
Message-ID: <alpine.DEB.2.00.1009281455300.2864@kaball-desktop>
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop> <1285676218-26218-12-git-send-email-stefano.stabellini@eu.citrix.com> <20100928123925.GA18208@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010, Ingo Molnar wrote:
> 
> * stefano.stabellini@eu.citrix.com <stefano.stabellini@eu.citrix.com> wrote:
> 
> > From: Stephen Tweedie <sct@redhat.com>
> > 
> > Add a Xen mtrr type, and reorganise mtrr initialisation slightly to
> > allow the mtrr driver to set up num_var_ranges (Xen needs to do this by
> > querying the hypervisor itself.)
> > 
> > [ Impact: add basic MTRR support ]
> > 
> > Signed-off-by: Stephen Tweedie <sct@redhat.com>
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/x86/kernel/cpu/mtrr/Makefile |    2 +-
> >  arch/x86/kernel/cpu/mtrr/main.c   |    3 +
> >  arch/x86/kernel/cpu/mtrr/mtrr.h   |    7 ++
> >  arch/x86/kernel/cpu/mtrr/xen.c    |  110 +++++++++++++++++++++++++++++++++++++
> >  4 files changed, 121 insertions(+), 1 deletions(-)
> >  create mode 100644 arch/x86/kernel/cpu/mtrr/xen.c
> 
> Still NAK, for the very same reasons as we NAK-ed it the previous time: 
> /proc/mtrr is a problematic and complicated legacy interface that should 
> die. Any modern X server will do the right thing via PAT.
> 

Sorry I should have read the original thread more carefully: I didn't
realize this patch had been NAK-ed.

However it is not a problem because we can easily disable MTRRs from Xen
and with no cpu_has_mtrr the kernel would still boot fine on Xen.
Also I think we do have PAT support nowadays but I'll let Jeremy comment
on that.


> Also, please get the Ack of at least one x86 maintainer for x86 patches.
> 
 
I'll repost the series without the last two patches, so there won't be
any x86 changes at all :)

Many thanks for your quick feedback,

Stefano
