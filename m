Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2EWX0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:26:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:47285 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2EWX0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:26:02 -0400
Date: Thu, 24 May 2012 01:25:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alessandro Rubini <rubini@gnudd.com>
cc: x86@kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] x86/pci: sta2x11: fix a compiler warning
In-Reply-To: <20120523212821.GA10425@mail.gnudd.com>
Message-ID: <alpine.LFD.2.02.1205240123380.3231@ionos>
References: <20120523212821.GA10425@mail.gnudd.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Alessandro Rubini wrote:

> swiotlb_free_coherent(), exported by lib/swiotlb.b, cannot be used in
> dma_ops, because it doesn't want the "attrs" argument.  Add a wrapper,
> like other users of the function already do.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> ---
> 
> [V2: same patch, message fixed (sorry, I made a mess in the editor)]
> 
> Actually, we may instead add "args" to the exported functions in
> lib/swiotlb.  This would then remove a few other similar wrappers that
> do nothing.  If it's considered useful, I can propose a patch for that.

Yes please. Do nothing wrappers are harmful espcially if they get
common.

Thanks,

	tglx
