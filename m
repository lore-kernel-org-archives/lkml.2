Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab2EHPed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:34:33 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:36367 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755664Ab2EHPec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:34:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Po6hDRcVM1lQEUxpX.43dDC5TTKjl7Kdh4qivH6CqWZU1zT
 WZbSQQa3TKGUCARoUaDAGsFfb7G3kN6HANwvcqP91xfRVeXAwaVdvN7Me1Wn
 z1Ivb4NUy2a.DodXj2IdTSpDWFFygddVxAFpaGeR4z.67HTxE10owBalyCFB
 xXWO.v3PtQuUkheNk659mKKVJHlmEgezhpLmlfNjHbneW0IhdrP1wuSgO606
 TiHElm561UAkVpC1a5k9vG7ZRxOyrcBHZ7NCeP0WMRRuZYw8TPJI.npWIyDw
 7vOwor40uiJPTmQiO_bSLSo8y9iAn6QRJ04DcU1xCQoaO4pgdR8OhIvW1Xxs
 hB9UL.5UPR1WBlwTq9y9sGiz993xSlO7vPURpHu97t3mSMm8voXNdo6sUKDn
 Y
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 8 May 2012 10:34:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Mike Frysinger <vapier@gentoo.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH v1 5/6] mm: make vmstat_update periodic run conditional
In-Reply-To: <CAOtvUMf95gmZ4ZTSpTb+5NZdEiDTg_CPtp3L2_notdz+dZWG6A@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205081033450.27713@router.home>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com> <1336056962-10465-6-git-send-email-gilad@benyossef.com> <alpine.DEB.2.00.1205071024550.1060@router.home> <4FA823A7.9000801@gmail.com> <alpine.DEB.2.00.1205071438240.2215@router.home>
 <CAOtvUMf95gmZ4ZTSpTb+5NZdEiDTg_CPtp3L2_notdz+dZWG6A@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, Gilad Ben-Yossef wrote:

> > But this would still mean that the vmstat update thread would run on an
> > arbitrary cpu. If I have a sacrificial lamb processor for OS processing
> > then I would expect the vmstat update thread to stick to that processor
> > and avoid to run on the other processor that I would like to be as free
> > from OS noise as possible.
> >
>
> OK, what about -
>
> - We pick a scapegoat cpu (the first to come up gets the job).
> - We add a knob to let user designate another cpu for the job.
> - If scapegoat cpus goes offline, the cpu processing the off lining is
> the new scapegoat.
>
> Does this makes better sense?

Sounds good. The first that comes up. If the cpu is isolated then the
first non isolated cpu is picked.

