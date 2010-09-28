Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0I1Mjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:39:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab0I1Mjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:39:41 -0400
Date: Tue, 28 Sep 2010 14:39:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: stefano.stabellini@eu.citrix.com, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stephen Tweedie <sct@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 12/12] xen/mtrr: Add mtrr_if support for Xen mtrr
Message-ID: <20100928123925.GA18208@elte.hu>
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
 <1285676218-26218-12-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285676218-26218-12-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* stefano.stabellini@eu.citrix.com <stefano.stabellini@eu.citrix.com> wrote:

> From: Stephen Tweedie <sct@redhat.com>
> 
> Add a Xen mtrr type, and reorganise mtrr initialisation slightly to
> allow the mtrr driver to set up num_var_ranges (Xen needs to do this by
> querying the hypervisor itself.)
> 
> [ Impact: add basic MTRR support ]
> 
> Signed-off-by: Stephen Tweedie <sct@redhat.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/kernel/cpu/mtrr/Makefile |    2 +-
>  arch/x86/kernel/cpu/mtrr/main.c   |    3 +
>  arch/x86/kernel/cpu/mtrr/mtrr.h   |    7 ++
>  arch/x86/kernel/cpu/mtrr/xen.c    |  110 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 121 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/mtrr/xen.c

Still NAK, for the very same reasons as we NAK-ed it the previous time: 
/proc/mtrr is a problematic and complicated legacy interface that should 
die. Any modern X server will do the right thing via PAT.

Also, please get the Ack of at least one x86 maintainer for x86 patches.

Thanks,

	Ingo
