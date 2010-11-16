Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0KPRln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:41:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:55346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972Ab0KPRlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:41:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,206,1288594800"; 
   d="scan'208";a="574368311"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Michal Hocko <mhocko@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 16 Nov 2010 17:41:33 +0000
Subject: RE: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Thread-Topic: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Thread-Index: AcuFmXA4XgziEnvNRsGD2v5u3+uaUwAG/ZVQ
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
References: <20101116142027.GC19247@tiehlicka.suse.cz>
In-Reply-To: <20101116142027.GC19247@tiehlicka.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> it seems that your patch (5ada28bf76752e33dce3d807bf0dfbe6d1b943ad)
> causes the following compilatation error:
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `led_trigger_set':
> drivers/leds/led-triggers.c:116: undefined reference to
> `led_brightness_set'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> AFAICS, led_brightness_set is defined in drivers/leds/led-class.c which
> is compiled only if CONFIG_LEDS_CLASS is configured which is not my
> case (after make oldconfig with all default values from 37-rc1).
> 
> I am not sure what is the right solution whether CONFIG_LEDS_TRIGGERS
> should depend on CONFIG_LEDS_CLASS or the patch should be reverted.
> 
> My config is attached, if somebody need it.

Hmm, we did find that, and I made a patch to fix up the Kconfig, that apparently hasn't made it in? Bit confused now.

johannes
--------------------------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland 
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

