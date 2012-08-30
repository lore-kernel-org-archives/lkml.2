Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab2H3GVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 02:21:33 -0400
Received: from [216.32.181.182] ([216.32.181.182]:52593 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab2H3GVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 02:21:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I936eI542M1432Izz1202hzzz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah107ahbe9i1155h)
From: Liu Qiang-B32616 <B32616@freescale.com>
To: Dan Williams <djbw@fb.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: RE: [PATCH v7 0/8] Raid: enable talitos xor offload for improving
 performance
Thread-Topic: [PATCH v7 0/8] Raid: enable talitos xor offload for improving
 performance
Thread-Index: AQHNdge1qBCFxaP1ski951Lb3NNwmpdSCXOAgAb6eMCAARMaAIAWq2TggACRSoCAAKiWQA==
Date: Thu, 30 Aug 2012 06:20:05 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70FC695@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1344500375-8457-1-git-send-email-qiang.liu@freescale.com>
	 <20120809170307.GG14264@ovro.caltech.edu>
	 <BCB48C05FCE8BC4D9E61E841ECBE6DB70E3D47@039-SN2MPN1-013.039d.mgd.msft.net>
	 <CAA9_cme4tHrx14JaSaHwgcGq79qQK5bv8E205fbC3ega5OpUiQ@mail.gmail.com>
	 <BCB48C05FCE8BC4D9E61E841ECBE6DB70FC3CA@039-SN2MPN1-011.039d.mgd.msft.net>
 <1346251975.27020.2.camel@localhost.localdomain>
In-Reply-To: <1346251975.27020.2.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.99]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7U6MXkT023946

> -----Original Message-----
> From: Dan Williams [mailto:djbw@fb.com]
> Sent: Wednesday, August 29, 2012 10:53 PM
> To: Liu Qiang-B32616
> Cc: vinod.koul@intel.com; arnd@arndb.de; herbert@gondor.apana.org.au;
> gregkh@linuxfoundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; linux-crypto@vger.kernel.org; Ira W. Snyder
> Subject: Re: [PATCH v7 0/8] Raid: enable talitos xor offload for
> improving performance
> 
> On Wed, 2012-08-29 at 11:15 +0000, Liu Qiang-B32616 wrote:
> > Hi Dan,
> >
> > Ping?
> > Can you apply these patches? Thanks.
> >
> 
> I'm working my way through them.
> 
> The first thing I notice is that xor_chan->desc_lock is taken
> inconsistently.  I.e. spin_lock_irqsave() in talitos_process_pending()
> and spin_lock_bh() everywhere else.  Have you run these patches with
> lockdep?
Thanks for your reply.
LOCKDEP is enabled as you suggested, there is not any info about "inconsistent lock state" displayed.
I don't know whether it's enough.

I'm confused about the attribute of DMA_INTERRUPT, my understanding is this interface is only used to trigger an interrupt (make sure all former operations are finished before switching to other channels), but fsl-dma will trigger an interrupt by "Programmed Error". I'm wondering whether other hardware are same with fsl-dma (the interrupt is a normal interrupt, but not an error) i.e. xscale-iop?
If other hardware also trigger an interrupt by an abnormal error, maybe my patch 2/8 should be reverted because it violates the rules of this attribute.

BTW, could you please reply in the patch if you have any comments. Thanks.

> 
> --
> Dan
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
