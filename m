Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966312Ab2EOSgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:36:01 -0400
Received: from mtv-iport-1.cisco.com ([173.36.130.12]:17946 "EHLO
	mtv-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966285Ab2EOSf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:35:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAMChsk+rRDoG/2dsb2JhbAA6CrQAgQeCFQEBAQMBEgEUCQo/BQcEAgEIEQQBAQsGFwEGAUUJCAEBBBMIGodnBJsBoBWLHA+FDmMEiGSbcIFpgwk
X-IronPort-AV: E=Sophos;i="4.75,595,1330905600"; 
   d="scan'208";a="41791233"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: CFA 4.0 patch
Date: Tue, 15 May 2012 11:35:57 -0700
Message-ID: <4E75C4FECC27A44E9F7E0737D71946900F686DB5@xmb-sjc-21e.amer.cisco.com>
In-Reply-To: <20120515153818.3e70d845@pyramind.ukuu.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: CFA 4.0 patch
Thread-Index: Ac0yp/iE0xcpC4j/RVGEln914YscWgAIEukg
References: <4E75C4FECC27A44E9F7E0737D71946900F686C61@xmb-sjc-21e.amer.cisco.com> <20120515153818.3e70d845@pyramind.ukuu.org.uk>
From: "Andre Hedrick (anhedric)" <anhedric@cisco.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 May 2012 18:35:58.0467 (UTC) FILETIME=[921AFD30:01CD32C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

You betcha, otherwise I would not have a case.

STEC configed to MWDMA4 (Max reported as UDMA/66)

-> ShowCFDriveInfo()
CompactFlash Identify Drive (0xEC)
Word 0: 0x044A
Word 1: 0x07C2
Word 2: 0x0000
Word 3: 0x0010
Word 4: 0x0000
Word 5: 0x0200
Word 6: 0x003F
Word 7: 0x001E
Word 8: 0x8BE0
Word 9: 0x0000
Word 10: 0x2053

Viking configed to MWDMA2 (Max reported as MWDMA2)

-> ShowCFDriveInfo()
CompactFlash Identify Drive (0xEC)
Word 0: 0x044A
Word 1: 0x07AA
Word 2: 0x0000
Word 3: 0x0010
Word 4: 0x0000
Word 5: 0x0240
Word 6: 0x003F
Word 7: 0x001E
Word 8: 0x2D60
Word 9: 0x0000
Word 10: 0x564D

Now I only have data for the 0x044A case, but it is on par with the CFA
4.0 spec that I can send you if you want a copy.

Oh yeah, just so you know I am coming out of retirement and tinkering
with the other insanity, security.

Cheers,
Andre

Linux Former-ATA/SATA guy
      ^^^^^^
      Changed just for you friend.

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Tuesday, May 15, 2012 7:38 AM
To: Andre Hedrick (anhedric)
Cc: linux-kernel@vger.kernel.org
Subject: Re: CFA 4.0 patch

> 044Ah: This is the alternate value of Word 0 turns on ATA device and
> turns off Removable Media and Removable Device while 	preserving all
> Retired bits in the word.
> 
> 0040h: This is the alternate value of Word 0 turns on ATA device and
> turns off Removable Media and Removable Device while 	zeroing all
> Retired bits in the word
> 
> Cheers,
> Andre
> --------------------
> The Linux X-ATA/SATA guy
      ^former ;)


> --- linux-2.6.32.orig/include/linux/ata.h	Mon May 14 15:48:24 2012
> +++ linux-2.6.32/include/linux/ata.h	Mon May 14 15:51:42 2012
> @@ -819,6 +819,10 @@
>  {
>  	if (id[ATA_ID_CONFIG] == 0x848A)	/* Traditional CF */
>  		return 1;
> +	if (id[ATA_ID_CONFIG] == 0x044A)	/* Alternative CF w/
> removable turned off, preserving retired bits */
> +		return 1;
> +	if (id[ATA_ID_CONFIG] == 0x0040)	/* Alternative CF w/
> removable turned off, zeroing retired bits*/
> +		return 1;

Do you have test case hardware for this that fails the other checks.
I've
never ever come across any. I don't believe it exists at this point.

Also 2.6.32 is some years ago 8)

Alan
