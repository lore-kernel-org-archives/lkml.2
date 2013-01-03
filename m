Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3ACAFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 19:05:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:60373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab3ACAFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 19:05:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,398,1355126400"; 
   d="scan'208";a="266480705"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Du Jiulun <dujiulun@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Fwd: PROBLEM: Random kernel panic & system freeze when watching
 video
Thread-Topic: Fwd: PROBLEM: Random kernel panic & system freeze when
 watching video
Thread-Index: AQHN5nGrz6ubjlQZ4kOu6G67xLtDcJgyM/WAgAEG4QCAA4AqgA==
Date: Thu, 3 Jan 2013 00:05:28 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C973871@ORSMSX108.amr.corp.intel.com>
References: <CAHfmSg2akcYUwDW38g520Fwyr17E5dFDpuUMKejQCfLpQ4pnhQ@mail.gmail.com>
 <CAHfmSg3ug=64vXtsA4EA6xdKaqWRtT7qZW9AG8n92Q+pbDgQEQ@mail.gmail.com>
 <20121230094008.GA28308@x1.alien8.de>
 <CAHfmSg0O90nC3rnkZHAjO_MNjOoU1v8h-LN+jxx=0U+pz7NasQ@mail.gmail.com>
 <20121231102300.GA1701@x1.alien8.de>
In-Reply-To: <20121231102300.GA1701@x1.alien8.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0305aKs007917

>I had to build the latest mcelog from kernel.org and it tells you a
>little bit more: it is an internal parity error. I don't know, though,
>what errors reported in bank 2 pertain to on this cpu model - Intel
>should know :).

Intel is a big place ... we didn't document which bank reports
which structure in the public data sheet ... so I'd have to find
some internal docs for that.  Not sure it would help though as
the MC2STATUS register value 0xb200000000000005 just says
"internal error" - without any extra bits in the "mscod" subfield.
This is the "default:" at the end of the internal "switch" where
all the usual suspects have been eliminated and we just know
that something went wrong.

One possibility is a thermal problem (since I presume that
video decode is making the CPU work hard). Does the machine
get noticeably warmer, or does the fan kick up to high speed
when this happens?

Another (harder to isolate) is power supply ... if the CPU is
drawing more power during video decode, then you might
see a brownout where voltage drops too low. This could cause
all sorts of internal problems.

How predictable is the problem?  If you power on the system
from cold (unused for a few minutes) and immediately start
watching a video (same video in multiple tests) ... do you see
the hang/crash at the same point in the movie? Or are there
large variations.

If we have a plain s/w bug doing something evil that trips
the problem, I'd expect a high level of repeatability. If you
have a thermal problem then you may be able to accelerate
it by partially blocking the fan exhaust. Electrical ... I suppose
it might be different on AC power vs. battery.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
