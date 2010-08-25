Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab0HYINq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:13:46 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:35421 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab0HYINo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:13:44 -0400
Date: Wed, 25 Aug 2010 09:13:36 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] drm/i915: fix vblank wait test condition
Message-ID: <20100825081336.GA30504@sucs.org>
References: <20100824113116.249c13b4@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824113116.249c13b4@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 11:31:16AM -0700, Jesse Barnes wrote:
> When converting this to the new wait_for macro I inverted the wait
> condition, which causes all sorts of problems.  So correct it to fix
> several failures caused by the bad wait (flickering, bad output
> detection, tearing, etc.).

Further testing has shown this fixed one set of cases where strange
behaviour happened on my EeePC but there are other triggers. I've found
the following:

With this patch booting without a battery in the machine will lead to a
stable system without lots of errors appearing in dmesg (just one
"Insufficient FIFO" at boot). Doing "watch --differences=cumulative
xrandr" always shows the same outputs. VT switching occasionally causes
the occasional "*ERROR* vblank wait timed out" message. However doing a
suspend/resume brings back all the problems, dmesg starts filling up
with FIFO errors and xrandr starts reporting different outputs every
time it is called.  Additionally, booting with a battery inside the
machine at boot will always lead to the quirky behaviour too.

-- 
Sitsofe | http://sucs.org/~sits/
