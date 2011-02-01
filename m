Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1BATrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:47:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:43274 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab1BATrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:47:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,411,1291622400"; 
   d="scan'208";a="883323144"
From: "Luck, Tony" <tony.luck@intel.com>
To: =?utf-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>
CC: "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "tj@kernel.org" <tj@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "shiyer@redhat.com" <shiyer@redhat.com>,
        "pjones@redhat.com" <pjones@redhat.com>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Tue, 1 Feb 2011 11:46:46 -0800
Subject: RE: [RFC][PATCH] kmsg_dumper for NVRAM
Thread-Topic: [RFC][PATCH] kmsg_dumper for NVRAM
Thread-Index: AcvB8poCc1wclGjEQ1yvoaWvYS7xdQAVLD1A
Message-ID: <987664A83D2D224EAE907B061CE93D530194487CA2@orsmsx505.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C1472ACC8@USINDEVS01.corp.hds.com>
 <20110201092942.GD21239@cr0.nay.redhat.com>
In-Reply-To: <20110201092942.GD21239@cr0.nay.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p11JlTsh011188

> This looks like what Tony wanted, pstore.

Yes - this looks like another means to the same end (making console log
Available after a crash).

I wonder whether you could use my pstore file system interface
for this ... you'd need to write a backend that used EFI variable
space to save the pieces of a console log, in much the same way
that I used ERST to stash the pieces.

This might be a bit messy - but I think that it would be
worth doing in order to provide a single user interface
to the kmsg_dump on different architectures, regardless
of the underlying storage method used.  I.e. the OS
vendors would just have to write startup scripts to glean
information from /dev/pstore and clear it by removing the
files there. Rather than having one set of scripts that
looks at EFI variables for machines that use that, a different
set for machines that have the sparc64 method of saving in
some special area of ram, and yet another set for a machine
that has some other motherboard magical non volatile storage
that hasn't been designed yet.

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
