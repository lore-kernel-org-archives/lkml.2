Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0GGXtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 19:49:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab0GGXtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 19:49:02 -0400
Date: Thu, 8 Jul 2010 09:48:51 +1000
From: Neil Brown <neilb@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Takeo Tung <kernel@takeo.idv.tw>, Michal Marek <mmarek@suse.cz>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       sfr@canb.auug.org.au
Subject: Re: [PATCH] struct io panic on raid1 - Re: block: unify flags for
 struct bio and struct request will kernel panic
Message-ID: <20100708094851.6dc6199d@notabene.brown>
In-Reply-To: <20100707231732.GA30007@lst.de>
References: <10E8B8D94205471F942B06D2A007832D@TAKEOW7NB1>
	<4C129778.7040409@suse.cz>
	<F8C0125B8F424A279E9679EAC24AC983@TAKEOW7NB1>
	<20100612094937.GA12455@lst.de>
	<F2CA952B7B5A41259C5F950CA3454C3A@TAKEOW7NB1>
	<1AEF19B8648844C983F583EEBE9C46F4@TAKEOW7NB1>
	<20100707231732.GA30007@lst.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010 01:17:32 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Jul 08, 2010 at 07:05:39AM +0800, Takeo Tung wrote:
> > Dear Christoph,
> > 
> > I was check the patch again. I found the panic status haapen on Soft RAID 
> > 1. I review it. found some define using bool, so some like ( x & REQ_SYNC) 
> > only 0 or 1.
> > so if bi_rw = rw | sync will bi_rw = rw | 0 or rw | 1. not rw | ( 1 << 
> > __REQ_SYNC).
> > 
> > So I write a patch is fix it. seems normal now. could you review the patch 
> > or any comment?
> 
> The patch looks correct to me, although your mailer mangled the
> whitespace badly.  If Neil wants to keep the flag as bool we could
> also add a !! around the bit flag checks.

I think it is best to make them "unsigned long" holding the actual but.
They were only made 'bool' because that is was bio_rw_flagged() returned.
Converting to a bool then back to a bit-flag is unnecessary.

Thanks,
NeilBrown
