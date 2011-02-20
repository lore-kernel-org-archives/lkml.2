Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1BTJUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 04:20:35 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:36019 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1BTJUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 04:20:32 -0500
X-Spam-ASN: 
X-Spam-Spammy: 0.965-+--H*r:mail.ffwll.ch, 0.874-+--H*F:D*ffwll.ch
X-Spam-Hammy: 0.000-+--H*Ad:U*dri-devel, 0.000-+--HCc:D*freedesktop.org,
	0.000-+--HCc:D*lists.freedesktop.org
Date: Sun, 20 Feb 2011 10:20:13 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Indan Zupancic <indan@nul.nu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [BUG] drm/i915 Screen corruption introduced by
 a00b10c360b35d6431a94cb
Message-ID: <20110220092012.GA3514@viiv.ffwll.ch>
Mail-Followup-To: Indan Zupancic <indan@nul.nu>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
 <20110219182511.GA3977@viiv.ffwll.ch>
 <92f5b87a3559ed7f1b7c46b7497c1ad5.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92f5b87a3559ed7f1b7c46b7497c1ad5.squirrel@webmail.greenhost.nl>
X-Operating-System: Linux viiv 2.6.38-rc5-00035-g3077686 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 20, 2011 at 03:20:15AM +0100, Indan Zupancic wrote:
> Sorry, I plainly forgot to mention that. I'm on my Thinkpad X40 with gen 2
> hardware, 855GM.

Ah, craptastic i855gm. Is this with the HIC poke patch?

<snip>

> > I've created two quick patches to check a few theories, please test them
> > (both patches independently and both together). Patches attached.
> 
> Tried with both applied, doesn't change anything.

Well, these two patches completely undo the patch by Chris Wilson (and
I've re-reviewed it to check whether there are any other hidden bugs in
it). I suspect that your bisect went wrong because the range
a00b10c360b35d6431a94cb..5e78330126e23e00950 is known to be broken on your
hw. Could you recheck these two endpoints to confirm that breakage was
introduce in that range? If so, could you rebase this range and squash the
three patches by me you've mentioned in the original report into the patch
by Chris and re-run git bisect on this new branch?

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
