Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161486Ab2JXWge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:36:34 -0400
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.31]:57939
	"EHLO NA01-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161227Ab2JXWgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:36:32 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -9
X-BigFish: PS-9(zz98dI9371I936eI542M1432Izz1202h1d1ah1d2ahzz8275dhz31h2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Drivers: scsi
Thread-Topic: Drivers: scsi
Thread-Index: AQHNsjalfdts8Dk1f0qL/oRiloXQKpfJCs7A
Date: Wed, 24 Oct 2012 22:34:38 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930A46535@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1351095938-12204-1-git-send-email-kys@microsoft.com>
 <1351117520.2494.8.camel@dabdike>
In-Reply-To: <1351117520.2494.8.camel@dabdike>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%HANSENPARTNERSHIP.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(377424002)(24454001)(51704002)(13464001)(48376001)(47976001)(31966008)(49866001)(51856001)(53806001)(50466001)(47776002)(47736001)(54316001)(6806001)(50986001)(54356001)(33656001)(16616001)(47446002)(16676001)(16696001)(5343655001)(3846001)(74502001)(46102001)(20776001)(4396001)(4606001)(44976002)(5836001)(74662001)(1076001)(2666001)(876001)(4196001)(8716001)(316001)(3556001)(3746001)(37146003);DIR:OUT;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0644578634
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9OMaafF014090



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Wednesday, October 24, 2012 6:25 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: Drivers: scsi
> 
> On Wed, 2012-10-24 at 09:25 -0700, K. Y. Srinivasan wrote:
> > When the low level driver returns SCSI_MLQUEUE_DEVICE_BUSY,
> > how is the command retried; I suspect the retry is done after some delay.
> 
> Delay depends mainly on I/O pressure and the unplug timer in the block
> layer.
> 
> > Is this delay programmable? If the device state changes,
> > can the low level driver notify upper layers that it can now handle
> > the command that it had failed earlier with SCSI_MLQUEUE_DEVICE_BUSY.
> 
> In theory, you can call blk_run_queue() from the event handler that sees
> the device become ready.  I don't think any driver actually does this,
> but I can't see it would cause any problem.

I will try this. Thanks for your prompt response.

Regards,

K. Y
 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
