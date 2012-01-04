Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab2ADVhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 16:37:11 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:36779 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2ADVg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 16:36:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        j.glisse@gmail.com, bskeggs@redhat.com, thellstrom@vmware.co,
        airlied@linux.ie
Subject: [PATCH] fixes to drm-next - ttm code (v2) found when using nouveau.
Date: Wed,  4 Jan 2012 16:35:13 -0500
Message-Id: <1325712916-27962-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F04C674.0023,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I was debugging some DMA API accounting error (which were found to be
with the DMA API debug code), I encountered a couple of issues:
 1). Doing "unbind" on the PCI device would crash the kernel _only_ with the 
     nouveau driver. The readon worked fine. This was due to:
     "drm/ttm: callback move_notify any time bo.." and reverting that fixed it.

 2). Extreme slowness when moving the cursor madly around. This was due to the
     nouveau driver calling the unpopulate (now that unbind + unpopulate are squashed)
     quite a lot (this is using Gnome Shell - I think GNOME2 did not have those issues
     but I can't recall). Radeon did not have these issues.

Anyhow these patches fix the 50% perf regression I saw on nouveau and also some minor bugs
that I noticed. Please apply.

Thomas asked me to also do some perf results on AGP hardware (both nouveau and radeon)
and I am going to do that this week - any pointers of what is a good game/OpenGL
application to run a time-based benchmark?

