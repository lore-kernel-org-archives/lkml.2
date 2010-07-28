Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab0G1RCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:02:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48569 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730Ab0G1RCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:02:33 -0400
Subject: Re: [PATCH 31/31] memblock: Add memblock_find_in_range()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <4C4FD04B.5090503@zytor.com>
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>
	 <1279822864-17154-32-git-send-email-yinghai@kernel.org>
	 <1280295415.1970.245.camel@pasglop> <4C4FC95F.6040806@kernel.org>
	 <4C4FD04B.5090503@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 12:02:28 -0500
Message-ID: <1280336548.30808.489.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 23:38 -0700, H. Peter Anvin wrote:
> On 07/27/2010 11:08 PM, Yinghai Lu wrote:
> > 
> > for example: 
> > high/low allocation, from first kernel to kexec second kernel, always work fine except system with Qlogic card.
> > because Qlogic card is using main RAM as EFT etc for card's FW log trace. second kernel have not idea that those RAM
> >  is used by first kernel for that purpose. that the CARD still use that between two kernels.
> > second kernel could have crash it try to use those ram.
> > 
> 
> Uhm, no.  That's a bug in the Qlogic driver not shutting the card down
> cleanly.  Hacking around that in memory allocation order is braindamaged
> in the extreme.  kexec *cannot* be safe in any way if we don't shut down
> pending DMA, and what you describe above is DMA.

That's not the kexec for crash dump requirement as it was communicated
to us.  We were specifically told that the shutdown routines *may* not
be called before booting the kexec kernel and thus we have to take
action to stop the DMA engines in the init routines so the kexec kernel
can halt all in-progress DMA as it boots.  This implies that kexec must
be able to cope with in-progress DMA.

James


