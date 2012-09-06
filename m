Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2IFL5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:57:44 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:35003
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208Ab2IFL5m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:57:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz1432Izz1202hzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220hbe9i1155h)
From: Xie Shaohui-B21989 <B21989@freescale.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>,
        Bhartiya Anju-B07263 <B07263@freescale.com>
Subject: RE: [PATCH] [v2] sata_fsl: add workaround for data length mismatch
 on freescale V2 controller
Thread-Topic: [PATCH] [v2] sata_fsl: add workaround for data length mismatch
 on freescale V2 controller
Thread-Index: AQHNi+yUaeDyjxLH60WYEHzK7i0Z2pd9gZIA//+vXZA=
Date: Thu, 6 Sep 2012 11:57:37 +0000
Message-ID: <ED492CCEAF882048BC2237DE806547C9079D3C6C@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1346905686-27912-1-git-send-email-Shaohui.Xie@freescale.com>
 <504888F8.5060907@mvista.com>
In-Reply-To: <504888F8.5060907@mvista.com>
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

> >
> >   	hstatus = ioread32(hcr_base + HSTATUS);
> >
> >   	sata_fsl_scr_read(&ap->link, SCR_ERROR, &SError);
> >
> > +	/* Read command completed register */
> > +	done_mask = ioread32(hcr_base + CC);
> > +
> > +	/* Workaround for data length mismatch errata */
> > +	if (unlikely(hstatus & INT_ON_DATA_LENGTH_MISMATCH)) {
> > +		for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
> > +			qc = ata_qc_from_tag(ap, tag);
> > +			if (qc && ata_is_atapi(qc->tf.protocol)) {
> > +				u32 Hcontrol;
> 
>     No uppercase in variable names please. 
[S.H] OK.

Besides, you have 'hstatus'
> variable already and that would be inconsistent.
[S.H] Yes, but I ignored fatal error and device error, so this won't be an issue.

> 
> > +#define HCONTROL_CLEAR_ERROR	(1 << 27)
> > +				/* Set HControl[27] to clear error registers */
> > +				Hcontrol = ioread32(hcr_base + HCONTROL);
> > +				iowrite32(Hcontrol | HCONTROL_CLEAR_ERROR,
> > +						hcr_base + HCONTROL);
> > +
> > +				/* Clear HControl[27] */
> > +				iowrite32(Hcontrol & (~HCONTROL_CLEAR_ERROR),
> 
>     Parens not needed around ~HCONTROL_CLEAR_ERROR.
[S.H] OK.


Best Regards, 
Shaohui Xie

