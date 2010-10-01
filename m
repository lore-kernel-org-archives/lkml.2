Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab0JAPU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 11:20:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:4730 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab0JAPUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 11:20:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,267,1283756400"; 
   d="scan'208";a="330987403"
From: "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        "Wu, Xia" <xia.wu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhu, Daniel" <daniel.zhu@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>
Date: Fri, 1 Oct 2010 08:20:22 -0700
Subject: RE: unnecessary timer interrupt of slab.c and bdi tasks when the
	system is in sleep state
Thread-Topic: unnecessary timer interrupt of slab.c and bdi tasks when the
	system is in sleep state
Thread-Index: Acthdg3Rw0TUEfOmTDa/90iFujB9lwABgeVA
Message-ID: <26E9B811E137AB4B95200FD4C950886BA64E0ECD@orsmsx507.amr.corp.intel.com>
References: <A24AE1FFE7AEC5489F83450EE98351BF221878E0FB@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1009300908050.27201@router.home>
 <20101001141932.GA5467@nowhere>
 <26E9B811E137AB4B95200FD4C950886BA64E0E96@orsmsx507.amr.corp.intel.com>
 <20101001143546.GA6194@nowhere>
In-Reply-To: <20101001143546.GA6194@nowhere>
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


> > the slab timer is already deferable... which means it won't hit while
> the system is completely idle.
> 
> 
> I'm not sure what you mean exactly. The slab work seems to be scheduled
> strictly
> periodically, unless the cpu goes offline. But I can't find any nohz-
> wise adaptation.
> 

                INIT_DELAYED_WORK_DEFERRABLE(reap_work, cache_reap);

that will cause it to only run when the cpu is actually idle...

