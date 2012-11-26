Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2KZVQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:16:10 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:12917
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756123Ab2KZVQI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:16:08 -0500
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2fh2a8h683h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h15d0l1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Tomas Hozza <thozza@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH 1/3] tools/hv: Fix /var subdirectory
Thread-Topic: [PATCH 1/3] tools/hv: Fix /var subdirectory
Thread-Index: AQHNvoM3NhwpZHL+HEaRDr+rRQLm1Jfhp+kwgARB4ACAFsZWIIAACECAgAAAb+A=
Date: Mon, 26 Nov 2012 21:15:50 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E5A96D@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <426367E2313C2449837CD2DE46E7EAF930E22362@CH1PRD0310MB381.namprd03.prod.outlook.com>
 <1352710506-12590-1-git-send-email-thozza@redhat.com>
 <426367E2313C2449837CD2DE46E7EAF930E5A907@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20121126211211.GA24858@kroah.com>
In-Reply-To: <20121126211211.GA24858@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC101.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Monday, November 26, 2012 4:12 PM
> To: KY Srinivasan
> Cc: Tomas Hozza; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com;
> ben@decadent.org.uk
> Subject: Re: [PATCH 1/3] tools/hv: Fix /var subdirectory
> 
> On Mon, Nov 26, 2012 at 08:42:40PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Tomas Hozza [mailto:thozza@redhat.com]
> > > Sent: Monday, November 12, 2012 3:55 AM
> > > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > jasowang@redhat.com; KY Srinivasan; ben@decadent.org.uk
> > > Cc: Tomas Hozza
> > > Subject: [PATCH 1/3] tools/hv: Fix /var subdirectory
> > >
> > > Initial patch by Ben Hutchings <ben@decadent.org.uk>
> > >
> > > We will install this in /usr, so it must use /var/lib for its state.
> > > Only programs installed under /opt should use /var/opt.
> > >
> > > Signed-off-by: Tomas Hozza <thozza@redhat.com>
> > Acked-by:  K. Y. Srinivasan <kys@microsoft.com>
> 
> As I stated before, you need to rediff these, and resend them to me, I
> have no more hyperv patches in my queue to apply.

Will do. There were totally 3 patches that Tomas had sent that I acked today. Tomas, could you 
rebase the patches (if needed) and re-send them. 

K. Y
> 
> greg k-h
> 



