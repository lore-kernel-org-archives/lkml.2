Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2CAS3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:29:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:34562 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab2CAS3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:29:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131833752"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Topic: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Index: AQHM9jOzRSobI8iWIk6i7fpsFGO9fZZTmLGAgACV04CAAB/YAIAABAsAgAANCYCAAAjigIAA1e4AgACboYD//+qe4A==
Date: Thu, 1 Mar 2012 18:28:47 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F040ACC@ORSMSX104.amr.corp.intel.com>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4D7BF9.9070104@jp.fujitsu.com> <20120229101047.GA21224@aftab>
 <4F4E145E.4040901@redhat.com> <20120229121914.GD21224@aftab>
 <4F4E22B1.6020505@redhat.com> <20120229133741.GF21224@aftab>
 <4F4EDD9A.4050900@jp.fujitsu.com> <20120301114023.GB32410@aftab>
In-Reply-To: <20120301114023.GB32410@aftab>
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

> > My concern is; on Sandy Bridge, is it safe to gather info about the DIMM
> > location in/from machine check context in a reasonable time span?
>
> Well, what amd64_edac does is "buffer" the required lookup info so
> whenever you get an error, you simply lookup the channel and chip select
> - all ops which can be done in atomic context.

Yes - we could pre-read all the config space registers ahead of time and
save them in memory (none of the values should change - except if the platform
supports hot-plug for memory). Total is only a few Kbytes. Then decode in
machine check context is both safe, and fast.

-Tony
