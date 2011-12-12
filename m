Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1LLSs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:48:57 -0500
Received: from mga14.intel.com ([143.182.124.37]:54304 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab1LLSsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:48:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="46398165"
From: "Luck, Tony" <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>, Don Zickus <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 12 Dec 2011 10:48:52 -0800
Subject: RE: [RFC][PATCH v3 2/3] Skip spin_locks in panic case and add
 WARN_ON()
Thread-Topic: [RFC][PATCH v3 2/3] Skip spin_locks in panic case and add
 WARN_ON()
Thread-Index: Acy45u6rvyeczNRlQ4u2K/evnn5cKQAFPqJQAACH85A=
Message-ID: <0207C53569FE594381A4F2EB66570B2A018EFB83C4@orsmsx508.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D10@USINDEVS01.corp.hds.com>
 <20111212155827.GR1669@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE46F2@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57EE46F2@USINDEVS01.corp.hds.com>
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

> if (reason == KMSG_DUMP_PANIC) {
> 	if(is_spin_locked(&psinfo->buf_lock))
> 		pr_err("lock is taken.\n");
> else {
> 	spin_lock_irqsave(&psinfo->buf_lock, flags);
> }
>
> However, this won't work for this reason.
>  - printk() must not be called in serialized path because deadlock of logbuf_lock may cause.

There is also the issue that kmsg has already computed the addresses
of useful pieces in __log_buf at this point - so any printk() we
add here is not going to be saved into pstore.  So a user relying
on pstore to see what happened, won't see any messages we add here.

-Tony
