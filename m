Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab2FHHTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:19:21 -0400
Received: from smtp.nokia.com ([147.243.128.24]:30855 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab2FHHTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:19:19 -0400
From: <leonid.moiseichuk@nokia.com>
To: <kosaki.motohiro@gmail.com>
CC: <anton.vorontsov@linaro.org>, <penberg@kernel.org>,
        <b.zolnierkie@samsung.com>, <john.stultz@linaro.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <kernel-team@android.com>
Subject: RE: [PATCH 2/5] vmevent: Convert from deferred timer to deferred
 work
Thread-Topic: [PATCH 2/5] vmevent: Convert from deferred timer to deferred
 work
Thread-Index: AQHNP/HM8KMmZkc4xkKq2ZDXaeCP2Zbvq0sAgAA7gACAACLOoP//4JWAgAAi/oA=
Date: Fri, 8 Jun 2012 07:18:57 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045F78E1@008-AM1MPN1-004.mgdnok.nokia.com>
References: <20120601122118.GA6128@lizard>
 <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
 <4FD170AA.10705@gmail.com> <20120608065828.GA1515@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7890@008-AM1MPN1-004.mgdnok.nokia.com>
 <CAHGf_=rHGotkPYJt65wv+ZDNeO2x+3c5sA8oJmGJX8ehsMHqoA@mail.gmail.com>
In-Reply-To: <CAHGf_=rHGotkPYJt65wv+ZDNeO2x+3c5sA8oJmGJX8ehsMHqoA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.162.61.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 07:18:58.0427 (UTC) FILETIME=[F896C4B0:01CD4546]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ext KOSAKI Motohiro [mailto:kosaki.motohiro@gmail.com]
> Sent: 08 June, 2012 10:11
..
> No. I don't suggest to wake up every 100ms. I suggest to integrate existing
> subsystems. If you need any enhancement, just do it.
That will be non-trivial to hook all vmstat updates . Simple to use deferred timer.

> > It also will cause page trashing because user-space code could be pushed
> out from cache if VM decide.
> 
> This is completely unrelated issue. Even if notification code is not swapped,
> userland notify handling code still may be swapped. So, if you must avoid
> swap, you must use mlock.

If you wakeup only by signal when memory situation changed you can be not mlocked.
Mlocking uses memory very inefficient way and usually cannot be applied for apps which wants to be notified due to resources restrictions.
