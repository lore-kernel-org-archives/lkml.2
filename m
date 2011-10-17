Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1JQQ4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:56:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:13200 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab1JQQ4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:56:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,360,1315206000"; 
   d="scan'208";a="78918295"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 17 Oct 2011 09:56:50 -0700
Subject: RE: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Topic: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Index: AcyM5yprfJgfZyibR+unNyzlM4jHnAABfJcw
Message-ID: <987664A83D2D224EAE907B061CE93D5301EE911C66@orsmsx505.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
 <20111017160904.GG5795@redhat.com>
In-Reply-To: <20111017160904.GG5795@redhat.com>
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

> All this lock busting probably isn't pretty and causes one to reflect what
> is going on here.  But as long as we are going to keep the kmsg_dump
> design, changes like this seem necessary to make sure the locking stays
> sane(r) for now.

So should we let the back-end know that locks have been busted?  I worry
that we'll get through the pstore layer by blasting away at any locks that
get in our way - but then the backend (which may well have been written on
the assumption that pstore serialized calls to it) will not do anything
useful (and may cause its own hang).

-Tony
