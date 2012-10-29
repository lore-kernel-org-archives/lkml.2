Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab2J2TnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:43:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:62302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab2J2Tm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:42:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,673,1344236400"; 
   d="scan'208";a="241581861"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Akira Fujita <a-fujita@rs.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: RE: [PATCH 2/3] ext4: introduce ext4_error_remove_page
Thread-Topic: [PATCH 2/3] ext4: introduce ext4_error_remove_page
Thread-Index: AQHNssNn60IFoxEWWkW+xJzYf95sNpfLkXcAgAA0tFCAAJ4qgP//weDAgAILBQCAAmnU0A==
Date: Mon, 29 Oct 2012 18:11:58 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D5ABB3@ORSMSX108.amr.corp.intel.com>
References: <1351177969-893-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1351177969-893-3-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20121026061206.GA31139@thunk.org>
 <3908561D78D1C84285E8C5FCA982C28F19D5A13B@ORSMSX108.amr.corp.intel.com>
 <20121026184649.GA8614@thunk.org>
 <3908561D78D1C84285E8C5FCA982C28F19D5A388@ORSMSX108.amr.corp.intel.com>
 <20121027221626.GA9161@thunk.org>
In-Reply-To: <20121027221626.GA9161@thunk.org>
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

> What I would recommend is adding a 
>
> #define FS_CORRUPTED_FL		0x01000000 /* File is corrupted */
>
> ... and which could be accessed and cleared via the lsattr and chattr
> programs.

Good - but we need some space to save the corrupted range information
too. These errors should be quite rare, so one range per file should be
enough.

New file systems should plan to add space in their on-disk format. The
corruption isn't going to go away across a reboot.

-Tony
