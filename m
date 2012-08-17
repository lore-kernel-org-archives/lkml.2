Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab2HQQnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:43:35 -0400
Received: from mga12.intel.com ([143.182.124.36]:10243 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758493Ab2HQQn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:43:27 -0400
MIME-Version: 1.0
In-Reply-To: <1344918891-6283-7-git-send-email-keithp@keithp.com>
References: <1344918891-6283-1-git-send-email-keithp@keithp.com>
	<1344918891-6283-7-git-send-email-keithp@keithp.com>
Date: Fri, 17 Aug 2012 17:43:22 +0100
Message-ID: <CAPX-8+_bZNyXL0b8nBkN97sj-KnT_eZXZ-5Hp5R6P-L-D-QAKg@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 6/7] drm/i915: Disable FDI RX before FDI TX
From: "Lespiau, Damien" <damien.lespiau@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 5:34 AM, Keith Packard <keithp@keithp.com> wrote:
> Doesn't make sense to disable in the other order.
>
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_display.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

I can't see anything in the docs about an order requirement for those.
Not sure why the other way does not make sense. Somehow disabling TX
before RX makes some sense to me (TX enabled without a ready RX looks
weird?, no data should flow as the pipe is shutdown at that point
anyway). Maybe it just does not matter?

Another detail is that disabling the PLLs seem to have an order in the
disabling sequence, TX, then RX.

I.  Disable CPU FDI Transmitter PLL
II. Disable PCH FDI Receiver PLL

-- 
Damien
