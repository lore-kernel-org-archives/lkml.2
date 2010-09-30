Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab0I3T2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:28:00 -0400
Received: from 87-119-183-111.tll.elisa.ee ([87.119.183.111]:3944 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756307Ab0I3T16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:27:58 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: arjan@linux.intel.com, tglx@linutronix.de
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        Artem.Bityutskiy@nokia.com
Subject: timer: permit statically-declared work with deferrable timers
Date: Thu, 30 Sep 2010 22:26:28 +0300
Message-Id: <1285874789-1481-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arjen, Thomas,

This patch is an enabler which hopefully can lead to simplification of code 
elsewhere. For example, it would turn Artem's patch I refer to in the commit
message (8eab945c5616fc984e97b922d6a2559be93f39a1) into just:

-static DECLARE_DELAYED_WORK(cache_cleaner, do_cache_clean);
+static DECLARE_DEFERRED_WORK(cache_cleaner, do_cache_clean);

rather than the creation of a __init helper that required touching 3 files.

I'm prepared to follow up with such simplifying patches if it's considered
worthwhile.

Cheers,
Phil
