Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab2AKLXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:23:43 -0500
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:39277 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab2AKLXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:23:41 -0500
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:Received:From:To:CC:
   Date:Subject:Thread-Topic:Thread-Index:Message-ID:
   References:In-Reply-To:Accept-Language:Content-Language:
   X-MS-Has-Attach:X-MS-TNEF-Correlator:acceptlanguage:
   Content-Type:Content-Transfer-Encoding:MIME-Version;
  b=louoAz08mCHHUeKQTECCkrxQh+QKKTa+XY297EIcfQPqbigkRFdNxxUC
   0GDC1RGfFKOLO5cAcPQbvXSQgLtMOWSEQtr4LJ8Sp0GoW58A1+m5jlrIR
   s1xoNMdrC99B7iJ0hvsCbUz/i9+4E/9CCoPn8psMNv6+VEWp0XIWXGXk3
   NaMV5lfBd7Dwn3KpAdnfNFbVicDfBcLPkICorxLymt8OXNjcQKrwDwkae
   FpbnwKY6DnUaI2lS/asMq5DeGH4Wm;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.71,492,1320620400"; 
   d="scan'208";a="98072083"
From: "Borzenkov, Andrey" <andrey.borzenkov@ts.fujitsu.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jan 2012 12:23:37 +0100
Subject: RE: Extermeley large PageTables over 500G on kernel 2.6.32.49
 (SLES11 SP1)
Thread-Topic: Extermeley large PageTables over 500G on kernel 2.6.32.49
 (SLES11 SP1)
Thread-Index: AczQUuwR3jcOp4OISQqzYeVgqSiqRAAADooQ
Message-ID: <CB1B361E45A85849902B25342E88900501CFDC31120E@ABGEX70E.FSC.NET>
References: <CB1B361E45A85849902B25342E88900501CFDC3110D6@ABGEX70E.FSC.NET>
	 <1326278196.2767.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CB1B361E45A85849902B25342E88900501CFDC311187@ABGEX70E.FSC.NET>
 <1326280780.2767.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1326280780.2767.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0BBNpsD016793

> -----Original Message-----
> From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
> Sent: Wednesday, January 11, 2012 3:20 PM
> To: Borzenkov, Andrey
> Cc: linux-kernel@vger.kernel.org
> Subject: RE: Extermeley large PageTables over 500G on kernel 2.6.32.49
> (SLES11 SP1)
> 
> Le mercredi 11 janvier 2012 Ã  11:52 +0100, Borzenkov, Andrey a Ã©crit :
> 
> > Colleagues responsible for Oracle are reconfiguring it now.
> >
> 
> OK. Since your hardware supports 1GB hugepages, you might try to use
> them as well. Not sure if your kernel is recent enough...
> 
> cat /proc/cmdline
> ro root=LABEL=/ hugepagesz=1GB hugepages=512
> 

It says 2M so it probably is the limit.

> > > If not, its normal to eat so much memory for page tables
> > >
> > > grep VmPTE /proc/*/status
> > >
> > >
> >
> > Forgive my ignorance. I thought that
> >
> > 1. PTE is 8 bytes per page, which is 4K which gives 2K per 1M of memory
> > 2. All processes sharing the same shared memory share the same page
> table
> 
> It depends how oracle maps its SGA.
> 
> It probably uses a method disallowing page table sharing.

Do you have any reference to description of these methods so we can check?

Thank you!

> 
> Anyway, hugetables for this kind of workload is a must.
> 


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
