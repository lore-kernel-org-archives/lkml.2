Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab0JAOWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:22:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:44156 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab0JAOWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:22:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,266,1283756400"; 
   d="scan'208";a="842738007"
From: "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
CC: "Wu, Xia" <xia.wu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhu, Daniel" <daniel.zhu@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>
Date: Fri, 1 Oct 2010 07:22:10 -0700
Subject: RE: unnecessary timer interrupt of slab.c and bdi tasks when the
	system is in sleep state
Thread-Topic: unnecessary timer interrupt of slab.c and bdi tasks when the
	system is in sleep state
Thread-Index: Acthc9eCBlreOALgQhag8m7/EKnCaQAABmEg
Message-ID: <26E9B811E137AB4B95200FD4C950886BA64E0E96@orsmsx507.amr.corp.intel.com>
References: <A24AE1FFE7AEC5489F83450EE98351BF221878E0FB@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1009300908050.27201@router.home>
 <20101001141932.GA5467@nowhere>
In-Reply-To: <20101001141932.GA5467@nowhere>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I found some unnecessary timer interrupts when the system enter
> sleep state.
> > > (1)     /mm/slab.c
> > > cache_reap() clean up on allocated memory every 2s. If the system
> is in sleep state, the system is waked-up when this timer expires. In
> fact,
> > > there isn't more slabs to been cleaned up in sleep state.
> >
> > Right. We could switch off the timer when idle without much of an
> issue.
> > The expiration of the caches wont occur and so we will have stale
> objects
> > on the queues when we exit sleep state. You could flush the queues
> before
> > switching off the timers?
> 
> 
> May be flushing the queue everytime we enter nohz is too much, as that
> can
> happen very often?
> 


the slab timer is already deferable... which means it won't hit while the system is completely idle.
I think this part of the original report is a red herring found on an older kernel.

