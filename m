Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab2IEAaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:30:22 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:47178
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070Ab2IEAaR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:30:17 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -13
X-BigFish: VS-13(zz98dI9371I542M154dM1432Izz1202hzz8275dhz2fh2a8h683h839h944hd25hf0ah107ah1220h1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] Drivers: hv: kvp: Copy the address family
 information
Thread-Topic: [PATCH 1/1] Drivers: hv: kvp: Copy the address family
 information
Thread-Index: AQHNiulM8zP0DDf0MUmxNJylSiJRg5d6y1aAgAAKRlCAAAgNAIAAB3bA
Date: Wed, 5 Sep 2012 00:29:38 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9309DFFCA@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1346797219-25885-1-git-send-email-kys@microsoft.com>
 <20120904225655.GA3725@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9309DFF92@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120905000230.GA31997@kroah.com>
In-Reply-To: <20120905000230.GA31997@kroah.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, September 04, 2012 8:03 PM
> To: KY Srinivasan
> Cc: apw@canonical.com; devel@linuxdriverproject.org; olaf@aepfle.de;
> ben@decadent.org.uk; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: hv: kvp: Copy the address family information
> 
> On Tue, Sep 04, 2012 at 11:36:30PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Tuesday, September 04, 2012 6:57 PM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de;
> > > apw@canonical.com; ben@decadent.org.uk
> > > Subject: Re: [PATCH 1/1] Drivers: hv: kvp: Copy the address family
> information
> > >
> > > On Tue, Sep 04, 2012 at 03:20:19PM -0700, K. Y. Srinivasan wrote:
> > > > Copy the address family information.
> > >
> > > Why?
> >
> > This is part of the IP injection protocol in that the host expects this field to
> reflect what addresses
> > (address families) are currently bound to the interface. The KVP daemon is
> currently collecting this
> > Information and sending it to the kernel component. I had overlooked copying
> this and sending it
> > back to the host. This patch addresses this issue.
> 
> That's nice and descriptive, any reason you didn't put it in the patch
> changelog section the first time?
> 
> Please redo this...

Will do.

Regards,

K. Y
> 
> greg k-h
> 
> 



