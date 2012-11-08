Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2KHP72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:59:28 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.23]:56995
	"EHLO na01-by2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756209Ab2KHP71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:59:27 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.244.37;KIP:(null);UIP:(null);(null);H:CH1PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz9371I542M1432Izz1de0h1202h1d1ah1d2ahzzz31h2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0l1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Tomas Hozza <thozza@redhat.com>, Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH] Tools: hv: Fix for long file names from readdir
Thread-Topic: [PATCH] Tools: hv: Fix for long file names from readdir
Thread-Index: AQHNvbtZhEJZkpkrY0yrW3KCP0es1Jff/KWAgAAJToCAAA+cYA==
Date: Thu, 8 Nov 2012 15:51:42 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E0242D@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <20121108141925.GA20083@aepfle.de>
 <999858348.7901147.1352386363812.JavaMail.root@redhat.com>
In-Reply-To: <999858348.7901147.1352386363812.JavaMail.root@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: CH1PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC101.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(377454001)(13464001)(6806001)(16676001)(33656001)(47776002)(46102001)(50466001)(4396001)(50986001)(31966008)(47736001)(47976001)(44976002)(51856001)(74662001)(47446002)(23676001)(76482001)(49866001)(54316001)(53806001)(54356001)(74502001)(55846005);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 06592CCE58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA8FxWDR026829



> -----Original Message-----
> From: Tomas Hozza [mailto:thozza@redhat.com]
> Sent: Thursday, November 08, 2012 9:53 AM
> To: Olaf Hering
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com; KY
> Srinivasan
> Subject: Re: [PATCH] Tools: hv: Fix for long file names from readdir
> 
> > > -        char dev_id[256];
> > > +        char dev_id[512];
> >
> > Shouldnt that be PATH_MAX or similar?
> 
> dirent->d_name should be PATH_MAX, but it is mostly
> not guaranteed. And then the dev_id is concatenated
> with two strings so it can exceed 256 bytes.

PATH_MAX (currently 4096 bytes) I think should suffice.

Regards,

K. Y

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
