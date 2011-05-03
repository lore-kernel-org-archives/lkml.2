Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1ECRR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:17:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:54134 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab1ECRR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:17:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,310,1301900400"; 
   d="scan'208";a="637287485"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Date: Tue, 3 May 2011 10:17:50 -0700
Subject: RE: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Thread-Topic: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Thread-Index: AcwJYwQ5zzi0x4R8QjSENsTdfI1XIwAUjDag
Message-ID: <987664A83D2D224EAE907B061CE93D5301C53670E0@orsmsx505.amr.corp.intel.com>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-5-git-send-email-bp@amd64.org>
 <20110503064505.GF7751@elte.hu> <20110503072302.GC18979@aftab>
In-Reply-To: <20110503072302.GC18979@aftab>
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

> Ok, the problem I see with it is that people without a RAS daemon
> running will have the mechanism collecting MCEs in the background, using
> up resources (4 pages per CPU is the buffer) and not doing anything (in
> the best case that is, when we're not broken otherwise).

Can the kernel detect whether anyone is listening to the
persistent MCE event?  If so, then the kernel could printk()
something to let the user with no RAS daemon (or a dead
daemon) that stuff is happening that they might like to
know about.

Probably make some sense to delay such a message (so that in
the boot case we give the daemon a chance to get started before
complaining that it hasn't shown up for work).

-Tony
