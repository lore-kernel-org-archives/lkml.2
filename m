Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0FCMOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:14:54 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19324 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0FCMOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:14:52 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: linux@arm.linux.org.uk, catalin.marinas@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ARM: unwind extension
Date: Thu,  3 Jun 2010 15:17:19 +0300
Message-Id: <1275567442-11370-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 03 Jun 2010 12:14:23.0026 (UTC) FILETIME=[4D3DF120:01CB0316]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The first two patches are simply preparation for the third, making it
effectively trivial, even though it's the only one with a concrete 
change in behaviour.

The origins of this patchset are the discovery that unwind and kmemleak
don't always cooperate well with each other - any allocation within 
an exit or devexit function causes kmemleak to look up symbols that 
aren't in any unwind table. This of course means that all WARN_ONs and
BUGs will suffer the same fate.

It could certainly be said that with a typical system the linked list
has grown too large to be practical as a container, and some improvements
could be made in that direction in the future.

Cheers,
Phil
