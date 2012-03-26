Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab2CZTFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:05:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47028 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2CZTFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:05:48 -0400
Date: Mon, 26 Mar 2012 21:06:30 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 03/11 v3] drm/i915/intel_i2c: use i2c pre/post_xfer
 functions to setup gpio xfers
Message-ID: <20120326190630.GB4014@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
 <1332772010-19619-4-git-send-email-djkurtz@chromium.org>
 <20120326144919.GP4014@phenom.ffwll.local>
 <CAGS+omAB-ngre8wX9Aq1vDUjYjcxsOeT1BtB7tdJSDAB6MLbDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGS+omAB-ngre8wX9Aq1vDUjYjcxsOeT1BtB7tdJSDAB6MLbDw@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 01:58:47AM +0800, Daniel Kurtz wrote:
> On Mon, Mar 26, 2012 at 10:49 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > On Mon, Mar 26, 2012 at 10:26:42PM +0800, Daniel Kurtz wrote:
> >> Instead of rolling our own custom quirk_xfer function, use the bit_algo
> >> pre_xfer and post_xfer functions to setup and teardown bit-banged
> >> i2c transactions.
> >>
> >> gmbus_xfer uses .force_bit to determine which i2c_algorithm to use,
> >> either i2c_bit_algo.master_xfer or its own.  So, Similarly, let gmbus_func
> >> use .force_bit to determine which i2c functionalities are available,
> >> either i2c_bit_algo.functionality, or its own.
> >
> > Please split this part of the patch into a separate patch. Furthermore I'm
> > not sure what this should buy us, given that we might magically changes
> > our i2c feature set once with gone to fallback mode. Can you please
> > elaborate why we need this?
> 
> An i2c adapter's functionality is provided by its algorithm.
> Since these gmbus adapters can [for now] change their algorithm at
> runtime, I thought the functionality returned should match the
> currently selected algorithm at any given moment.
> 
> Arguably, the adapter actually sort of provides the union of the two
> functionalities since if a particular transfer fails using gmbus, it
> gets retried using bit-banged.  But then again, this is a one-shot
> permanent switch, so perhaps we should return the union of the
> functionalities if force_bit == 0, and then only the bit-algo
> functionality after the switch?

In that case I guess we can drop it - current edid reading seems to work
and without a good reason I'd like not to play clever tricks because it
doesn't seem to be worth it.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
