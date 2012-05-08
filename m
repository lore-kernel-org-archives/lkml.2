Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab2EHPYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:24:36 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:33775 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753843Ab2EHPYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:24:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: raPN17kVM1lhtDT_e5glMBtfr5rjjZDismeJc3n7ENEmwld
 W4U0I6PQbfm2LiJK2oTNP4DeWNcX5wXiQinAGynNdu3K1sWXgNEDsUctjx2V
 Bx7l_th1.UQUBJDYOdrDtIV98IkV3JZNfJSyZAKlmjpVN7nAF0KTxxQggatg
 jjYe32SJlhsKhr7_Q46kVpX9j1wXTpunWTR9lecD8qxkS6iRmdhPNkOASarJ
 8w990wboYLWP8Cf_5DwapW3OMzJRdNyom3uQv5bQ2S1m0yBG8WAAWMHl3rPJ
 NXZcRX9gltZYnUCjaNMoHvZkxKSH1iY0LYJSYku70y7b6fj9RGj2xfGgHTak
 Ms4CZhFpf1kvgOJL.jaMnY5q0dna4vTA_hLTBPBBWS_9XO3Qg1HsTIK_1plh
 8
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 8 May 2012 10:24:29 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>,
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
In-Reply-To: <CAOtvUMeF6Xi-sOYZkJuAF0=jzqUHBNEMZU4BD=K3-yqQbdQxUw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205081020340.27713@router.home>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com> <1336056962-10465-6-git-send-email-gilad@benyossef.com> <alpine.DEB.2.00.1205071024550.1060@router.home> <CAOtvUMeF6Xi-sOYZkJuAF0=jzqUHBNEMZU4BD=K3-yqQbdQxUw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, Gilad Ben-Yossef wrote:

> My line of thought was that if we explicitly choose a scapegoat cpu we
> and the user need to manage this - such as worry about what happens if
> the scapegoats is offlines and let the user explicitly designate the
> scapegoat cpu thus creating another knob, and worrying about what
> happens if the user designate such a cpu but then it goes offlines...

The scapegoat can be chosen on boot. One can f.e. create a file in

/sys/device/syste/cpu called "scapegoat" which contains the number of the
processor chosen. Then one can even write a userspace daemon to automatize
the moving of the processing elsewhere. Could be integrated into something
horrible like irqbalance f.e.

> I figured the user needs to worry about other unbounded work items
> anyway if he cares about where such things are run in the general case,
> but using isolcpus for example.

True. So the scapegoat heuristic could be to pick the first
unisolated cpu.

> The same should be doable with cpusets, except that right now we mark
> unbounded workqueue worker threads as pinned even though they aren't. If
> I understood the discussion, the idea is exactly to stop users from
> putting these threads in non root cpusets. I am not 100% sure why..

Not sure that cpusets is a good thing to bring in here because that is an
optional feature of the kernel and tying basic functionality like this
to cpuset support does not sound right to me.
