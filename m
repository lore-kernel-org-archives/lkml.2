Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0C2Q5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:57:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:21578 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab0C2Q5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,329,1267430400"; 
   d="scan'208";a="259896168"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: lots of "bridge window ... (disabled)" messages
Date: Mon, 29 Mar 2010 09:57:16 -0700
Message-Id: <4bb0dbec213331313b@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

I just booted Linus latest git tree on my Tukwila system. I'm
seeing a lot of bridge windows marked as disabled. Here's the
start of a diff of dmesg output comparing a kernel from last
week to today's kernel (git 01e7770 vs. b72c409):

< pci 0000:00:01.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
---
> pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
222,224c222,224
< pci 0000:00:03.0:   bridge window [io  f000 - 0000] reg reading
< pci 0000:00:03.0:   bridge window [mem 0xfff00000 - 0x000fffff] reg reading
< pci 0000:00:03.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
---
> pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
> pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
> pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
233c233
< pci 0000:00:05.0:   bridge window [mem 0xfff00000 - 000fffff pref] reg reading
---
> pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)

   ... many more such diffs.

This is the same system that you helped out with a couple of months
ago that had some issues in _CRS tables with ranges marked as
"consumer".  The BIOS team fixed the one range that was needed
to allow access to my EHCI - but they didn't touch anything else.

Are these new checks related to the same sort of issues in _CRS?
Or is this some other stuff?  I don't appear to have lost access
to any devices in today's kernel.

-Tony
