Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1KBU5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:57:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:12243 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab1KBU5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="70559473"
From: "Luck, Tony" <tony.luck@intel.com>
To: "holzheu@linux.vnet.ibm.com" <holzheu@linux.vnet.ibm.com>,
        Don Zickus <dzickus@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 2 Nov 2011 13:57:26 -0700
Subject: RE: [PATCH v2] kdump: Fix crash_kexec - smp_send_stop race in panic
Thread-Topic: [PATCH v2] kdump: Fix crash_kexec - smp_send_stop race in panic
Thread-Index: AcyZRvGsh57uBKQGQiu0mWK08alnCAAWg/CQ
Message-ID: <987664A83D2D224EAE907B061CE93D5301F527F980@orsmsx505.amr.corp.intel.com>
References: <1319639649.3321.11.camel@br98xy6r>
	 <20111028161143.e5ebf617.akpm@linux-foundation.org>
	 <1320055036.2796.8.camel@br98xy6r>
	 <20111031033948.a0edb7f3.akpm@linux-foundation.org>
	 <1320064459.2796.26.camel@br98xy6r> <20111101200420.GN17705@redhat.com>
 <1320228239.2776.14.camel@br98xy6r>
In-Reply-To: <1320228239.2776.14.camel@br98xy6r>
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

> Instead of introducing the panic lock, as an alternative we could move
> smp_send_stop() to the beginning of panic(). Eric told me that the
> function is currently "insufficiently reliable" for that, but perhaps we
> could make it more reliable.

That's tough to do.  We are in panic because something went horribly
wrong somewhere in the kernel - so we can make few assumptions about
which subsystems are still working. In the worst case (for this example)
our panic was caused by a failure in the code that sends cross-processor
interrupts ... so calling that same code to stop the other cpus is
likely to run into the same problem - perhaps causing a nested panic.

So what looks like a good fix for some panic scenarios actually makes
others worse.

-Tony
