Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab0FDWuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 18:50:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:44590 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab0FDWuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 18:50:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,363,1272870000"; 
   d="scan'208";a="804883524"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Dave Young <hidave.darkstar@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Fri, 4 Jun 2010 15:50:41 -0700
Subject: RE: linux-next: Tree for June 3
Thread-Topic: linux-next: Tree for June 3
Thread-Index: AcsEMsfjJb3LN2sZRwWRDfzzClcI6gAAxBiw
Message-ID: <987664A83D2D224EAE907B061CE93D530114C3DE4D@orsmsx505.amr.corp.intel.com>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au>
 <AANLkTilr92GkR8bfgyjtb8ToYEEAv4oCsFsfsy04HJRU@mail.gmail.com>
 <AANLkTim6v2s-Q5BndAKLOZKaA1wYgbU3UKJwNy-6Jkki@mail.gmail.com>
 <201006032222.57411.rusty@rustcorp.com.au>
 <AANLkTikN_3oLIFQ0CRiLwXUV79myy_aqriezdCgnZHFT@mail.gmail.com>
 <alpine.LFD.2.00.1006041255210.8175@i5.linux-foundation.org>
 <987664A83D2D224EAE907B061CE93D530114C3DC47@orsmsx505.amr.corp.intel.com>
 <alpine.LFD.2.00.1006041452130.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006041452130.8175@i5.linux-foundation.org>
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

> Does this fix it? I stopped looking for other possible causes when I found 
> this one.

It gets rid of the oops. So that's good.  Something is still
hokey in linux-next land though because no modules get loaded.
So no ehci/uhci available :-(

No obvious looking error messages on the console.

-Tony
---
 kernel/module.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 69a3f12..9a0b275 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2653,9 +2653,10 @@ static struct module *load_module(void __user *umod,
 	module_unload_free(mod);
  free_module:
 	module_deallocate(mod, &info);
+	mod = ERR_PTR(err);
  free_copy:
 	free_copy(&info);
-	return ERR_PTR(err);
+	return mod;
 }
 
 /* Call module constructors. */
