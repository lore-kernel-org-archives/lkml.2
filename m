Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031272Ab2B2ReV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:34:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:27326 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030904Ab2B2ReT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:34:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131078263"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Topic: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Index: AQHM9jOzRSobI8iWIk6i7fpsFGO9fZZUW7aAgAAO6gCAAAUXgIAACkUA//+aNaCAAJFAAP//fIVQ
Date: Wed, 29 Feb 2012 17:33:51 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F040193@ORSMSX104.amr.corp.intel.com>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4E1F91.9080705@redhat.com> <20120229134556.GG21224@aftab>
 <4F4E3059.7040004@redhat.com> <20120229144054.GH21224@aftab>
 <3908561D78D1C84285E8C5FCA982C28F040115@ORSMSX104.amr.corp.intel.com>
 <20120229171626.GJ21224@aftab>
In-Reply-To: <20120229171626.GJ21224@aftab>
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

> IOW, we want to assume that cores 0, 1, 2 ... k-1 are on node 0; k, k+1
> ... 2k-1 belong to node 1, etc., where k is the number of cores on a
> socket and thus we have a regular core enumeration on the box.

Sounds dubious:

Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
Booting Node   0, Processors  #16 #17 #18 #19 #20 #21 #22 #23 Ok.
Booting Node   1, Processors  #24 #25 #26 #27 #28 #29 #30 #31
Brought up 32 CPUs

Now those are logical cpu numbers, and we brought up the first HT
thread on each core first, and then came around for a 2nd pass
bringing up the other HT thread.  This order is determined by
how the BIOS lists the cpus (and in this case it seems to be
doing so according to recommendations) - so here our core numbers
will match what you said. But the BIOS could do something
strange and list logical cpus alternating between sockets. In
which case cores 0, 2, 4, 6 ... would be on node 0, and cores
1, 3, 5, 7, ... on node 1.

-Tony
