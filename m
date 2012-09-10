Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab2IJKqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:46:08 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:36459
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756865Ab2IJKpm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:45:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I936eI542M1432Izz1202h1d1ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220h1288h12a5h12a9hbe9i1155h)
From: Xie Shaohui-B21989 <B21989@freescale.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Kumar Gala <galak@kernel.crashing.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bhartiya Anju-B07263 <B07263@freescale.com>
Subject: RE: [PATCH][v3] sata_fsl: add workaround for data length mismatch
 on freescale V2 controller
Thread-Topic: [PATCH][v3] sata_fsl: add workaround for data length mismatch
 on freescale V2 controller
Thread-Index: AQHNjORPB5kQ40wCmke3GsqlYeOPg5d/JTuAgAO4lvCAANhkgP//rinQ
Date: Mon, 10 Sep 2012 10:45:37 +0000
Message-ID: <ED492CCEAF882048BC2237DE806547C9079D9FCF@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1347012095-4404-1-git-send-email-Shaohui.Xie@freescale.com>
 <82046C25-828E-4E0F-9F86-8E038AE5C93C@kernel.crashing.org>
 <ED492CCEAF882048BC2237DE806547C9079D9AB9@039-SN2MPN1-012.039d.mgd.msft.net>
 <504DBF3D.2000102@mvista.com>
In-Reply-To: <504DBF3D.2000102@mvista.com>
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

> -----Original Message-----
> From: Sergei Shtylyov [mailto:sshtylyov@mvista.com]
> Sent: Monday, September 10, 2012 6:22 PM
> To: Xie Shaohui-B21989
> Cc: Kumar Gala; jgarzik@pobox.com; linux-ide@vger.kernel.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Bhartiya Anju-B07263
> Subject: Re: [PATCH][v3] sata_fsl: add workaround for data length
> mismatch on freescale V2 controller
> 
> Hello.
> 
> On 10-09-2012 6:53, Xie Shaohui-B21989 wrote:
> 
> >>> +	/* Workaround for data length mismatch errata */
> >>> +	if (unlikely(hstatus & INT_ON_DATA_LENGTH_MISMATCH)) {
> >>> +		for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
> >>> +			qc = ata_qc_from_tag(ap, tag);
> >>> +			if (qc && ata_is_atapi(qc->tf.protocol)) {
> >>> +				u32 hcontrol;
> >>> +#define HCONTROL_CLEAR_ERROR	(1 << 27)
> 
> >> shouldn't we have this #define be part of the enum that the other
> >> HCONTROL_ bits/flags are part of?
> 
> > [S.H] do you mean this?
> 
>     Apparently not. He said *enum*, not #define.

[S.H] OK. Thank you for the clarification.


Best Regards, 
Shaohui Xie

