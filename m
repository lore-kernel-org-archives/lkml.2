Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab1EDVkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:40:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:56302 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1EDVkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:40:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,316,1301900400"; 
   d="scan'208";a="638047630"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Date: Wed, 4 May 2011 14:40:37 -0700
Subject: RE: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Thread-Topic: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Thread-Index: AcwKKL8lLumO+P+7QCCi8YuZpZWUAgAedDxA
Message-ID: <987664A83D2D224EAE907B061CE93D5301C53C9B31@orsmsx505.amr.corp.intel.com>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-5-git-send-email-bp@amd64.org>
 <20110503064505.GF7751@elte.hu> <20110503072302.GC18979@aftab>
 <987664A83D2D224EAE907B061CE93D5301C53670E0@orsmsx505.amr.corp.intel.com>
 <20110504065843.GC20828@elte.hu>
In-Reply-To: <20110504065843.GC20828@elte.hu>
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

> Yes, i definitely think a gateway to printk would be useful, so that the system 
> can log MCE events the syslog way as well. This probably makes sense for 
> persistent events in general, not just MCE events.

s/as well/instead/ ??? If the persistent event mechanism is correctly feeding
data to a mart daemon, I don't think we need any printk() chatter. It is only
if this is not working that we'd want to see some console logging.

I agree that this isn't just a property of the MCE persistent event - other
persistent events would very likely want a way to shout for help if the events
are piling up with no listener.

> printk itself could become a persistent event. (Transparently and without 
> breaking compatible syslogd/klogd functionality.)

Someone from Google was very skeptical of printk() remaining stable from
release to release ... a big issue when you have some heavy duty infrastructure
trying to parse and consume these messages.  We should really consider such
stuff a user visible ABI, and thus not subject to random breakage - which
is a radical departure from our current attitude to printk().

-Tony
