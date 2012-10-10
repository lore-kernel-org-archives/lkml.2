Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab2JJPg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:36:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:49173 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab2JJPgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:36:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,564,1344236400"; 
   d="scan'208";a="232269210"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "jejb@parisc-linux.org" <jejb@parisc-linux.org>,
        "deller@gmx.de" <deller@gmx.de>
Subject: RE: [RFC PATCH 0/3] mca_config stuff
Thread-Topic: [RFC PATCH 0/3] mca_config stuff
Thread-Index: AQHNpvJwHUn4TnoGxUWuM+cQn5+C9Jeypubw
Date: Wed, 10 Oct 2012 15:35:56 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D49FA8@ORSMSX108.amr.corp.intel.com>
References: <1349878801-15956-1-git-send-email-bp@amd64.org>
In-Reply-To: <1349878801-15956-1-git-send-email-bp@amd64.org>
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

> Therefore, I can toggle the bits in the mce code with mca_cfg.<bitname>.
> When defining accessing them through the device attributes in sysfs, I
> use a new macro DEVICE_BIT_ATTR which gets the corresponding bit number
> of that same bit in the bitfield. This gives only one function which
> operates on a bitfield instead of a single function per bit in the
> bitfield.

Is this true across all architectures? I know that pa-risc instructions
that operate on bitfields use "0" to operate on the high order bit
rather than the low order one. I don't recall whether this spills over
into the compiler. If it did, then you'd have to have different #defines
for the bit numbers[1].  For this specific use case it wouldn't matter because
you are just using it in x86 code. But device_store_bit() and device_show_bit()
are in generic code - so they must be able to work across all architectures.

-Tony

[1] Or fix the store/show bit functions to transform the bit numbers from
"little-bitian" to "big-bitian" on architectures that count the other way.
