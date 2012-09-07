Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab2IGCUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:20:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:59958 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab2IGCUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:20:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,382,1344236400"; 
   d="scan'208";a="219141920"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
Subject: [QUESTION] Can we remove the local_irq_enable() in function panic()?
Thread-Topic: [QUESTION] Can we remove the local_irq_enable() in function
 panic()?
Thread-Index: Ac2MnyqVUegQCROqSkCnIEhMUWq6YQ==
Date: Fri, 7 Sep 2012 02:19:12 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A17939B@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Could some one give help that removing the local_irq_enable() in function panic()?

Currently I meet one case that when panic happening at irq disabling state with spin_lock,
After panic() is called, due to local_irq_enable() is called, it causes some interrupts come,
and cause more issue that "BUG: spinlock recursion on CPU#0".


Checked the git history, do not find any hint for local_irq_enable(), can any share something?
Thanks.

Panic()
{
....
	local_irq_enable();
	for (i = 0; ; i += PANIC_TIMER_STEP) {
....
}



