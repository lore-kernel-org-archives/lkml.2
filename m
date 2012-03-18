Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab2CRSSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 14:18:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42493 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab2CRSSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 14:18:43 -0400
Date: Sun, 18 Mar 2012 19:19:25 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH 5/9] drm/i915/intel_i2c: add locking around i2c algorithm
 accesses
Message-ID: <20120318181925.GG4286@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Yufeng Shen <miletus@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Sameer Nanda <snanda@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
 <1331121050-17857-6-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331121050-17857-6-git-send-email-djkurtz@chromium.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 07:50:46PM +0800, Daniel Kurtz wrote:
> The i915 has multiple i2c adapters.  However, they all share a single
> single set of i2c control registers (algorithm).  Thus, different threads
> trying to access different adapters could interfere with each other.
> 
> Note: different threads trying to access the same channel is already
> handled in the i2c-core using the i2c adapter lock.
> 
> This patch adds a mutex to serialize access to the gmbus_xfer routine.
> Note: the same mutex serializes both bit banged and native xfers.
> 
> Signed-off-by: Yufeng Shen <miletus@chromium.org>
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

This is already fixed in

commit 8a8ed1f5143b3df312e436ab15290e4a7ca6a559
Author: Yufeng Shen <miletus@chromium.org>
Date:   Mon Feb 13 17:36:54 2012 -0500

    drm/i915: Fix race condition in accessing GMBUS

There are also a few gmbus changes already queued up in my -next tree at 

http://cgit.freedesktop.org/~danvet/drm-intel/log/?h=drm-intel-next-queued

Please rebase your patch series on top of that (with Chris' suggestion
incorporated).

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
