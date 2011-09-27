Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1I0Rqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:46:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:7266 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab1I0Rqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:46:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,450,1312182000"; 
   d="scan'208";a="67979518"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Tue, 27 Sep 2011 10:46:32 -0700
Subject: RE: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Thread-Topic: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Thread-Index: Acx9O8VcyzLltPxxQ56BdmDcsn14vgAAG0ng
Message-ID: <987664A83D2D224EAE907B061CE93D5301EE4211E3@orsmsx505.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B823@USINDEVS01.corp.hds.com>
 <20110927173413.GJ5795@redhat.com>
In-Reply-To: <20110927173413.GJ5795@redhat.com>
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

> Personally, I am not sure we want to abort here at the pstore layer, it
> should probably be aborted lower.  There isn't any reason why we can't
> continue from a pstore perspective (we can just bust the spinlock).

But do we really have much chance at getting a real dump in this case?
The pstore buf_lock is protecting the memory that the backend uses to
save the data. If we can't get the lock, then we are going to conflict
using that buffer with whoever does have the lock. So we will probably
mess up whatever data they were trying to save, as well as not managing
to save our panic data. So this isn't just a back-end issue, it is
fundamental to the pstore layer (since it depends on this back end buffer).

This is a tough call - but I'm leaning a bit towards taking this patch.

I agree with your suggestion that we need a better comment by the "return"
(and also in the change log) saying why we are not saving the panic dmesg.

-Tony 
