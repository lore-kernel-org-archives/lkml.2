Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0IFJ1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:27:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56548 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751007Ab0IFJ1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:27:36 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX193EER80pR3nBqSKg9M5K6y9z5FyMx2dxouYDbkny
	tVhuDt3GOT6pNc
From: Sven Joachim <svenjoac@gmx.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] i915
References: <89kc63$i063ms@fmsmga002.fm.intel.com>
Date: Mon, 06 Sep 2010 11:27:34 +0200
In-Reply-To: <89kc63$i063ms@fmsmga002.fm.intel.com> (Chris Wilson's message of
	"Mon, 06 Sep 2010 09:30:23 +0100")
Message-ID: <8739tnw7ax.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-06 10:30 +0200, Chris Wilson wrote:

> Hi Linus,
>
> in order to reduce the burden upon Eric and to try and feed patches
> upstream in a more timely manner I volunteered to take over maintaining
> the upstream i915 branches.
>
> This batch of fixes include the timing fixes for the fallout from the
> conversion of intel_wait_for_vblank() and the error checking for SDVO
> modesetting. It also includes a [double dose] of module unload oopsen
> fixes from Daniel Vetter, more work by Jesse on bringing eDP machines to
> life and some of my pending fixes from bugzilla.
>
> The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:
>
>   Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)
>
> are available in the git repository at:
>   git://anongit.freedesktop.org/~ickle/drm-intel drm-intel-fixes

Sadly, these still do not include a fix for the build failure¹ that
occurs if CONFIG_DEBUG_FS is not set:

,----
|   CC [M]  drivers/gpu/drm/i915/intel_overlay.o
| drivers/gpu/drm/i915/intel_overlay.c: In function 'intel_overlay_print_error_state':
| drivers/gpu/drm/i915/intel_overlay.c:1467: error: implicit declaration of function 'seq_printf'
| make[4]: *** [drivers/gpu/drm/i915/intel_overlay.o] Error 1
`----

Regards,
        Sven


¹ http://lists.freedesktop.org/archives/intel-gfx/2010-August/007822.html
