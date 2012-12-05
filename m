Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab2LEWFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:05:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:56859 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2LEWFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:05:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,224,1355126400"; 
   d="scan'208";a="176664559"
From: "Luck, Tony" <tony.luck@intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 3/3] HWPOISON, hugetlbfs: fix RSS-counter warning
Thread-Topic: [PATCH 3/3] HWPOISON, hugetlbfs: fix RSS-counter warning
Thread-Index: AQHN0zI6dliXDWGz7UC1yv3qubqMrZgKwdQg
Date: Wed, 5 Dec 2012 22:04:50 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C963B15@ORSMSX108.amr.corp.intel.com>
References: <1354744058-26373-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1354744058-26373-4-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1354744058-26373-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
-		if (PageAnon(page))
+		if (PageHuge(page))
+			;
+		else if (PageAnon(page))
 			dec_mm_counter(mm, MM_ANONPAGES);
 		else
 			dec_mm_counter(mm, MM_FILEPAGES);

This style minimizes the "diff" ... but wouldn't it be nicer to say:

		if (!PageHuge(page)) {
			old code in here
		}

-Tony
