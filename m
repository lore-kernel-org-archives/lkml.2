Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab2CGMxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:53:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:41536 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757715Ab2CGMxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:53:32 -0500
Message-Id: <aefc95$3e4jv1@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="115494881"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 6/9] drm/i915/intel_i2c: return -ENXIO for device NAK
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
In-Reply-To: <CAGS+omByuSWzV1Pa_ODugq9rrZ2DtgU_LPWDAfbrR_q_zuDvYQ@mail.gmail.com>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org> <1331121050-17857-7-git-send-email-djkurtz@chromium.org> <aefc95$3e4bn0@orsmga001.jf.intel.com> <CAGS+omByuSWzV1Pa_ODugq9rrZ2DtgU_LPWDAfbrR_q_zuDvYQ@mail.gmail.com>
Date: Wed, 07 Mar 2012 12:53:21 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012 20:41:03 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> On Wed, Mar 7, 2012 at 8:12 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Wed,  7 Mar 2012 19:50:47 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> >> Return -ENXIO if a device NAKs a transaction.
> >>
> >> Note: We should return -ETIMEDOUT, too if the transaction times out,
> >> however, that error path is currently handled by the 'bit-bang fallback'.
> >>
> >> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> >
> > Can you clarify what the rule is if an error is detected part-way
> > through a xfer?
> 
> A priceless comment from drivers/i2c/i2c-core::i2c_transfer...

Thanks, that is about as consistent as one expects with i2c. ;)
 
> This doesn't specify what to do if the transfer doesn't get an ACK
> during another phase of the transfer.
> However, it does say to send -ENXIO "if no ACK during address phase",
> which is a subset of the possible no-ACK conditions during a transfer.
>  Thus, I choose to return ENXIO in all no-ACK cases, to ensure we send
> it during the one case that is specified.

This (and a summary of the rest) deserves to be captured as a comment in
the code.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
