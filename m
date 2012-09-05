Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab2IESRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:17:52 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:27218 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869Ab2IESRv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:17:51 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz9371I542M1432Izz1202hzz8275bhz2fh2a8h683h839h944hd25hf0ah107ah1220h1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "thozza@redhat.com" <thozza@redhat.com>,
        "dcbw@redhat.com" <dcbw@redhat.com>
Subject: RE: [PATCH 4/4] tools: hv: Parse /etc/os-release
Thread-Topic: [PATCH 4/4] tools: hv: Parse /etc/os-release
Thread-Index: AQHNi4XgLVQvSblNf0aXtnE/jq4/OJd7+DYAgAAUhGA=
Date: Wed, 5 Sep 2012 18:16:56 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9309E02B3@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1346864519-30020-1-git-send-email-kys@microsoft.com>
	<1346864553-30059-1-git-send-email-kys@microsoft.com>
	<1346864553-30059-4-git-send-email-kys@microsoft.com>
 <20120905175810.60ee45c8@pyramind.ukuu.org.uk>
In-Reply-To: <20120905175810.60ee45c8@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LXORGUK.UKUU.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Wednesday, September 05, 2012 12:58 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> ben@decadent.org.uk; thozza@redhat.com; dcbw@redhat.com
> Subject: Re: [PATCH 4/4] tools: hv: Parse /etc/os-release
> 
> > +			if (!strcmp(buf, "NAME"))
> > +				os_name = strdup(value);
> > +			else if (!strcmp(buf, "VERSION_ID"))
> > +				os_major = strdup(value);
> 
> strdup can fail. The case where it leaks because NAME= occurs twice is
> harmless enough but the strdup ought to be checked or add an x_strdup()
> helper.

I will fix this and resend this patch.

Thank you,

K. Y



