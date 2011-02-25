Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab1BYXFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 18:05:48 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:58850 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932869Ab1BYXFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 18:05:47 -0500
X-Spam-ASN: 
X-Spam-Spammy: 0.965-+--H*r:mail.ffwll.ch, 0.895-+--wish,
	0.874-+--H*F:D*ffwll.ch
X-Spam-Hammy: 0.000-+--HCc:D*freedesktop.org,
	0.000-+--HCc:D*lists.freedesktop.org, 0.000-+--HCc:U*intel-gfx
Date: Sat, 26 Feb 2011 00:05:27 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jan Niehusmann <jan@gondor.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] intel-gtt: fix memory corruption with
 GM965 and >4GB RAM
Message-ID: <20110225230527.GC3601@viiv.ffwll.ch>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jan Niehusmann <jan@gondor.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20110223233022.GA3439@x61s.reliablesolutions.de>
 <20110225123056.GA3759@x61s.reliablesolutions.de>
 <b9dded$i2gkhr@orsmga002.jf.intel.com>
 <20110225211646.GA6837@x61s.reliablesolutions.de>
 <b9dded$i2hik6@orsmga002.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9dded$i2hik6@orsmga002.jf.intel.com>
X-Operating-System: Linux viiv 2.6.38-rc5-00035-g3077686 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 10:18:16PM +0000, Chris Wilson wrote:
> So, I'm happy to use your patch to workaround the known erratum. I just
> wish I had an explanation as to what is actually causing the corruption.
> What I want to make sure is that we don't paper over a real bug by
> thinking it is yet another silicon issue.

Actually, on style points I prefer your patch: The hw status page is
allocated with drm_pci_alloc which calls dma_alloc_coherent, so setting
the coherent mask is sufficient. The dma mask set in the gtt is
essentially useless, because we call get_user_pages on everything anyway
(in gem - iirc agp uses it). I just think it's confusing to limit the
general dma mask and continue to happily map pages above 4G.

Cheers, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
