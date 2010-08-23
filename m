Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0HWIGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:06:54 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42634 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752816Ab0HWIGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:06:53 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19QOfFe9ipQlWNsudCOem8OmpvpmGvMo/VKsO2C7B
	9L0Y3jpZHtPD8q
From: Sven Joachim <svenjoac@gmx.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Eric Anholt <eric@anholt.net>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: 2.6.36-rc2 build failure: implicit declaration of function 'seq_printf'
Date: Mon, 23 Aug 2010 10:06:42 +0200
Message-ID: <87bp8tda7h.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 6ef3d4278034982c13df87c4a51e0445f762d316 causes a build failure
for me:

,----
|   CC [M]  drivers/gpu/drm/i915/intel_overlay.o
| drivers/gpu/drm/i915/intel_overlay.c: In function 'intel_overlay_print_error_state':
| drivers/gpu/drm/i915/intel_overlay.c:1467: error: implicit declaration of function 'seq_printf'
| make[4]: *** [drivers/gpu/drm/i915/intel_overlay.o] Error 1
`----

Adding a line with

#include <linux/seq_file.h>

to intel_overlay.c fixes this.  Looking at include/drm/*.h, I notice
that <linux/seq_file.h> is only #included if CONFIG_DEBUG_FS is set,
which is not the case in my configuration.

Sven
