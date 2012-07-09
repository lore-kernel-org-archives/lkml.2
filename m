Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab2GIQXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 12:23:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:32473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab2GIQXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 12:23:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="169303883"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: RE: [PATCH] x86/mce: Need to let kill_proc() send signal to doomed
 process
Thread-Topic: [PATCH] x86/mce: Need to let kill_proc() send signal to doomed
 process
Thread-Index: AQHNW/pwcQlQ7KYPb0WBfET8yEAILZchJMGw
Date: Mon, 9 Jul 2012 16:22:08 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19348DFF@ORSMSX104.amr.corp.intel.com>
References: <6695e005b7368df4307d34276300fe030e83466c.1341611925.git.tony.luck@intel.com>
 <20120707043847.GB5708@aftab.osrc.amd.com>
In-Reply-To: <20120707043847.GB5708@aftab.osrc.amd.com>
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

> This makes mi->restartable unused?

It does ... but it's not what I meant ... somehow I lost the code that set MF_MUST_KILL
based on mi->restartable. Doh!

>> +	doit = !!PageDirty(ppage) || (flags & MF_MUST_KILL) != 0;
>
> Maybe
>
>				     !!(flags & MF_MUST_KILL)

That fits stylistically with the other half of the "||" expression.

Thanks for the review. I'll update and resend.

-Tony
