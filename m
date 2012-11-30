Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab2K3Iin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:38:43 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4342 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab2K3Iil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:38:41 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <50B87082.3020604@broadcom.com>
Date: Fri, 30 Nov 2012 09:38:26 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0
 Thunderbird/17.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        backports@vger.kernel.org, alexander.stein@systec-electronic.com,
        brudley@broadcom.com, rvossen@broadcom.com, frankyl@broadcom.com,
        kanyan@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, kyungmin.park@samsung.com,
        s.nawrocki@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/6] drivers: convert struct spinlock to spinlock_t
References: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
X-Enigmail-Version: 1.4.6
X-WSS-ID: 7CA6B00839W2303749-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 09:45 PM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> Turns out a few drivers have strayed away from using the
> spinlock_t typedef and decided to use struct spinlock
> directly. This series converts these drivers to use
> spinlock_t. Each change has been compile tested with
> allmodconfig and sparse checked. Driver developers
> may want to look at the compile error output / sparse
> error report supplied in each commit log, in particular
> brcmfmac and i915, there are quite a few things that
> are not related to this change that the developers
> can clean up / fix.

So what is the rationale here. During mainlining our drivers we had to
remove all uses of 'typedef struct foo foo_t;'. The Linux CodingStyle
(chapter 5 Typedefs) is spending a number of lines explaining why.

So is spinlock_t an exception to this rule simply because the kernel
uses spinlock_t all over the place. Using Greg's favorite final email
remark:

Confused.

Gr. AvS

> Luis R. Rodriguez (6):
>   ux500: convert struct spinlock to spinlock_t
>   i915: convert struct spinlock to spinlock_t
>   s5p-fimc: convert struct spinlock to spinlock_t
>   s5p-jpeg: convert struct spinlock to spinlock_t
>   brcmfmac: convert struct spinlock to spinlock_t
>   ie6xx_wdt: convert struct spinlock to spinlock_t
> 
>  drivers/crypto/ux500/cryp/cryp.h               |    4 ++--
>  drivers/crypto/ux500/hash/hash_alg.h           |    4 ++--
>  drivers/gpu/drm/i915/i915_drv.h                |    4 ++--
>  drivers/media/platform/s5p-fimc/mipi-csis.c    |    2 +-
>  drivers/media/platform/s5p-jpeg/jpeg-core.h    |    2 +-
>  drivers/net/wireless/brcm80211/brcmfmac/fweh.h |    2 +-
>  drivers/watchdog/ie6xx_wdt.c                   |    2 +-
>  7 files changed, 10 insertions(+), 10 deletions(-)
> 


