Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab2JPAlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:41:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42682 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab2JPAlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:41:05 -0400
Date: Mon, 15 Oct 2012 17:37:56 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH v10 0/4] ARM: KDB FIQ debugger
Message-ID: <20121016003756.GA23146@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

The KDB/NMI core support has been merged into v3.7-rc1, so the only ARM
bits are pending now. I believe I addressed all your previous comments,
but surely there might be something else to improve, thus would be great
if you could take a look at this.

The patches were rebased onto v3.7-rc1, and this is the only change in
v10.

Old changelogs and rationale for these patches can be found here:

	v1-v5, rationale: http://lkml.org/lkml/2012/9/10/2
	v6: http://lkml.org/lkml/2012/9/10/2
	v7: http://lkml.org/lkml/2012/9/13/367
	v8: http://lkml.org/lkml/2012/9/19/525
	v9: http://lkml.org/lkml/2012/9/24/538

Thanks!
Anton.

--
 arch/arm/Kconfig                    |  19 ++++
 arch/arm/common/vic.c               |  28 +++++
 arch/arm/include/asm/hardware/vic.h |   2 +
 arch/arm/include/asm/kgdb.h         |   8 ++
 arch/arm/kernel/Makefile            |   1 +
 arch/arm/kernel/entry-armv.S        | 167 +---------------------------
 arch/arm/kernel/entry-header.S      | 170 +++++++++++++++++++++++++++++
 arch/arm/kernel/kgdb_fiq.c          | 124 +++++++++++++++++++++
 arch/arm/kernel/kgdb_fiq_entry.S    |  87 +++++++++++++++
 arch/arm/mach-versatile/Makefile    |   1 +
 arch/arm/mach-versatile/kgdb_fiq.c  |  31 ++++++
 11 files changed, 472 insertions(+), 166 deletions(-)
