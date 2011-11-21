Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab1KUVnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:43:15 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:44055 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753405Ab1KUVnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:43:14 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Jqd3uMwVM1l_0G8odJcDw293QElFxufsslPcLoUwoCigwSJ
 ylJOe6NYeeZ40XrenmjdcALbPg_4hhudvxOaHsQyBvF2FKd7lu0mUzItmNQd
 YnZJiOvVIUVMd6a_NMHxnRVpxBQT6R9CbV.I1hhs31ygP7L_bhtJhfsMA0P5
 4_wYGjbkjDMIVLSmSiDTuqoZpyj4wl7ksdyYyCUnHALX5vLilfq05RWD7RBT
 nxSksPUDXqeg2EF2crg4vBfuvKwmZ4IOXH4nMVAsHx8prBBLHGgsMjxz.4kj
 eBlSz2PUeDR_2r3ODxU7ha.yDfbzP6CGm8Ffshs2di_l3wyPFQuIk2k6mpyT
 OjRkMvbGD_oKii0UeUDg1VlT6GPWAZ57IjDQeJ1vGbSYuQQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 21 Nov 2011 15:43:10 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Eric Dumazet <eric.dumazet@gmail.com>, "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Christian Kujau <lists@nerdbynature.de>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
In-Reply-To: <CAOJsxLGLZ23momLxidvhC+2LCtmnwmPMS2ASdke8V8gGFGa=AA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1111211539420.10548@router.home>
References: <20111121131531.GA1679@x4.trippels.de> <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20111121153621.GA1678@x4.trippels.de> <1321890510.10470.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20111121161036.GA1679@x4.trippels.de>
 <1321894353.10470.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20111121173556.GA1673@x4.trippels.de> <1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20111121185215.GA1673@x4.trippels.de>
 <20111121195113.GA1678@x4.trippels.de> <1321907275.13860.12.camel@pasglop> <CAOJsxLGLZ23momLxidvhC+2LCtmnwmPMS2ASdke8V8gGFGa=AA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011, Pekka Enberg wrote:

> Does CONFIG_SLAB make all the issues go away or are you still able to
> reproduce corruption with it? I'm asking because we have the per-cpu
> partial list patches in 3.2-rc1 and I'd like to rule them out as a
> suspect.

SLAB does not have the same capabilities to detect corruption.

You can disable most the cpu partial functionality by setting

	/sys/kernel/slab/*/cpu_partial

to 0


