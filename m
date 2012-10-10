Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab2JJPql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:46:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:61114 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab2JJPqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:46:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,564,1344236400"; 
   d="scan'208";a="225140673"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: RE: [RFC PATCH 3/3] Convert mce_disabled
Thread-Topic: [RFC PATCH 3/3] Convert mce_disabled
Thread-Index: AQHNpvJoe4YCF/JU9UKk6x+JHaLQpZeyrcYA
Date: Wed, 10 Oct 2012 15:46:39 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D49FC7@ORSMSX108.amr.corp.intel.com>
References: <1349878801-15956-1-git-send-email-bp@amd64.org>
 <1349878801-15956-4-git-send-email-bp@amd64.org>
In-Reply-To: <1349878801-15956-4-git-send-email-bp@amd64.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct mca_config {
-	u64 dont_log_ce	: 1,
-#define MCA_CFG_DONT_LOG_CE	0
-	    __resv1	: 63;
+	u64	dont_log_ce	: 1,
+#define MCA_CFG_DONT_LOG_CE	  0
+		mca_disabled	: 1,
+#define MCA_CFG_MCA_DISABLED	  1
+	    __resv1	: 62;
 };

If we do head in this direction - I don't think it is useful to change just one bit
on each commit. We should batch in larger groups.

-Tony
