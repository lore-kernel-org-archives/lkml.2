Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab2JSRVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:21:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:40747 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab2JSRVj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:21:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,613,1344236400"; 
   d="scan'208";a="236071236"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Tang Chen <tangchen@cn.fujitsu.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: RE: [PATCH v2 2/2] Do not change worker's running cpu in
 cmci_rediscover().
Thread-Topic: [PATCH v2 2/2] Do not change worker's running cpu in
 cmci_rediscover().
Thread-Index: AQHNrb0lcU3mEqLRBkyObsTOs9Ryn5fBS1eA//+U5RA=
Date: Fri, 19 Oct 2012 17:21:17 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D57AA5@ORSMSX108.amr.corp.intel.com>
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
 <1350625528-1385-3-git-send-email-tangchen@cn.fujitsu.com>
 <20121019164233.GF11958@aftab.osrc.amd.com>
In-Reply-To: <20121019164233.GF11958@aftab.osrc.amd.com>
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

> In this case, the following BUG_ON in try_to_wake_up_local() will be triggered:
> BUG_ON(rq != this_rq());

Logically this looks OK - what is the test case to trigger this?  I've done a moderate
amount of testing of cpu online/offline while injecting corrected errors (when testing
the CMCI storm patches) ... but didn't see this problem.

-Tony
