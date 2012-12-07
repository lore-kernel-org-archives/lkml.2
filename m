Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab2LGWRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 17:17:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:39606 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab2LGWRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 17:17:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,240,1355126400"; 
   d="scan'208";a="230521155"
From: "Luck, Tony" <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Topic: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Index: Ac3UwvCZixvXisXmRfC/Xc8ha8nnHAABPNzw
Date: Fri, 7 Dec 2012 22:17:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C9658B1@ORSMSX108.amr.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B7B2@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B7B2@USINDEM103.corp.hds.com>
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

> This patch skips taking a psinfo->buf_lock when just one cpu is online
> because stopped cpus turn to offline via smp_send_stop()
> in some architectures like x86, powerpc or arm64.

That seems an impressive list of preconditions.  So for this to
help we need to have taken all but one cpu offline, then be in
some code that is holding the pstore lock and get hit by an NMI
which causes us to recurse into the pstore code.

Can all these things really happen (did you run into this problem
on a real system?). Or is this just a theoretical problem.  Ugly (but
practical) hacks might be OK to solve real problems. But do we really
want them to fix problems that actually never happen?

-Tony
