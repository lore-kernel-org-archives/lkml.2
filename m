Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab1CJKgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:36:19 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:57563 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1CJKgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:36:18 -0500
Message-ID: <2e9ca0040729649ed989a16a07bb2c49.squirrel@webmail.greenhost.nl>
In-Reply-To: <8b77a7a0de898635c8b25e7612907deb.squirrel@www.ffwll.ch>
References: <af572f9c6c75d54f1f81e51f508358dd.squirrel@webmail.greenhost.nl>
    <1298395549-4064-1-git-send-email-daniel.vetter@ffwll.ch>
    <ed85db84d2d5ea460898d78e1179c6ca.squirrel@webmail.greenhost.nl>
    <25dfe766fbe767e249ef95d1fda0094c.squirrel@www.ffwll.ch>
    <0378a20bb9cfafee46c89461fa2dd4d6.squirrel@webmail.greenhost.nl>
    <8b77a7a0de898635c8b25e7612907deb.squirrel@www.ffwll.ch>
Date: Thu, 10 Mar 2011 11:36:15 +0100 (CET)
Subject: Re: [PATCH] drm/i915: fix corruptions on i8xx due to relaxed 
     fencing
From: "Indan Zupancic" <indan@nul.nu>
To: "Daniel Vetter" <daniel@ffwll.ch>
Cc: "Daniel Vetter" <daniel@ffwll.ch>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 258bd43c1b7c380ff6f1b27dffaa1ebc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, March 10, 2011 08:52, Daniel Vetter wrote:
> Am Do, 10.03.2011, 06:06 schrieb Indan Zupancic:
>> This isn't in rc8, can someone make sure it gets into 2.6.38-rc9/2.6.38?
>
> The patch unfortunately broke gen4+ (more precisely: the unwritten abi
> guarantee that userspace can tile buffers that don't have a complete last
> tile row, as long as it promises not to touch it). Hence it got reverted.
> It was just a enforcement check to prevent broken userspace from fooling
> itself. The proper fix is to upgrade your userspace (libdrm +
> xf86-video-intel).
>
> [Aside: This only happens if you have new enough userspace that supports
> relaxed tiling. Old userspace and new kernels are _not_ broken.]

Yes, I noticed it got reverted when digging into git log, but the
commit message only said it broke gen4+, not how gen2 should be
unbroken after the revert.

Which versions fix this, just for reference?

I got libdrm 2.4.23 and xf86-video-intel 2.14.0.

(As a side note, do you have version checking on the kernel side?
If so, you could return 0 for the relaxed fencing feature check
if the driver is the wrong version.)

To keep things manageable I either upgrade the kernel, or userspace,
but never both at once. It seems that that doesn't work with graphics.

Thanks,

Indan


