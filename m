Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab1DOPqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:46:07 -0400
Received: from 8bytes.org ([88.198.83.132]:49347 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab1DOPqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:46:06 -0400
Date: Fri, 15 Apr 2011 17:46:04 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        alexandre.f.demers@gmail.com
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110415154604.GN18463@8bytes.org>
References: <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org> <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com> <4DA6145D.9070703@kernel.org> <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com> <4DA655E7.3000904@zytor.com> <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com> <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com> <20110415131152.GJ18463@8bytes.org> <20110415131650.GB18660@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415131650.GB18660@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 03:16:50PM +0200, Ingo Molnar wrote:
> Ok, but how did the allocation changes start triggering this error in 
> v2.6.39-rc1? There must still be some layout specific thing here, right?
> Do we understand the details of that as well?

Well, thinking again about this, the GPU likely generated this DMA
request before too (which has an address in the range configured for the
GTT on the card), but nobody noticed because they just hit main memory.
And with the allocation changes in 39-rc1 the GART aperture started to
be on the same address as the GTT (in their respective address spaces)
so that the DMA request hit the GART. This caused the MCE and the
sync-flood.
The open question is why the GPU generates a DMA request with an address
that is configured as the GTT base (+1 page) on the card.

	Joerg

