Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab2C3H4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 03:56:40 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:56116 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759344Ab2C3H4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 03:56:32 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] video/console: Clip the right margin clear to the visible region
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4F750970.6040801@gmx.de>
References: <1332793022-29292-1-git-send-email-chris@chris-wilson.co.uk> <4F750970.6040801@gmx.de>
Date: Fri, 30 Mar 2012 08:56:10 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1333094186_153174@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 01:16:32 +0000, Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> Hi Chris,
> 
> On 03/26/2012 08:17 PM, Chris Wilson wrote:
> > For some unknown reason, yres_virtual was 2x larger the the size specified
> > by i915 and so when blit_clear_margins() tried to clear the full virtual
> > right-hand margin it tried to write far beyond the end of the buffer.
> > 
> > This limits the clear to only the visible portion of the right-hand
> > margin, similar to how the bottom margin is treated.
> > 
> > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=38138
> 
> as you also found the root of the problem and posted a patch to fix i915
> (or rather all KMS-based framebuffers) by validating the virtual
> resolution in check var, I don't see any reason to apply this one. I'm
> not sure about it, but changing the behaviour of this function might
> cause some undesired changes in user experience and as there is no
> problem with this code as is, I'd prefer to not change it.

Ok, thanks for the review. Preventing userspace from programming an
unhandled value of yres_virtual is definitely the way forward.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
