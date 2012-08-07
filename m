Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab2HGCqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:46:12 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:3925
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999Ab2HGCqK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:46:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -13
X-BigFish: VS-13(zz98dI9371I542M1432I11f6Nzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Liu Qiang-B32616 <B32616@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dan.j.williams@gmail.com" <dan.j.williams@gmail.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
        "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Li Yang-R58472 <r58472@freescale.com>,
        Tabi Timur-B04825 <B04825@freescale.com>
Subject: RE: [PATCH v6 6/8] fsl-dma: use spin_lock_bh to instead of
 spin_lock_irqsave
Thread-Topic: [PATCH v6 6/8] fsl-dma: use spin_lock_bh to instead of
 spin_lock_irqsave
Thread-Index: AQHNc8LtMyyKGbodvEy0WKjsKQrKbJdNAYuAgACilsA=
Date: Tue, 7 Aug 2012 02:45:45 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70E1020@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1344249361-10263-1-git-send-email-qiang.liu@freescale.com>
 <201208061157.17667.arnd@arndb.de>
In-Reply-To: <201208061157.17667.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.94]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, August 06, 2012 7:57 PM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org;
> dan.j.williams@intel.com; linux-kernel@vger.kernel.org;
> dan.j.williams@gmail.com; vinod.koul@intel.com; Phillips Kim-R1AAHA;
> herbert@gondor.hengli.com.au; davem@davemloft.net;
> gregkh@linuxfoundation.org; Li Yang-R58472; Tabi Timur-B04825
> Subject: Re: [PATCH v6 6/8] fsl-dma: use spin_lock_bh to instead of
> spin_lock_irqsave
> 
> On Monday 06 August 2012, qiang.liu@freescale.com wrote:
> >
> > From: Qiang Liu <qiang.liu@freescale.com>
> >
> > The use of spin_lock_irqsave() is a stronger locking mechanism than is
> > required throughout the driver. The minimum locking required should be
> > used instead. Interrupts will be turned off and context will be saved,
> > there is needless to use irqsave.
> >
> > Change all instances of spin_lock_irqsave() to spin_lock_bh().
> > All manipulation of protected fields is done using tasklet context or
> > weaker, which makes spin_lock_bh() the correct choice.
> >
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Dan Williams <dan.j.williams@gmail.com>
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Li Yang <leoli@freescale.com>
> > Cc: Timur Tabi <timur@freescale.com>
> > Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> > Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> You could actually change the use of spin_lock_bh inside of the tasklet
> function (dma_do_tasklet) do just spin_lock(), because softirqs are
> already disabled there, but your version is also ok.
Yes, you are right, it will disable softirq.
Thank you very much.


