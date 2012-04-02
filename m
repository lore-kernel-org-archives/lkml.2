Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2DBMwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:52:24 -0400
Received: from masquerade.micron.com ([137.201.242.130]:29185 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2DBMwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 08:52:22 -0400
From: "Luca Porzio (lporzio)" <lporzio@micron.com>
To: Hugh Dickins <hughd@google.com>, Arnd Bergmann <arnd@arndb.de>
CC: Rik van Riel <riel@redhat.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Alex Lemberg <alex.lemberg@sandisk.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Saugata Das <saugata.das@linaro.org>,
        Venkatraman S <venkat@linaro.org>, Yejin Moon <yejin.moon@samsung.com>,
        Hyojin Jeong <syr.jeong@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: RE: swap on eMMC and other flash
Thread-Topic: swap on eMMC and other flash
Thread-Index: AQHNDpzybzWjK4z/iEWbFOApOu/42JaDDSoAgAGt6QCAAsVsIA==
Date: Mon, 2 Apr 2012 12:52:04 +0000
Message-ID: <26E7A31274623843B0E8CF86148BFE326FB55F8B@NTXAVZMBX04.azit.micron.com>
References: <201203301744.16762.arnd@arndb.de>
 <201203301850.22784.arnd@arndb.de>
 <alpine.LSU.2.00.1203311230490.10965@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1203311230490.10965@eggly.anvils>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.53.32.185]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.500.1024-18812.005
X-TM-AS-Result: No--3.406600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh,

Great topics. As per one of Rik original points:

> 4) skip writeout of zero-filled pages - this can be a big help
>     for KVM virtual machines running Windows, since Windows zeroes
>     out free pages;   simply discarding a zero-filled page is not
>     at all simple in the current VM, where we would have to iterate
>     over all the ptes to free the swap entry before being able to
>     free the swap cache page (I am not sure how that locking would
>     even work)
> 
>     with the extra layer of indirection, the locking for this scheme
>     can be trivial - either the faulting process gets the old page,
>     or it gets a new one, either way it'll be zero filled
> 

Since it's KVMs realm here, can't KSM simply solve the zero-filled pages problem avoiding unnecessary burden for the Swap subsystem?

Cheers, 
   Luca
