Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2LKPI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:08:29 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52173 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab2LKPI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:08:28 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <87vcc8vkgn.fsf@redhat.com>
References: <87vcc8vkgn.fsf@redhat.com>
Date: Tue, 11 Dec 2012 16:08:26 +0100
Message-ID: <CAKMK7uHQFsrXX3FKoVA_AiA1iwo_-NRf_CqaqWXy9rNUg+tonQ@mail.gmail.com>
Subject: Re: WARNING: at drivers/gpu/drm/i915/i915_gem.c:3437 i915_gem_object_pin+0x151/0x1a0()
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Nikola Pajkovsky <npajkovs@redhat.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 1:31 PM, Nikola Pajkovsky <npajkovs@redhat.com> wrote:
> looks like we still have some oops in i915. i915 maintainers do you have
> any ideas what's going on? I will try to trigger that oops later today
> and provide more information.

The infamous pin leak. Should be fixed with

commit b4a98e57fc27854b5938fc8b08b68e5e68b91e1f
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Nov 1 09:26:26 2012 +0000

    drm/i915: Flush outstanding unpin tasks before pageflipping

available from the drm-next (or linux-next) trees. If it holds up once
merged, we'll backport it.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
