Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958Ab2JLRqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:46:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:60486 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759834Ab2JLRqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:46:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,577,1344236400"; 
   d="scan'208";a="226195277"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: RE: [RFC PATCH 3/3] Convert mce_disabled
Thread-Topic: [RFC PATCH 3/3] Convert mce_disabled
Thread-Index: AQHNpvJoe4YCF/JU9UKk6x+JHaLQpZe19koAgAASYwD//+j0oA==
Date: Fri, 12 Oct 2012 17:46:16 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D4ABDA@ORSMSX108.amr.corp.intel.com>
References: <1349878801-15956-1-git-send-email-bp@amd64.org>
 <1349878801-15956-4-git-send-email-bp@amd64.org>
 <5077F600.9090605@linux.vnet.ibm.com>
 <20121012115628.GA14991@aftab.osrc.amd.com>
In-Reply-To: <20121012115628.GA14991@aftab.osrc.amd.com>
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

> Or, you can modify the mca_config I have there and use bools and pass a
> pointer to each actual bool member in each DEVICE_BIT_ATTR invocation
> (and rename it to DEVICE_BOOL_ATTR). Yeah, that could work, unless I'm
> missing something else, of course.

This looks like the best solution to me. Sure we use a little more memory for
a "bool" for each option instead of just a single bit. But there are only a
handful of them, not thousands. So I think we can cope with a few extra
bytes of memory consumption.  I was still not completely convinced by the

       if (val)
               *bvec |= le64_to_cpu(BIT_64(bit));

solution - it assumes that big endian machines also assign their bit numbers
in a big->little way - but that isn't required by the C standard. bitfields are
assigned at the whim of the compiler writer (the only restrictions seem to
be on alignments of fields w.r.t. to the underlying data types).

-Tony
