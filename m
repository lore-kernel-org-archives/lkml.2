Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab2ENQQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:16:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:30895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757097Ab2ENQQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:16:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99899007"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: RE: [PATCH 1/2] x86/mce: Only restart instruction after machine
 check recovery if it is safe
Thread-Topic: [PATCH 1/2] x86/mce: Only restart instruction after machine
 check recovery if it is safe
Thread-Index: AQHNMO8MV8VH9kbX5E+oEyS4j60vMJbJdKrg
Date: Mon, 14 May 2012 16:16:05 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192EED2B@ORSMSX104.amr.corp.intel.com>
References: <cover.1336674796.git.tony.luck@intel.com>
 <e6fa674d2f4ded80201f733d06b234b21559f0fe.1336674796.git.tony.luck@intel.com>
 <20120513095913.GB28863@aftab.osrc.amd.com>
In-Reply-To: <20120513095913.GB28863@aftab.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4EGGP38004398

>> +	int			restartable;
>
> Is it me or does this look like a flag, or a bitfield? Instead of
> wasting a whole integer for a single bit of information.

I could make it "int flags;" and "#define MCE_INFO_RESTARTABLE 1"
to make it clear that we have lots more bits available for special
cases?

> It will probably end up the same size though due to compiler padding
> since this struct is currently 4 + 2*8 byte without the ->restartable
> thing.

Yup - we can't save any memory (unless we introduce more complexity to
the code ... low PAGE_SHIFT bits of the "paddr" field are simply thrown
away ... so we could allocate a bit there ... but I don't think that
the resulting ugliness is worth the memory savings).

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
