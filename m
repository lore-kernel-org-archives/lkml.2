Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0L2Tk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 14:40:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656Ab0L2Tk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 14:40:26 -0500
MIME-Version: 1.0
In-Reply-To: <20101229102127.06c0e505.randy.dunlap@oracle.com>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com> <20101229102127.06c0e505.randy.dunlap@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Dec 2010 11:40:04 -0800
Message-ID: <AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 10:21 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> The only significant difference that I can see in the kernel message log
> is this:

Hmm. I suspect that difference should have gone away with commit
92971021c6328 (Revert "drm: Don't try and disable an encoder that was
never enabled"), but clearly that didn't fix your blank screen.

Does reverting commit 448f53a1ede54eb854d036abf54573281412d650
("drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks") fix it for
you? It does for some people..

Chris - why did that lvds_ssc_freq thing suddenly start mattering? Can
we please just disable spread-spectrum entirely? Or perhaps only if we
notice that it was enabled already? Or something?

                         Linus
