Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab1ISUXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:23:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:21443 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab1ISUXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:23:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="50278031"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Han Pingtian <phan@redhat.com>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        edac-devel <linux-edac@vger.kernel.org>
Date: Mon, 19 Sep 2011 13:23:35 -0700
Subject: RE: [PATCH v2] Fix EDAC sdram_scrub_rate read/write failure
Thread-Topic: [PATCH v2] Fix EDAC sdram_scrub_rate read/write failure
Thread-Index: Acx212FXuuWbsC/3TfiWoACAvLTEQwAMb2rA
Message-ID: <987664A83D2D224EAE907B061CE93D5301EAB8A5C8@orsmsx505.amr.corp.intel.com>
References: <20110916105856.GA13253@hpt.nay.redhat.com>
 <20110916125326.GA1957@gere.osrc.amd.com>
 <20110919073722.GE2822@hpt.nay.redhat.com> <20110919142055.GF7814@aftab>
In-Reply-To: <20110919142055.GF7814@aftab>
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

> @Tony, do you think the above makes sense? Anything against changing
> that part of the EDAC API to say:

> Sdram memory scrubbing rate:

>     If configuration fails or memory scrubbing is not implemented,
>	the access to that attribute from userspace will fail.

Ideally we'd not have the file there at all if memory scrubbing isn't
implemented.

I like having the write fail if the driver cannot set the chosen
scrub rate ... though there seems to be some wiggle room ... scrub
rates aren't exact, the user can try to set one and then read back
to find out what the rate was actually rounded to. If you have to
read back anyway, then reading back to find out if you failed doesn't
look quite so odd (still odd, but with some sort of logic).

-Tony
