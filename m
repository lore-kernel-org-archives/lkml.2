Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316Ab2FHHtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:49:33 -0400
Received: from smtp.nokia.com ([147.243.128.26]:50232 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759597Ab2FHHtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:49:31 -0400
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
Thread-Index: AQHNP/HM8KMmZkc4xkKq2ZDXaeCP2Zbvq0sAgAA7gACAACLOoP//4JWAgAAi/oD//+B6AIAAIckQ///hF4AABKRTEA==
Date: Fri, 8 Jun 2012 07:49:06 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045F7956@008-AM1MPN1-004.mgdnok.nokia.com>
References: <20120601122118.GA6128@lizard>
 <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
 <4FD170AA.10705@gmail.com> <20120608065828.GA1515@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7890@008-AM1MPN1-004.mgdnok.nokia.com>
 <CAHGf_=rHGotkPYJt65wv+ZDNeO2x+3c5sA8oJmGJX8ehsMHqoA@mail.gmail.com>
 <84FF21A720B0874AA94B46D76DB98269045F78E1@008-AM1MPN1-004.mgdnok.nokia.com>
 <CAHGf_=pNJAQP4GhTwtOkBxUDYU4n_-CKmKU7T4PzszwdL9Ju6Q@mail.gmail.com>
 <84FF21A720B0874AA94B46D76DB98269045F7918@008-AM1MPN1-004.mgdnok.nokia.com>
 <4FD1AABD.7010602@gmail.com>
In-Reply-To: <4FD1AABD.7010602@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.162.61.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 07:49:08.0299 (UTC) FILETIME=[2F5B51B0:01CD454B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ext KOSAKI Motohiro [mailto:kosaki.motohiro@gmail.com]
> Sent: 08 June, 2012 10:33
> To: Moiseichuk Leonid (Nokia-MP/Espoo)
.. 
> Wrong. CPU don't realized the running code belong to userspace or kernel.
> Every code just consume a power. That's why polling timer is wrong from
> point of power consumption view.
???
We are talking about different things.
User-space code could be dropped, distributed between several applications and has not deferred timers support.
For polling API the user-space code has to be executed quite often.
Localizing this code in kernel additionally allows to avoid vmsat/meminfo generation and parsing overhead as well.
