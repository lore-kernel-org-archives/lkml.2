Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1DLUDC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:03:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:42744 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab1DLUDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,198,1301900400"; 
   d="scan'208";a="627569599"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Prarit Bhargava <prarit@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>
Date: Tue, 12 Apr 2011 13:02:21 -0700
Subject: RE: [PATCH]: mce: don't print "human readable" message for
 corrected errors
Thread-Topic: [PATCH]: mce: don't print "human readable" message for
 corrected errors
Thread-Index: Acv5Q6l5d0fmcpzVQeuhxLwO3ZyWHQACBPTA
Message-ID: <987664A83D2D224EAE907B061CE93D5301A9629BD5@orsmsx505.amr.corp.intel.com>
References: <20110412174405.26867.65604.sendpatchset@prarit.bos.redhat.com>
 <20110412185842.GB9891@liondog.tnic>
In-Reply-To: <20110412185842.GB9891@liondog.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3CK39qs008287

> Why not? This way you turn reporting of _ALL_ correctable MCEs
> completely off and some users would actually like to run them through
> mcelog on Intel.

pr_emerg() is rather overkill for a corrected error - on large systems
corrected errors are going to be a routine occurrence (my personal estimation
is "one soft error per gigabyte per month" ... which is pretty much the
same as "one per terabyte per hour" for the people with the really cool
toys.

We are also setting TAINT_MACHINE_CHECK for corrected errors - perhaps
this made sense when systems were small and machine checks were rare and
scary.  But I think we need to start working with the reality that
corrected errors are normal events.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
