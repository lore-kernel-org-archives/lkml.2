Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2HKWlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 18:41:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:61798 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab2HKWlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 18:41:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,752,1336374000"; 
   d="scan'208";a="133068141"
From: "Luck, Tony" <tony.luck@intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Rik van Riel <riel@redhat.com>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Naoya Horiguchi <nhoriguc@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] HWPOISON: improve handling/reporting of memory
 error on dirty pagecache
Thread-Topic: [PATCH 3/3] HWPOISON: improve handling/reporting of memory
 error on dirty pagecache
Thread-Index: AQHNd0EDhdRZgJSR4E+O42RL++g+1ZdVNO6A
Date: Sat, 11 Aug 2012 22:41:49 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19375BFE@ORSMSX104.amr.corp.intel.com>
References: <1344634913-13681-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1344634913-13681-4-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1344634913-13681-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> dirty pagecache error recoverable under some conditions. Consider that
> if there is a copy of the corrupted dirty pagecache on user buffer and
> you write() over the error page with the copy data, then we can ignore
> the effect of the error because no one consumes the corrupted data.

This sounds like a quite rare corner case. If the page is already dirty, it is
most likely because someone recently did a write(2) (or touched it via
mmap(2)). Now you are hoping that some process is going to write the
same page again.  Do you have an application in mind where this would
be common. Remember that the write(2), memory-error, new write(2)
have to happen close together (before Linux decides to write out the
dirty page).

-Tony

