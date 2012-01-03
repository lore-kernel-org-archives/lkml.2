Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab2ACRt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:49:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:22843 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab2ACRtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:49:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102759939"
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
Thread-Index: Acy+kVWuU2fL5F7bQFi25L8QZU5ixwABq3bgArtLvDAAKwIQ8AADfZXw
Date: Tue, 3 Jan 2012 17:49:13 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28FACE8@ORSMSX104.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D10@USINDEVS01.corp.hds.com>
 <20111212155827.GR1669@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE46F2@USINDEVS01.corp.hds.com>
 <0207C53569FE594381A4F2EB66570B2A018EFB83C4@orsmsx508.amr.corp.intel.com>
 <20111219210046.GG5650@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57FFA38E@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28FA7D6@ORSMSX104.amr.corp.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C581E2236@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C581E2236@USINDEVS01.corp.hds.com>
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

> I'll ask an Intel EFI guru whether I'm on target.

Got a short note back from the EFI people:

----
The reason the paragraph exists in 7.1.1 is that certain services (as listed
in table 31) are guaranteed to work if you call them a second time when you
have taken an exception in trying to execute them already -- say SetVariable()
face plants with an exception...because of the way our code is designed you
can call it a second time even if the first call that took the exception
didn't succeed.

At any rate, I checked with a couple of the other experts around us and none
of us can see any reason to send yourself an NMI just to preface a call to
a UEFI runtime service.  Thus, our collective opinion is that you are correct
in your interpretation.
----

If you want to discuss this more - they apparently have an external mailing
list some place on TianoCore.org. But this seems pretty clear that we don't
need to self-NMI.

-Tony
