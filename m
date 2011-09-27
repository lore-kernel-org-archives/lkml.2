Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab1I0TCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 15:02:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:18998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab1I0TCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 15:02:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,450,1312182000"; 
   d="scan'208";a="56278335"
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
Date: Tue, 27 Sep 2011 12:02:38 -0700
Subject: RE: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Thread-Topic: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Thread-Index: Acx9P00IirVS6MeSR6qbrDOtpR4M0QAB+ahA
Message-ID: <987664A83D2D224EAE907B061CE93D5301EE421365@orsmsx505.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B823@USINDEVS01.corp.hds.com>
 <20110927173413.GJ5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE4211E3@orsmsx505.amr.corp.intel.com>
 <20110927175919.GK5795@redhat.com>
In-Reply-To: <20110927175919.GK5795@redhat.com>
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

> Ok.  Do we care?  I assumed the panic data would be more
> relevant/interesting than whatever pstore was doing before (like loading
> previous log files).

Yes we care - saving panic data is most likely the single most important
thing that pstore does.  I just have severe doubts that it will actually
save anything useful if we just blindly continue if we can't get the lock.

What actually happens next will be dependent on the back-end. For
the state machine in ERST, one possible outcome is a hang. For many
people a hang is considered worse than a panic.

> I assumed we are just overwriting the buffer with the current data, so
> unless the other cpu is chugging along while this cpu is in panic, the new
> data shouldn't get corrupted, no?

I really have no idea what *will* happen.  Lots of things are possible, only
some of them are desirable.

Is this patch based on a real-life case of a system deadlocking? I'd
like to know if we are just talking around the theoretical case that
the lock may be held at panic time - or something that has actually been
seen in real life.

-Tony
