Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab2IDMkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:40:10 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:16977
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756809Ab2IDMkH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:40:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz98dI9371I542M1432Izz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220hbe9i1155h)
From: Liu Qiang-B32616 <B32616@freescale.com>
To: Dan Williams <djbw@fb.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Li Yang-R58472 <r58472@freescale.com>,
        Tabi Timur-B04825 <B04825@freescale.com>
Subject: RE: [PATCH v7 6/8] fsl-dma: use spin_lock_bh to instead of
 spin_lock_irqsave
Thread-Topic: [PATCH v7 6/8] fsl-dma: use spin_lock_bh to instead of
 spin_lock_irqsave
Thread-Index: AQHNdgvtqPAZuSzVUU+sPKZnww9rSpd3NSoAgAMQjjA=
Date: Tue, 4 Sep 2012 12:39:58 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70FFB92@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1344500582-11110-1-git-send-email-qiang.liu@freescale.com>
 <CAA9_cmeFamCX1u+z3fP_gxAqe83JFbY9Beqpqgb-PjRoJ8BrWA@mail.gmail.com>
In-Reply-To: <CAA9_cmeFamCX1u+z3fP_gxAqe83JFbY9Beqpqgb-PjRoJ8BrWA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.99]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
> Behalf Of Dan Williams
> Sent: Sunday, September 02, 2012 4:41 PM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; vinod.koul@intel.com; Phillips Kim-R1AAHA;
> herbert@gondor.hengli.com.au; davem@davemloft.net; arnd@arndb.de;
> gregkh@linuxfoundation.org; Li Yang-R58472; Tabi Timur-B04825
> Subject: Re: [PATCH v7 6/8] fsl-dma: use spin_lock_bh to instead of
> spin_lock_irqsave
> 
> On Thu, Aug 9, 2012 at 1:23 AM,  <qiang.liu@freescale.com> wrote:
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
> 
> It seems you are coordinating fsl-dma copy and talitos xor operations.
>  It looks like fsl-dma will be called through
> talitos_process_pending()->dma_run_dependencies(), which is
> potentially called in hard irq context.
> 
> This all comes back to the need to fix raid offload to manage the
> channels explicitly rather than the current dependency chains.
So you mean I must implement talitos_run_dependencies() and fsldma_run_dependencies()? Invoke async_tx->callback() respectively.
How about avoiding irq context in talitos?

> 
> --
> Dan


