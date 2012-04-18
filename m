Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2DRCPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:15:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:63579 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab2DRCPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:15:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="130971686"
Subject: Re: [PATCH 1/6] ACPI: D3cold state is always valid
From: Lin Ming <ming.m.lin@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>, Aaron Lu <aaron.lu@amd.com>
In-Reply-To: <201204172229.18203.rjw@sisk.pl>
References: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com>
	 <1334641676-14566-2-git-send-email-ming.m.lin@intel.com>
	 <201204172229.18203.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Apr 2012 10:15:27 +0800
Message-ID: <1334715327.11188.144.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(fix Len's address)

On Tue, 2012-04-17 at 22:29 +0200, Rafael J. Wysocki wrote:
> On Tuesday, April 17, 2012, Lin Ming wrote:
> > ACPI_STATE_D3 actually means ACPI D3hot which is not always valid.
> > Instead, ACPI D3cold is always valid.
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> 
> Can you just introduce ACPI_STATE_D3_HOT and redefine D3_COLD so that
> it's the same as D3, as I said?

Do you mean below?

diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index eba6604..f0b25c8 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -499,9 +499,9 @@ typedef u64 acpi_integer;
 #define ACPI_STATE_D0                   (u8) 0
 #define ACPI_STATE_D1                   (u8) 1
 #define ACPI_STATE_D2                   (u8) 2
-#define ACPI_STATE_D3                   (u8) 3
-#define ACPI_STATE_D3_COLD              (u8) 4
-#define ACPI_D_STATES_MAX               ACPI_STATE_D3_COLD
+#define ACPI_STATE_D3_HOT               (u8) 3
+#define ACPI_STATE_D3                   (u8) 4
+#define ACPI_D_STATES_MAX               ACPI_STATE_D3
 #define ACPI_D_STATE_COUNT              5
 
 #define ACPI_STATE_C0                   (u8) 0


