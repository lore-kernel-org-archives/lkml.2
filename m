Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2DQFsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 01:48:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:49201 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab2DQFsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 01:48:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89863260"
From: Lin Ming <ming.m.lin@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.og>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH 3/6] ACPI: Set D3cold state as default inferred state
Date: Tue, 17 Apr 2012 13:47:53 +0800
Message-Id: <1334641676-14566-4-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com>
References: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI_STATE_D3 means ACPI D3hot state which should only be returned when
power resources listed in _PR3 are 'on'.

Return ACPI D3cold state if no other state is known.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/power.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 7049a7d..27a2bad 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -646,7 +646,7 @@ int acpi_power_get_inferred_state(struct acpi_device *device, int *state)
 		}
 	}
 
-	*state = ACPI_STATE_D3;
+	*state = ACPI_STATE_D3_COLD;
 	return 0;
 }
 
-- 
1.7.2.5

