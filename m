Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab2KUNts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:49:48 -0500
Received: from smtp.nokia.com ([147.243.128.24]:37486 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab2KUNtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:49:46 -0500
X-Greylist: delayed 7966 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2012 08:49:46 EST
From: <leonid.moiseichuk@nokia.com>
To: <glommer@parallels.com>
CC: <kirill@shutemov.name>, <rientjes@google.com>,
        <anton.vorontsov@linaro.org>, <penberg@kernel.org>, <mgorman@suse.de>,
        <kosaki.motohiro@gmail.com>, <minchan@kernel.org>,
        <b.zolnierkie@samsung.com>, <john.stultz@linaro.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <kernel-team@android.com>, <linux-man@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <mhocko@suse.cz>,
        <hannes@cmpxchg.org>, <tj@kernel.org>
Subject: RE: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
Thread-Topic: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
Thread-Index: AQHNvNajVAwxa4W29kaKh6XYDR71zpfeOmsAgAAB2ACAAAQ9AIAMBlsAgAAMv2eAADn4AIAACneAgAALWQCAANJLAIAAy5CAgACwRQCAABMJAIAADG2AgAQw74CAAdbngIABA1UAgAAU6GCAABNFAIAAHnsA
Date: Wed, 21 Nov 2012 13:48:14 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB982690469CC31@008-AM1MPN1-002.mgdnok.nokia.com>
References: <20121115073420.GA19036@lizard.sbx05977.paloaca.wayport.net>
 <alpine.DEB.2.00.1211142351420.4410@chino.kir.corp.google.com>
 <20121115085224.GA4635@lizard>
 <alpine.DEB.2.00.1211151303510.27188@chino.kir.corp.google.com>
 <50A60873.3000607@parallels.com>
 <alpine.DEB.2.00.1211161157390.2788@chino.kir.corp.google.com>
 <50A6AC48.6080102@parallels.com>
 <alpine.DEB.2.00.1211161349420.17853@chino.kir.corp.google.com>
 <50AA3ABF.4090803@parallels.com>
 <alpine.DEB.2.00.1211200950120.4200@chino.kir.corp.google.com>
 <20121121093056.GA31882@shutemov.name>
 <84FF21A720B0874AA94B46D76DB982690469CC00@008-AM1MPN1-002.mgdnok.nokia.com>
 <50ACC104.5060006@parallels.com>
In-Reply-To: <50ACC104.5060006@parallels.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-version: 3.3.8.1
x-tituslabs-classifications-30: TLPropertyRoot=Nokia;Confidentiality=Nokia
 Internal Use Only;Project=None;
x-tituslabs-classificationhash-30: VgNFIFU9Hx+/nZJb9Kg7IqbQaTB01pYvlfczhoKjdi5ZneV8m7WL0RqcskKq273oFFVbp422poiaQKmewK6sRvzp6tEaPBmSXpqOn87QrZraLNfMxPAISx+mffQNGbLNclMYovdPaHi2YGVB5mHgI+zCjdRXVbm6VFeCiEpR7yJFZ9NVSFN8NDbl3qwdZ61ArHOwYowz5dgHMgZ/jN918odmb48UcnNNyXl3TyOolxs5NYuG+vYOiqhMZ+Y+S2v46z3f+M1N+3vlgN/gAEtOVg==
x-headerinfofordlp: None
x-originating-ip: [172.21.82.153]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 21 Nov 2012 13:48:15.0545 (UTC) FILETIME=[DB16A290:01CDC7EE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----Original Message-----
From: ext Glauber Costa [mailto:glommer@parallels.com] 
Sent: 21 November, 2012 13:55
....
So I'll say it again: if this is always global, there is no reason any
cgroup needs to be involved. If this turns out to be per-process, as
Anton suggested in a recent e-mail, I don't see any reason to have
cgroups involved as well.
-----

Per-process memory tracking has no much sense: process should consume all available memory but work fast. Also this approach required knowledge about process deps to take into account dependencies e.g. in dbus or Xorg. If you need to know how much memory process consumed in particular moment you can use /proc/self/smaps, that is easier.

Best Wishes,
Leonid
