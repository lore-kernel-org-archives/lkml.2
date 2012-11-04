Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2KDP05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 10:26:57 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.30]:18544
	"EHLO na01-by2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755413Ab2KDP0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 10:26:52 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -10
X-BigFish: PS-10(zz98dI9371I936eI542M1432I1447Izz1de0h1202h1d1ah1d2ahzz8275dhz31h2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
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
Thread-Index: AQHNunBNeEv0vukYrkymMIfn7qPLvJfZzHSA
Date: Sun, 4 Nov 2012 15:26:31 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930DF9113@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1351960806-16240-1-git-send-email-kys@microsoft.com>
 <1352021949.2427.19.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1352021949.2427.19.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.192.129.74]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%HANSENPARTNERSHIP.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377424002)(377454001)(51704002)(51914002)(13464001)(24454001)(6806001)(74662001)(47976001)(53806001)(50466001)(54356001)(44976002)(49866001)(47776002)(16676001)(54316001)(47736001)(50986001)(31966008)(4396001)(51856001)(23676001)(46102001)(74502001)(33656001)(47446002)(76482001)(5343655001)(550254004);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0655F9F006
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA4FQxY0004580



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Sunday, November 04, 2012 4:39 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: Drivers: scsi
> 
> On Sat, 2012-11-03 at 09:40 -0700, K. Y. Srinivasan wrote:
> > Do we currently support dynamic re-sizing of LUNs. Hyper-V can
> > notify capacity change via sense data and I was wondering if this
> > is handled in the generic scsi code.
> 
> Depends what you mean by "dynamic".  Experience shows that most users
> really don't want all this to happen without manual intervention
> (particularly on shrink).  However, we have the mechanics in place.
> Just send ASC/Q 2A/09 and it can get vectored up to LVM which resizes
> the volume and can be scripted automatically to resize the filesystem.
> 
> hypervisor people tend to have problems with scripting, so there are
> some hacks that do this outside of the normal event system ... see for
> example virtio_scsi.c

Thanks for the prompt response.

Regards,

K. Y
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
