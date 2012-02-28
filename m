Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966140Ab2B1Wn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:43:56 -0500
Received: from mga14.intel.com ([143.182.124.37]:16783 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346Ab2B1Wnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:43:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="71546816"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>
CC: EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: RE: [PATCH 2/3] x86, RAS: Add a decoded msg buffer
Thread-Topic: [PATCH 2/3] x86, RAS: Add a decoded msg buffer
Thread-Index: AQHM9jOtUmbuajAxpkKVcYLgsy1w3pZS50zw
Date: Tue, 28 Feb 2012 22:43:52 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F03FD68@ORSMSX104.amr.corp.intel.com>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-3-git-send-email-bp@amd64.org>
In-Reply-To: <1330445487-15020-3-git-send-email-bp@amd64.org>
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

+	if (left <= 50) {
+		/* enlarge arbitrarily by 50 chars */
+		err_str_sz += 50;
+		left += 50;
+
+		err_str = krealloc(err_str, err_str_sz, GFP_KERNEL);
+		if (!err_str) {
+			pr_err("Error enlarging decode buffer.\n");
+			return;
+		}
+	}

This looks worrying to me.  Some bad stuff has happened, we are perhaps
in machine check context, and you want to start allocating memory!

Is there some upper bound for how long this string can get? Why not
just allocate a generous amount at boot time?

-Tony
