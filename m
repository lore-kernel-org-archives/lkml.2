Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab2ABTl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 14:41:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:29881 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab2ABTly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 14:41:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108023493"
From: "Luck, Tony" <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>, Don Zickus <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH v3 2/3] Skip spin_locks in panic case and add
 WARN_ON()
Thread-Topic: [RFC][PATCH v3 2/3] Skip spin_locks in panic case and add
 WARN_ON()
Thread-Index: Acy+kVWuU2fL5F7bQFi25L8QZU5ixwABq3bgArtLvDA=
Date: Mon, 2 Jan 2012 19:41:52 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28FA7D6@ORSMSX104.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D10@USINDEVS01.corp.hds.com>
 <20111212155827.GR1669@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE46F2@USINDEVS01.corp.hds.com>
 <0207C53569FE594381A4F2EB66570B2A018EFB83C4@orsmsx508.amr.corp.intel.com>
 <20111219210046.GG5650@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57FFA38E@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57FFA38E@USINDEVS01.corp.hds.com>
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

>  7.1.1 Exception for Machine Check, INIT, and NMI.

I wonder if this section is poorly named ... I suspect that it may really mean
"Exception for fatal situations".  I don't think that the EFI code has any way
to know that one of these events has happened (in theory it could tell that it
was executing a machine check handler if it looked at MCIP bit in MCG_STATUS,
but I doubt that it does that ... INIT/NMI would seem even harder to detect).

>   My suggestion is that panicked cpu sends NMI to itself and then it calls kmsg_dump(KMSG_DUMP_PANIC) in NMI.

So I wonder whether there is any value in the cpu sending an NMI to itself to
meet the exact wording of this section in the spec.

I'll ask an Intel EFI guru whether I'm on target.

-Tony
