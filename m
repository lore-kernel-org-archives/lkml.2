Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1LIXxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:53:16 -0500
Received: from home.keithp.com ([63.227.221.253]:59599 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab1LIXxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:53:14 -0500
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: drm/i915: Enabling RC6 where possible
Date: Fri,  9 Dec 2011 15:53:47 -0800
Message-Id: <1323474829-2501-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321684889-18691-1-git-send-email-keithp@keithp.com>
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
References: <1322526298-2746-1-git-send-email-eugeni.dodonov@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here's a "final" patch set to enable RC6 where possible on SNB and IVB
machines.

The first patch creates a new variable, intel_iommu_enabled, that is
exported by the intel iommu code and set when that code has
successfully initialized itself. The old plan of using no_iommu ||
dmar_disabled would work -- those variables are set only by kernel
parameters and don't reflect what the system is actually doing about
virtualization.


The second patch uses that value on SNB to tell whether RC6 can be
enabled by default. On IVB, RC6 is always enabled.


Of course, in all cases, you can override the RC6 setting with the
i915 module parameter.

For those of you who have experienced the delights of RC6 crashing
your machines, please test as this will be heading to 3.2 unless you
find something wrong with it.

-keith
