Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0KWJfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:35:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:47686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab0KWJf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:35:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,241,1288594800"; 
   d="scan'208";a="576643421"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
CC: Arnd Hannemann <arnd@arndnet.de>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Date: Tue, 23 Nov 2010 09:35:23 +0000
Subject: RE: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Thread-Topic: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Thread-Index: AcuK71ghC740hQcyTTihZDbdAO+2PwAAjRpA
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501D41ED81C@irsmsx504.ger.corp.intel.com>
References: <C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
 <20101118082454.GC15928@tiehlicka.suse.cz>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
 <4CEAA151.7050404@arndnet.de> <20101123063200.GA23907@elte.hu>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
 <20101122233654.117eef93.akpm@linux-foundation.org>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED75C@irsmsx504.ger.corp.intel.com>
 <20101123075742.GA28714@elte.hu>
 <20101123000232.e51b99b7.akpm@linux-foundation.org>
 <20101123091756.GA22530@elte.hu>
In-Reply-To: <20101123091756.GA22530@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAN9Zd6l005307

> It fails to build on x86 64-bit allmodconfig:
> 
> drivers/leds/led-triggers.c:39:20: error: â€˜TRIG_NAME_MAXâ€™ undeclared
> (first use in this function)

Grr. I give up on the modular thing ...

There are a whole bunch of ifdefs on TRIGGERS, which need to be
|| modular, but the easier thing is to remove the bool->tristate
changes from my patch.

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
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
