Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0HWX4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 19:56:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:62716 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab0HWXz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 19:55:59 -0400
Message-Id: <8u3s94$gak45q@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,260,1280732400"; 
   d="scan'208";a="548016314"
Date: Tue, 24 Aug 2010 00:55:54 +0100
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [now bisected] i915: 2.6.36-rc2 hoses my Intel display
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Eric Anholt <eric@anholt.net>
References: <20100823110145.08eb72fd@bike.lwn.net> <20100823151708.6b242599@bike.lwn.net> <8u3s8d$jcc0rr@orsmga001.jf.intel.com> <20100823173225.2bda6f78@bike.lwn.net> <8u3s94$gak083@orsmga002.jf.intel.com> <20100823174641.4ba58bfe@bike.lwn.net>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100823174641.4ba58bfe@bike.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 17:46:41 -0600, Jonathan Corbet <corbet@lwn.net> wrote:
> On Tue, 24 Aug 2010 00:37:52 +0100
> Chris Wilson <chris@chris-wilson.co.uk> wrote:
> 
> > drm.debug=0x4 should print the right information for this bug.
> 
> That doesn't seem to give me any output at all.
> 
> One thing I noticed, though, is that I occasionally get something like:
> 
> Aug 23 17:43:14 bike kernel: [  142.920185] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 51, available = 28.
> 
> They seem to come in threes, for whatever that's worth.

In threes. Hmm, one for primary, cursor and self-refresh. drm.debug=0xe
would be interesting to see what the pixel clock is.

Can you grab one before the bad commit and one after? If there is a change
that may help pin-point the mistake. Or indicate further problems...

-- 
Chris Wilson, Intel Open Source Technology Centre
