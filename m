Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2LDUmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:42:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46943 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab2LDUmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:42:01 -0500
From: Lekensteyn <lekensteyn@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Heinz Diehl <htd@fritha.org>, Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Heinz Diehl <htd@fancy-poultry.org>
Subject: Re: i915 freakout with latest 3.7 git
Date: Tue, 04 Dec 2012 21:41:56 +0100
Message-ID: <1498848.rM1KKK5er8@al>
User-Agent: KMail/4.9.3 (Linux/3.7.0-1-custom; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121204123522.GA32419@fritha.org>
References: <20121203173951.GA25384@fancy-poultry.org> <CAKMK7uEGTWgPO-wf7aNLC+y9zLYPyy6f_djn6D-Gx-n6bFqcJA@mail.gmail.com> <20121204123522.GA32419@fritha.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2012 13:35:22 Heinz Diehl wrote:
> Btw: which kernel is known to be the "last good one"?
As mentioned in the linked bug [1], I bisected it to:

commit 504c7267a1e84b157cbd7e9c1b805e1bc0c2c846
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Aug 23 13:12:52 2012 +0100

    drm/i915: Use cpu relocations if the object is in the GTT but not mappable

> > (you need to disable rc6 on ilk to not hit another issue which seems much
> > easier to hit)
> 
> Ilk? If this stands for "Ironlake": I'm on Sandybridge.
> 
> > ...
> 
> Bisecting will be a pain without being able to reproduce
> the hang reliably.
> 
> > Atm we're trying to come up with ways to dump more debug
> > information, >but with no clue whatsoever what's going on that's
> > slow-going.
> Is there anything at the moment I can do to help you to get a grip on
> this problem? My machine is a Core i5-420M laptop with 4GB RAM (Asus
> U45-JC).
i5-420M is not SB, but ILK. i5-2xxx is SB. I have a i5-460M myself. 
i915.i915_enable_rc6=0 worked for me, if it does not work for you, then you 
probably hit another bug.

Peter


 [1]: https://bugs.freedesktop.org/show_bug.cgi?id=55984#c9
