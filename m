Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730Ab2EKQXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:23:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:5527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab2EKQXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:23:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="139558580"
From: "Luck, Tony" <tony.luck@intel.com>
To: Chen Gong <gong.chen@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: RE: [PATCH 1/2] x86/mce: Only restart instruction after machine
 check recovery if it is safe
Thread-Topic: [PATCH 1/2] x86/mce: Only restart instruction after machine
 check recovery if it is safe
Thread-Index: AQHNL0Z9V8VH9kbX5E+oEyS4j60vMJbExUew
Date: Fri, 11 May 2012 16:23:06 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192ED527@ORSMSX104.amr.corp.intel.com>
References: <cover.1336674796.git.tony.luck@intel.com>
 <e6fa674d2f4ded80201f733d06b234b21559f0fe.1336674796.git.tony.luck@intel.com>
 <4FACBD9B.8070407@linux.intel.com>
In-Reply-To: <4FACBD9B.8070407@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4BGNJrc020310

> How about using following condition to decrease the execution time?
> if (mi->restartable == 0 ||
>    memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0)
>
> Since restart operation is impossible, whether recovery operation can
> be avoided?

Because I still want the side-effects from memory_failure() of
marking the page as poisoned and SRAO signal to other users of
the page (or no signal at all to the others for clean LRU page).

Perhaps this deserves a comment

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
