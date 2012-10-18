Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2JRJL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:11:28 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:10492
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981Ab2JRJLY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:11:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz1102I1432I4015Izz1202h1d1ah1d2ahzzz2dh668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1155h)
X-WSS-ID: 0MC306H-02-5BC-02
X-M-MSG: 
From: "Huang, Shane" <Shane.Huang@amd.com>
To: Aaron Lu <aaron.lu@intel.com>, Robert Hancock <hancockrwd@gmail.com>
CC: Borislav Petkov <bp@amd64.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Huang, Shane" <Shane.Huang@amd.com>
Subject: RE: ata4.00: failed to get Identify Device Data, Emask 0x1
Thread-Topic: ata4.00: failed to get Identify Device Data, Emask 0x1
Thread-Index: AQHNrAgv5Iu+aHdxPUSB2JeAsougyJe8Z80AgAAi4oCAAjrnkA==
Date: Thu, 18 Oct 2012 09:11:05 +0000
Message-ID: <43EB3AB3EEFE8D43B525F4D2EAF507E107EA8AA9@SCYBEXDAG03.amd.com>
References: <20121016144932.GA24044@aftab.osrc.amd.com>
 <20121016155824.00d5b618@pyramind.ukuu.org.uk>
 <20121016151830.GB24044@aftab.osrc.amd.com> <507E0C1A.1010705@intel.com>
 <507E392E.2010305@gmail.com> <507E5671.6070504@intel.com>
In-Reply-To: <507E5671.6070504@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Agree. If NCQ does not imply support of this log page, we should
> definitely refine the check condition used here.
> 
> I suppose Shane will take care of this, but if he doesn't, I'll do that
> at a later time.

I tried word 78 bit 5(Hardware Feature Control) which does not work,
it is 0 on my HDD sample with log 30h page 08h and DevSlp supported.

Seems that word 78 bit 5 is only the sufficient condition, not the
essential condition. Do you guys have suggestion?

Quoting SATA spec:
> Word 78: Serial ATA features supported
> Bit 5 If bit 5 is set to one, then Hardware Feature Control is
> supported (see 13.10). If bit 5 is cleared to zero, then Hardware
> Feature Control is not supported and IDENTIFY DEVICE data
> word 79 bit 5 shall be cleared to zero.
> 
> If Hardware Feature Control is supported, then:
> a) IDENTIFY DEVICE data word 78 bit 5 (see 13.2.1.18) shall be
> set to one;
> b) the SET FEATURES Select Hardware Feature Control subcommand
> shall be supported (see 13.3.8);
> c) page 08h of the Identify Device Data log (see 13.7.7) shall
> be supported;


Thanks,
Shane

