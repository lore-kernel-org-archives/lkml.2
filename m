Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031221Ab2B2RLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:11:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:42269 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030714Ab2B2RLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:11:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112851974"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Topic: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Index: AQHM9jOzRSobI8iWIk6i7fpsFGO9fZZTmLGAgACV04CAAB/YAIAABAsAgAANCYCAAAjigP//suNQ
Date: Wed, 29 Feb 2012 17:11:08 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F04012A@ORSMSX104.amr.corp.intel.com>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4D7BF9.9070104@jp.fujitsu.com> <20120229101047.GA21224@aftab>
 <4F4E145E.4040901@redhat.com> <20120229121914.GD21224@aftab>
 <4F4E22B1.6020505@redhat.com> <20120229133741.GF21224@aftab>
In-Reply-To: <20120229133741.GF21224@aftab>
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

>> - on Nehalem, the MCE status register encodes not only the error message; it
>>   also encodes the DIMM that generated the  error. So, it is possible to 
>>   completely decode the error on userspace, using only the MCE registers.
>
> Well, depending on what Tony wants to do there, either decode the error
> in the kernel and pass it on with the 'msg' arg or do the whole decoding
> in userspace.

For best results - we should decode right away in the kernel. Decoding later
requires that we carry a lot of additional information about the system
configuration at the time of the error.  Consider the case of a hard error
(either fatal or recoverable). If the system reboots, then the DIMM
with the error should fail self test - and thus be mapped out of the system.
If the error analyzer doesn't realize that this has happened, it will be
very confused. Even if it does notice - the Sandy bridge decoder won't be
able to check that the right DIMM was mapped out (since the configuration
registers it reads to map addresses to DIMMS will now be set for the new
configuration, with different mappings).

-Tony
