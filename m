Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab1ERIES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 04:04:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:50358 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1ERIEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 04:04:15 -0400
Message-Id: <e0d58a$78jc@orsmga002.jf.intel.com>
X-ExtLoop1: 1
Date: Wed, 18 May 2011 09:04:11 +0100
To: Keith Packard <keithp@keithp.com>, Mihai Moldovan <ionic@ionic.de>
Subject: Re: [PATCH] drm/i915/sdvo: Reorder i2c initialisation before ddc proxy
Cc: linux-kernel@vger.kernel.org
References: <4DD2648C.6020309@ionic.de> <1305637430-16026-1-git-send-email-chris@chris-wilson.co.uk> <yunei3wssyb.fsf@aiko.keithp.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <yunei3wssyb.fsf@aiko.keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011 18:22:52 -0700, Keith Packard <keithp@keithp.com> wrote:
> On Tue, 17 May 2011 14:03:50 +0100, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > The ddc proxy depends upon the underlying i2c bus being selected. Under
> > certain configurations, the i2c-adapter functionality is queried during
> > initialisation and so may trigger an OOPS during boot. Hence, we need to
> > reorder the initialisation of the ddc proxy until after we hook up the i2c
> > adapter for the SDVO device.
> 
> I'd love more explanation here about how this code ever worked -- what
> are these 'certain configurations' of which you speak?

The condition under which it fails is when the i2c_add_adapter calls into
i2c_detect which will attempt to probe all valid addresses on the adapter
iff there is a pre-existing i2c_driver with the same class as the freshly
added i2c_adapter.

So it appears to depend upon having compiled in (or loaded such a module
before i915.ko) an i2c-driver that likes to futz over the i2c_adapters
claiming DDC support.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
