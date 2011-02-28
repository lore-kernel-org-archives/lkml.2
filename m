Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1B1T6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:58:12 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:35638 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab1B1T6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:58:10 -0500
X-Spam-ASN: 
X-Spam-Spammy: 0.965-+--H*r:mail.ffwll.ch, 0.874-+--H*F:D*ffwll.ch,
	0.867-+--our
X-Spam-Hammy: 0.000-+--HTo:D*chris-wilson.co.uk, 0.000-+--HTo:U*chris,
	0.000-+--workaround
Date: Mon, 28 Feb 2011 20:57:50 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>, Jan Niehusmann <jan@gondor.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] intel-gtt: fix memory corruption with
 GM965 and >4GB RAM
Message-ID: <20110228195749.GA3597@viiv.ffwll.ch>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jan Niehusmann <jan@gondor.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20110223233022.GA3439@x61s.reliablesolutions.de>
 <20110225123056.GA3759@x61s.reliablesolutions.de>
 <b9dded$i2gkhr@orsmga002.jf.intel.com>
 <20110225211646.GA6837@x61s.reliablesolutions.de>
 <b9dded$i2hik6@orsmga002.jf.intel.com>
 <20110225230527.GC3601@viiv.ffwll.ch>
 <20110228064635.GE428@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110228064635.GE428@zhen-devel.sh.intel.com>
X-Operating-System: Linux viiv 2.6.38-rc5-00035-g3077686 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 02:46:35PM +0800, Zhenyu Wang wrote:
> > Actually, on style points I prefer your patch: The hw status page is
> > allocated with drm_pci_alloc which calls dma_alloc_coherent, so setting
> > the coherent mask is sufficient. The dma mask set in the gtt is
> > essentially useless, because we call get_user_pages on everything anyway
> > (in gem - iirc agp uses it). I just think it's confusing to limit the
> > general dma mask and continue to happily map pages above 4G.
> > 
> 
> Think about IOMMU engine, we need to set dma_mask properly for
> returned dma mapping address be limited in max range that can be
> handled in GTT entry. 

If I understand it correctly, this is just about broadwater/crestline,
i.e. the original i965 series. Only the later eaglelake/cantiga (gm45 in
our codebase) was shipped with an iommu attached. So no problem there.
Anyway, my comment was just style nitpick, essentially to keep in line
with the existing  work-around for broken overlay reg files on gen2.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
