Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab2BMKDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 05:03:05 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:5462 "EHLO
	VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753355Ab2BMKDD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 05:03:03 -0500
X-SpamScore: -16
X-BigFish: VS-16(zzbb2dI9371I542M1432N98dK4015L13e6Kzz1202hzz8275bh8275dha509lz2dh2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Qiang-B32616 <B32616@freescale.com>
To: Jeff Garzik <jgarzik@pobox.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH V2] fsl-sata: I/O load balancing
Thread-Topic: [PATCH V2] fsl-sata: I/O load balancing
Thread-Index: AQHM1xm3uRGstrv3dUuwBzDFf6JWsJY2+UOAgAPFcwA=
Date: Mon, 13 Feb 2012 10:02:58 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB7024E94@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1327025958-10605-1-git-send-email-qiang.liu@freescale.com>
 <4F356139.9000609@pobox.com>
In-Reply-To: <4F356139.9000609@pobox.com>
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
> From: linux-ide-owner@vger.kernel.org [mailto:linux-ide-
> owner@vger.kernel.org] On Behalf Of Jeff Garzik
> Sent: Saturday, February 11, 2012 2:26 AM
> To: Liu Qiang-B32616
> Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org; linuxppc-
> dev@lists.ozlabs.org
> Subject: Re: [PATCH V2] fsl-sata: I/O load balancing
> 
> On 01/19/2012 09:19 PM, qiang.liu@freescale.com wrote:
> > From: Qiang Liu<qiang.liu@freescale.com>
> >
> > Reduce interrupt signals through reset Interrupt Coalescing Control Reg.
> > Provide dynamic method to adjust interrupt signals and timer ticks by
> sysfs.
> > It is a tradeoff for different applications.
> >
> > Signed-off-by: Qiang Liu<qiang.liu@freescale.com>
> > ---
> >
> > change for V2
> > 	support dynamic config interrupt coalescing register by /sysfs
> > 	test random small file with iometer
> > Description:
> >    1. fsl-sata interrupt will be raised 130 thousand times when write
> 8G file
> >      (dd if=/dev/zero of=/dev/sda2 bs=128K count=65536);
> >    2. most of interrupts raised because of only 1-4 commands completed;
> >    3. only 30 thousand times will be raised after set max interrupt
> threshold,
> >      more interrupts are coalesced as the description of ICC;
> >
> > Test methods and results:
> >    1. test sequential large file performance,
> >    [root@p2020ds root]# echo 31 524287>  \
> >    	/sys/devices/soc.0/ffe18000.sata/intr_coalescing
> >    [root@p2020ds root]# dd if=/dev/zero of=/dev/sda2 bs=128K
> count=65536&
> >    [root@p2020ds root]# top
> >
> >    CPU %  |  dd   |  flush-8:0 | softirq
> >    ---------------------------------------
> >    before | 20-22 |    17-19   |    7
> >    ---------------------------------------
> >    after  | 18-21 |    15-16   |    5
> >    ---------------------------------------
> >    2. test random small file with iometer,
> >   iometer paramters:
> >     4 I/Os burst length, 1MB transfer request size, 100% write, 2MB
> file size
> >     as default configuration of interrupt coalescing register, 1
> interrupts and
> >   no timeout config, total write performance is 119MB per second,
> >     after config with the maximum value, write performance is 110MB per
> second.
> >
> >    After compare the test results, a configuable interrupt coalescing
> should be
> >    better when cope with flexible context.
> >
> >   drivers/ata/sata_fsl.c |  111
> ++++++++++++++++++++++++++++++++++++++++++++++--
> >   1 files changed, 107 insertions(+), 4 deletions(-)
> 
> Doesn't seem to apply to upstream, or another less recent -rc...
Thanks, I will resend it latterly.
> 
> 	Jeff
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


