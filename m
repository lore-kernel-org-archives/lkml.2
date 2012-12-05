Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2LEWNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:13:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:53406 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab2LEWNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:13:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,224,1355126400"; 
   d="scan'208";a="176667883"
From: "Luck, Tony" <tony.luck@intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 1/3] HWPOISON, hugetlbfs: fix warning on freeing
 hwpoisoned hugepage
Thread-Topic: [PATCH 1/3] HWPOISON, hugetlbfs: fix warning on freeing
 hwpoisoned hugepage
Thread-Index: AQHN0zI/ecpD0PErxkGvnJQuX5k39ZgKwsyQ
Date: Wed, 5 Dec 2012 22:13:42 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C963B5E@ORSMSX108.amr.corp.intel.com>
References: <1354744058-26373-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1354744058-26373-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1354744058-26373-2-git-send-email-n-horiguchi@ah.jp.nec.com>
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

> This patch fixes the warning from __list_del_entry() which is triggered
> when a process tries to do free_huge_page() for a hwpoisoned hugepage.

Ultimately it would be nice to avoid poisoning huge pages. Generally we know the
location of the poison to a cache line granularity (but sometimes only to a 4K
granularity) ... and it is rather inefficient to take an entire 2M page out of service.
With 1G pages things would be even worse!!

It also makes life harder for applications that would like to catch the SIGBUS
and try to take their own recovery actions. Losing more data than they really
need to will make it less likely that they can do something to work around the
loss.

Has anyone looked at how hard it might be to have the code in memory-failure.c
break up a huge page and only poison the 4K that needs to be taken out of service?

-Tony
