Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2JHDiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 23:38:03 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:6347 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477Ab2JHDiB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 23:38:01 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I542M1432I4015Ic8kzz1202h1d1ah1d2ahzz8275bh8275dhz2fh2a8h683h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: RE: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
Thread-Topic: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
Thread-Index: AQHNpOUXgnwlsoeYd0afghaYt4KseJeukoUAgAAv5eA=
Date: Mon, 8 Oct 2012 03:37:47 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930A1FB3D@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
 <1349654386-18378-1-git-send-email-kys@microsoft.com>
 <1349654386-18378-2-git-send-email-kys@microsoft.com>
 <20121008004504.GB12342@kroah.com>
In-Reply-To: <20121008004504.GB12342@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Sunday, October 07, 2012 8:45 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; akpm@linux-foundation.org; andi@firstfloor.org
> Subject: Re: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
> 
> On Sun, Oct 07, 2012 at 04:59:46PM -0700, K. Y. Srinivasan wrote:
> > +config HYPERV_BALLOON
> > +	tristate "Microsoft Hyper-V Balloon driver"
> > +	depends on HYPERV
> > +	help
> > +	  Select this option to enable the Hyper-V Utilities.
> 
> Your help text is wrong :(

Sorry about that; I will fix it.

> 
> > --- /dev/null
> > +++ b/drivers/hv/hv_balloon.c
> > @@ -0,0 +1,1043 @@
> > +/*
> > + * Copyright (c) 2012, Microsoft Corporation.
> > + *
> > + * Author:
> > + *   K. Y. Srinivasan <kys@microsoft.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License version 2 as published
> > + * by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE
> or
> > + * NON INFRINGEMENT.  See the GNU General Public License for more
> > + * details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
> 
> Unless you promise to keep track of the FSF's office buildings for the
> next 40+ years, just drop this paragraph entirely.

Will do.

Thanks,

K. Y



