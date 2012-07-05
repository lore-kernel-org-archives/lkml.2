Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab2GEXNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:13:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:63156 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933237Ab2GEXNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:13:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="188954895"
From: "Luck, Tony" <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>, Don Zickus <dzickus@redhat.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Thread-Topic: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Thread-Index: Ac1ZdICAdYwUKctERYa3qDPOlfZeVABeLqqAAA26cAAAAK9jgAABKeAAAApRWjA=
Date: Thu, 5 Jul 2012 23:12:42 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1934764C@ORSMSX104.amr.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAED@USINDEM103.corp.hds.com>
 <20120705133201.GG5637@redhat.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D401C288@USINDEM103.corp.hds.com>
 <20120705202443.GQ5637@redhat.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D401C31F@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D401C31F@USINDEM103.corp.hds.com>
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

> Default value of pstore.kmsg_byte is 10KB.
> I think efi_pstore can log 60KB(= 10KB X 6)...

10K is almost certainly more than we need for 99.9% of problems ... I set the
default there to test out that pstore would correctly break a dump into more
than one back-end ERST record (about 7K) and never changed it back. So
don't treat 10K with any magic reverence. It's easy to argue that a smaller
number is good enough.

There are certainly less over-write worries if you can handle a few
(4, 5, 6) simultaneously logged errors of sufficient size to be useful
(must capture all of the panic strings, backtrace and register dump
plus "enough" lines before the panic to see any obvious issues).

If you only get to store two errors, then perhaps one non-over writable
panic type entry, and one other "most recent" type entry?

With just one, like current EFI, then there are certainly hard choices
that might not be the best for certain pathological situations.

-Tony


