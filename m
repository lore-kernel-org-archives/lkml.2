Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1I1WbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:31:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:58987 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab1I1WaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:30:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="56930027"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>
CC: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 28 Sep 2011 15:30:04 -0700
Subject: RE: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Thread-Topic: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Thread-Index: Acx95pHvKOHCg4TSTxyNGO3CgwNKbwARvafw
Message-ID: <987664A83D2D224EAE907B061CE93D5301EE4B23D6@orsmsx505.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B823@USINDEVS01.corp.hds.com>
 <20110927173413.GJ5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE4211E3@orsmsx505.amr.corp.intel.com>
 <20110927175919.GK5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE421365@orsmsx505.amr.corp.intel.com>
 <20110928135727.GQ5795@redhat.com>
In-Reply-To: <20110928135727.GQ5795@redhat.com>
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

> That should be up to the backend, no?  ERST has two modes, only one which
> has a state machine.  The other is NVRAM which can probably handle
> simultaneous writes.  And I believe the EFI back-end can handle that as
> well.  That is why I was suggesting that the back-end return a failure.

ERST tries to provide a lot of flexibility to the platform on how to
make persistent space available.  If the platform has directly addressable
NVRAM - then ERST can point to it, so the "save" operation degenerates into
a simple write to the next available block.  But this isn't required. The
ERST buffer may be in normal memory, and the actions in the state machine
may trigger an SMI to make the BIOS copy it away to some safe place, or
the actions could ping a doorbell on a management controller which could
initiate a DMA transfer to pick up the buffer from memory.

-Tony
