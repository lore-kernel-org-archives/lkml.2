Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab2LJSTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:19:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:12417 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2LJSTQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:19:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,252,1355126400"; 
   d="scan'208";a="231792413"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Topic: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Index: Ac3UwvCZixvXisXmRfC/Xc8ha8nnHAABPNzwAABk6xAAm+7JgAAN3l5w
Date: Mon, 10 Dec 2012 18:19:15 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C966DF1@ORSMSX108.amr.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B7B2@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1C9658B1@ORSMSX108.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B936@USINDEM103.corp.hds.com>
 <20121210164813.GA53431@redhat.com>
In-Reply-To: <20121210164813.GA53431@redhat.com>
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

> But you are assuming that kmsg_dump is perfect and it isn't, in which case
> by putting kmsg_dump in the kdump path, you actually may be blocking kdump
> from working.

I think the concern is that kdump isn't perfect, so sometimes we don't get a good dump
from it. In those cases it would have been nice to have a pstore log of the original
problem.

But ... I don't see an answer to this problem.  Adding more code just increases the
number of possible places we can fail (especially as we are executing in a state
where we know that things are all messed up ... the first kernel panic'd because
something bad happened  that we didn't know how to fix).

A boot argument might help - so we can force use of pstore in cases where
kdump is failing (or prevent use of pstore in cases where it seem to be preventing
us getting to kdump ... I don't have a preference).  BUT this would only be useful
if we had a repeatable problem so that we could switch to the other mode ... and
it seems likely that the kinds of problems that cause pstore or kdump to fail would
be weird cases that are not very repeatable :-(

-Tony
