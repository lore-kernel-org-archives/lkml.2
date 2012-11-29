Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946036Ab2K2Aaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:30:35 -0500
Received: from mga14.intel.com ([143.182.124.37]:1310 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945979Ab2K2Aae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:30:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,180,1355126400"; 
   d="scan'208";a="223980605"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Don Zickus <dzickus@redhat.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2] watchdog: optimizing the hrtimer interval for power
 saving
Thread-Topic: [PATCH V2] watchdog: optimizing the hrtimer interval for power
 saving
Thread-Index: AQHNzX7b3jIJ+7OOuEWyXb6VsTJe75f/9QTQ
Date: Thu, 29 Nov 2012 00:30:30 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1DD2BA@SHSMSX101.ccr.corp.intel.com>
References: <1353602906.15558.1695.camel@cliu38-desktop-build>
 <1354101892.15558.1699.camel@cliu38-desktop-build>
 <20121128154242.GS14805@redhat.com>
In-Reply-To: <20121128154242.GS14805@redhat.com>
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

> It seems like a better approach would be to adjust the timer somehow when
> you change c-states.  The whole point of the hard and softlockup is to
> detect if scheduled code is either deadlock or hogging the cpu for too long.
> 
> If the cpu is in a deep sleep, then nothing is running, right?  Which
> means nothing can deadlock or hog the cpu.  In those cases you can
> probably temporarily disable the lockup detector until the cpu wakes up
> from that c-state and starts scheduling code again.
> 
You are right, I ever tried the thought, when CPU is idle, we can pause the hrtimer,
After wakeup, we resume the hrtimer again. But I found sometimes the in idle and out of
idle is too frequent.
Anyway, you advice seems the right way, I will try to dig something more deeply.
Thanks.
> In that case you can really maximize your power savings (and probably get
> powerTop to stop telling everyone to disable the nmi_watchdog :-) ).
> 
> Ideally in a deep sleep you don't want any soft interrupts running, no?
> 
> Just a thought.
> 
> Cheers,
> Don
