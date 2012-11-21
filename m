Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2KUH2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:28:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48043 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2KUH2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:28:23 -0500
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DJ Johnston <dj.johnston@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v2 0/2] random: Account for entropy loss due to overwrites
Date: Tue, 20 Nov 2012 23:27:46 -0800
Message-Id: <1353482868-8064-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 20 Nov 2012 23:28:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

When we write entropy into a non-empty pool, we currently don't
account at all for the fact that we will probabilistically overwrite
some of the entropy in that pool.  This means that unless the pool is
fully empty, we are currently *guaranteed* to overestimate the amount
of entropy in the pool!

This version of the patchset avoids manually duplicating information
by using a macro.  This removes *all* dynamic computation of derived
pool information and replaces them with static information: on just
about every architecture accessing pointer+offset is no more expensive
than just plain pointer, and this lets us get the information we
actually need from the start.
