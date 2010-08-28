Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab0H1FBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 01:01:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:24429 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab0H1FBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 01:01:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,282,1280732400"; 
   d="scan'208";a="549550027"
From: "Luck, Tony" <tony.luck@intel.com>
To: Hedi Berriche <hedi@sgi.com>
CC: Petr Tesarik <ptesarik@suse.cz>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 27 Aug 2010 22:01:18 -0700
Subject: RE: Serious problem with ticket spinlocks on ia64
Thread-Topic: Serious problem with ticket spinlocks on ia64
Thread-Index: ActGSAkqvQ6PUp1nT9SemA+ns7S8DAAI/QoQ
Message-ID: <987664A83D2D224EAE907B061CE93D53015D91D6F5@orsmsx505.amr.corp.intel.com>
References: <201008271537.35709.ptesarik@suse.cz>
 <201008272303.34228.ptesarik@suse.cz>
 <987664A83D2D224EAE907B061CE93D53015D91D45F@orsmsx505.amr.corp.intel.com>
 <201008280013.19941.ptesarik@suse.cz>
 <987664A83D2D224EAE907B061CE93D53015D91D604@orsmsx505.amr.corp.intel.com>
 <987664A83D2D224EAE907B061CE93D53015D91D645@orsmsx505.amr.corp.intel.com>
 <20100828002855.GI18967@zorg.emea.sgi.com>
In-Reply-To: <20100828002855.GI18967@zorg.emea.sgi.com>
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

>*Hasty* look seems to suggest that keeping the fancy asm bits but compiling >with
>-O2 -frename-registers makes it work equally well.
>
>Don't take my word for it though, double check it, it's been a long week and
>brain is anything but alert at this time of the night.

Yup - that makes the usermode version run just fine (no problems
in the first billion lock/unlock operations ... which is
quite a lot of wrap-arounds of the 15-bit ticket lock).

And since we already use -frename-registers when building the
kernel, no immediate help for the kernel problem. :-(

I may tinker with this test a bit to include some short random
amounts of hold-time for the lock, and delays between attempts
to acquire it (to make it look more like a contended kernel lock
and less like a continuous queue of processes trading around a
lock that is never free ... Petr's debug information definitely
showed the lock becoming free at the wraparound (lock == 0x0).

-Tony
