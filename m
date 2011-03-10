Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab1CJIBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:01:11 -0500
Received: from cable-static-216-94.intergga.ch ([87.102.216.94]:33373 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab1CJIBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:01:08 -0500
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Mar 2011 03:01:07 EST
X-Spam-ASN: 
X-Spam-Spammy: 0.965-+--H*r:mail.ffwll.ch, 0.941-+--H*Ad:D*ffwll.ch,
	0.941-+--H*Ad:U*daniel.vetter
X-Spam-Hammy: 0.000-+--H*Ad:U*dri-devel, 0.000-+--HCc:D*freedesktop.org,
	0.000-+--HCc:D*lists.freedesktop.org
Message-ID: <8b77a7a0de898635c8b25e7612907deb.squirrel@www.ffwll.ch>
In-Reply-To: <0378a20bb9cfafee46c89461fa2dd4d6.squirrel@webmail.greenhost.nl>
References: <af572f9c6c75d54f1f81e51f508358dd.squirrel@webmail.greenhost.nl>
    <1298395549-4064-1-git-send-email-daniel.vetter@ffwll.ch>
    <ed85db84d2d5ea460898d78e1179c6ca.squirrel@webmail.greenhost.nl>
    <25dfe766fbe767e249ef95d1fda0094c.squirrel@www.ffwll.ch>
    <0378a20bb9cfafee46c89461fa2dd4d6.squirrel@webmail.greenhost.nl>
Date: Thu, 10 Mar 2011 08:52:34 +0100
Subject: Re: [PATCH] drm/i915: fix corruptions on i8xx due to relaxed     
 fencing
From: "Daniel Vetter" <daniel@ffwll.ch>
To: "Indan Zupancic" <indan@nul.nu>
Cc: "Daniel Vetter" <daniel@ffwll.ch>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Do, 10.03.2011, 06:06 schrieb Indan Zupancic:
> This isn't in rc8, can someone make sure it gets into 2.6.38-rc9/2.6.38?

The patch unfortunately broke gen4+ (more precisely: the unwritten abi
guarantee that userspace can tile buffers that don't have a complete last
tile row, as long as it promises not to touch it). Hence it got reverted.
It was just a enforcement check to prevent broken userspace from fooling
itself. The proper fix is to upgrade your userspace (libdrm +
xf86-video-intel).

[Aside: This only happens if you have new enough userspace that supports
relaxed tiling. Old userspace and new kernels are _not_ broken.]

Cheers, Daniel

