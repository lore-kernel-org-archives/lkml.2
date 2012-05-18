Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966357Ab2ERSLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:11:48 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:60439 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab2ERSLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:11:46 -0400
From: Colin Cross <ccross@android.com>
To: Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Colin Cross <ccross@android.com>
Subject: [PATCH 0/2] bug fixes for coupled cpuidle
Date: Fri, 18 May 2012 11:05:22 -0700
Message-Id: <1337364324-12171-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last modifications made to the coupled cpuidle patches introduced
two bugs that I missed during testing.  The online count was never
initialized, causing coupled idle to always wait and never enter the
ready loop.  That hid the second bug, the ready count could never be
decremented after exiting idle.

Len, these two patches could be squashed into patch 3 of the original
set.  If you do squash them, you could also add Rafael's tags to the
set (Reviewed-by on 1 and 2, acked-by on 3).  Or I can reupload the
whole stack as v5 if you prefer.
