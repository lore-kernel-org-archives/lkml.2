Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1HJPfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:35:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48331 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1HJPfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:35:50 -0400
Subject: Re: [PATCH 0/3] minor cleanups to EFLAGS initialisation in
 ret_from_fork
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Wed, 10 Aug 2011 17:35:21 +0200
In-Reply-To: <1312990047.26263.248.camel@zakaz.uk.xensource.com>
References: <1311587883.27940.20.camel@cthulhu.hellion.org.uk>
	 <20110725101902.GP4362@sun> <20110725182049.GD27137@sun>
	 <4E2DDBAA.60200@zytor.com>  <20110725214731.GE27137@sun>
	 <1311691594.24752.40.camel@twins>
	 <1312990047.26263.248.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312990522.23660.10.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 16:27 +0100, Ian Campbell wrote:
> raw_spin_unlock_irq unconditionally re-enables interrupts so I don't
> really see what I've changed since interrupts are enabled by
> schedule_tail and I've moved (on 64 bit) the EFLAGS reset to after
> schedule_tail, so it should have interrupts enabled at that point
> already and so they should remain enabled. Or are you suggesting that
> things were already wrong?

Ah, I thought this was about the EFLAGS state of new tasks which would
get into effect at switch_to(), which is well before we enable
interrupts in finish_lock_switch().

> However I've switched the order of my second patch anyway, so EFLAGS is
> reset to 0x0002 (interrupts disabled) on both 32- and 64-bit before the
> call to schedule_tail, since it does seem like the simpler option. I'll
> repost shortly. 

OK.
