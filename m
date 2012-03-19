Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162143Ab2CSQ3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:29:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:28362 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161679Ab2CSQ3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:29:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="79209761"
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: Nix <nix@esperi.org.uk>
CC: Chris Boot <bootc@bootc.net>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: RE: [E1000-devel] e1000e interface hang on 82574L
Thread-Topic: [E1000-devel] e1000e interface hang on 82574L
Thread-Index: AQHNBewRGQ5ZRlcGs0Cvqye8ikiYb5ZxzUdw
Date: Mon, 19 Mar 2012 16:29:03 +0000
Message-ID: <9BBC4E0CF881AA4299206E2E1412B6260E512FB9@ORSMSX102.amr.corp.intel.com>
References: <4EFA4024.5000909@bootc.net>
	<FCF3184D-CE4F-471C-B66C-0F671795FD3C@bootc.net>
	<9BBC4E0CF881AA4299206E2E1412B626017762@ORSMSX102.amr.corp.intel.com>
	<4F048861.8070501@bootc.net> <4F12B42C.9030803@bootc.net>
	<9BBC4E0CF881AA4299206E2E1412B62621F0B1@ORSMSX102.amr.corp.intel.com>
	<4F144A76.3050703@bootc.net> <4F64B4E2.20208@bootc.net>
	<4F64CFCB.7060702@bootc.net>
	<9BBC4E0CF881AA4299206E2E1412B6260E512E0C@ORSMSX102.amr.corp.intel.com>
 <87r4wova0b.fsf@spindle.srvr.nix>
In-Reply-To: <87r4wova0b.fsf@spindle.srvr.nix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Nix [mailto:nix@esperi.org.uk]
>Sent: Monday, March 19, 2012 9:20 AM
>To: Wyborny, Carolyn
>Cc: Chris Boot; e1000-devel@lists.sourceforge.net; netdev; lkml
>Subject: Re: [E1000-devel] e1000e interface hang on 82574L
>
[...]

>you'll see that I tested that, and it doesn't work :( even if it did
>work, it shouldn't be needed: the driver attempts to turn off PCIe ASPM
>on affected NICs, and fails, apparently because *something* turns it
>back on again.
>
>--
>NULL && (void)

The driver attempts to disable L0s state, not the entire feature.  It is also required that the device upstream on the bus from the 82574L have this disabled.  Yes, I agree there appears to be something in the os that either ren-enables or fails to disable the feature on the upstream device, as desired.  Platforms/systems also appear to vary in this regard, so the solutions may vary a bit as well.  

Its worth trying your solution as well if what I suggested doesn't work, but there is not one solution that fits all, unfortunately.

Thanks,

Carolyn

Carolyn Wyborny
Linux Development
LAN Access Division
Intel Corporation



