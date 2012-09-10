Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2IJCxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 22:53:53 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:26025
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755069Ab2IJCxo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 22:53:44 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz1432Izz1202h1d1ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220h1288h12a5h12a9hbe9i1155h)
From: Xie Shaohui-B21989 <B21989@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bhartiya Anju-B07263 <B07263@freescale.com>
Subject: RE: [PATCH][v3] sata_fsl: add workaround for data length mismatch
 on freescale V2 controller
Thread-Topic: [PATCH][v3] sata_fsl: add workaround for data length mismatch
 on freescale V2 controller
Thread-Index: AQHNjORPB5kQ40wCmke3GsqlYeOPg5d/JTuAgAO4lvA=
Date: Mon, 10 Sep 2012 02:53:35 +0000
Message-ID: <ED492CCEAF882048BC2237DE806547C9079D9AB9@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1347012095-4404-1-git-send-email-Shaohui.Xie@freescale.com>
 <82046C25-828E-4E0F-9F86-8E038AE5C93C@kernel.crashing.org>
In-Reply-To: <82046C25-828E-4E0F-9F86-8E038AE5C93C@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.41]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/* Workaround for data length mismatch errata */
> > +	if (unlikely(hstatus & INT_ON_DATA_LENGTH_MISMATCH)) {
> > +		for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
> > +			qc = ata_qc_from_tag(ap, tag);
> > +			if (qc && ata_is_atapi(qc->tf.protocol)) {
> > +				u32 hcontrol;
> > +#define HCONTROL_CLEAR_ERROR	(1 << 27)
> 
> shouldn't we have this #define be part of the enum that the other
> HCONTROL_ bits/flags are part of?
[S.H] do you mean this?

#ifdef SATA_FSL_XXX_ERRATUAM
#define HCONTROL_CLEAR_ERROR	(1 << 27)
#endif

Then we need to decide where to put "#define SATA_FSL_XXX_ERRATUAM".

It's only a readable definition of a register bit which avoiding magic number.


Best Regards, 
Shaohui Xie

