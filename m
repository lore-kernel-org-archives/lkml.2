Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0KEL5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 07:57:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:43079 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab0KEL5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 07:57:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,301,1286175600"; 
   d="scan'208";a="854463077"
From: "Luck, Tony" <tony.luck@intel.com>
To: Kapil Arya <kapil@ccs.neu.edu>, Oren Laadan <orenl@cs.columbia.edu>
CC: "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>,
        Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 5 Nov 2010 04:57:33 -0700
Subject: RE: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Thread-Topic: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Thread-Index: Act8nXj7fdb2OyF+Qdy6MyVyrKIrQwAQi0dQ
Message-ID: <987664A83D2D224EAE907B061CE93D53016485FE6E@orsmsx505.amr.corp.intel.com>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
	<4CD08419.5050803@kernel.org> <4CD23087.30900@cs.columbia.edu>
 <AANLkTikgPKeZUih6_12JWSNy=Vsz2UP9HR7wHOz4q6ST@mail.gmail.com>
In-Reply-To: <AANLkTikgPKeZUih6_12JWSNy=Vsz2UP9HR7wHOz4q6ST@mail.gmail.com>
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

> Oren noted that sometimes it's important to stop the process only
> for a few milliseconds while one checkpoints. In DMTCP, we do that
> by configuring with --enable-forked-checkpointing. This causes us
> to fork a child process taking advantage of copy-on-write and then
> checkpoint the memory pages of the child while the parent continues
> to execute.

Interesting ... but while the process is only stopped for the duration
of the fork, it may be taking COW faults on almost every page it
touches.  I think this will not work well for large HPC applications
that allocate most of physical memory as anonymous pages for the
application. It may even result in an OOM kill if you don't complete
the checkpoint of the child and have it exit in a timely manner.

-Tony


