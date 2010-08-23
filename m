Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0HXACa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:02:30 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:43603 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab0HXAC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:02:26 -0400
X-Greylist: delayed 1592 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2010 20:02:26 EDT
Date: Tue, 24 Aug 2010 00:35:51 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [REGRESSION, i915]: Periodic stalls with 2.6.36-rc2
Message-ID: <20100823233551.GA31920@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With 2.6.36-rc2 I see periodic stalls when running with a stock Ubuntu
10.04 userspace. These stalls were not present in 2.6.36-rc1 on an EeePC
900 with an i915.

Attempts to bisect the issue are not successful - most kernels in
between rc1 and rc2 just make the system come up with a black screen
which takes minutes between showing messages (rather than finishing in
two seconds). bc584c5107bfd97e2aa41c798e3b213bcdd4eae7 seems to be good
but 45d7f32c7a43cbb9592886d38190e379e2eb2226 is not.

Warnings like:

[   64.227046] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 31.
[   82.953011] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU idle, missed IRQ.

appear frequently in the dmesg and the stalls are most visible when
playing fullscreen video. The first warning message (Insufficient
FIFO...) is present in 2.6.36-rc1 but not 2.6.35.

One additional quirk is that a more recent X userspace
(xserver-xorg-video-intel
2:2.12.0+git20100810.19c48d3b-0ubuntu0sarvatt2~lucid, libdrm-intel1
2.4.21+git20100804.431f7f00-0ubuntu0sarvatt~lucid,
xorg 1:7.5+6ubuntu1) now has major tearing (when watching video) and
refresh (in general at least when using compiz) issues which were not
seen with 2.6.36-rc1.

-- 
Sitsofe | http://sucs.org/~sits/
