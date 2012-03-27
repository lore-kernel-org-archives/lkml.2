Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab2C0Ny5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:54:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:33915 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab2C0Ny4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:54:56 -0400
Date: Tue, 27 Mar 2012 15:54:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Beulich <JBeulich@suse.com>
cc: mingo@elte.hu, hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: hpet_disable() call sites
In-Reply-To: <4F71D9BE020000780007B268@nat28.tlf.novell.com>
Message-ID: <alpine.LFD.2.02.1203271552460.2542@ionos>
References: <4F719449020000780007B0CD@nat28.tlf.novell.com> <alpine.LFD.2.02.1203271457460.2542@ionos> <4F71D9BE020000780007B268@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Jan Beulich wrote:
> >>> On 27.03.12 at 14:58, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Tue, 27 Mar 2012, Jan Beulich wrote:
> >> Is there any reason why hpet_disable() should not also be called
> >> from (or some equivalent action be taken, perhaps including clearing
> >> certain bits in the individual counters' configuration registers, which
> >> are apparently - but perhaps wrongly - implied to be clear in e.g.
> >> hpet_set_mode(), in) hpet_enable()?
> > 
> > No, there is no particular reason why we don't clear those registers.
> 
> In that case I'll prepare a patch to do so. One related question is
> whether use of the HPET should be suppressed when any bit unknown
> to the kernel is found set, or whether unknown bits should also be
> cleared.

Hmm. Good question. We might at least add a printk to alert about it.

Thanks,

	tglx
