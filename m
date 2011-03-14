Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1CPC2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:28:09 -0400
Received: from science.horizon.com ([71.41.210.146]:44008 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751006Ab1CPC2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:28:07 -0400
Message-ID: <20110316022804.27676.qmail@science.horizon.com>
From: George Spelvin <linux@horizon.com>
Date: Sun, 13 Mar 2011 20:20:44 -0400
Subject: [PATCH 0/8] mm/slub: Add SLUB_RANDOMIZE support
To: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, mpm@selenic.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a followup to the "[PATCH] Make /proc/slabinfo 0400" thread, this
is a patch series to randomize the order of object allocations within
a page.  It can be extended to SLAB and SLOB if desired.  Mostly it's
for benchmarking and discussion.

It Boots For Me(tm).

Patches 1-4 and 8 touch drivers/char/random.c, to add support for
efficiently generating a series of uniform random integers in small
ranges.  Is this okay with Herbert & Matt?

I did a bit of code cleanup while I was at it, but kept it to separate
patches.  Patches 4 and 7 are the heart of the new code, but I'd
particularly like comments on patch 8, as I don't understand the kconfig
stuff very well.  Is the feature description good and are the control
knobs adequate?

Checkpatch complains about a too-short CONFIG option description on
8/8; I think it's spurious.
