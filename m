Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab2IDXk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:40:28 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:15115
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688Ab2IDXk0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:40:26 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432Izz1202hzz8275bhz2fh2a8h683h839h944hd25hf0ah107ah1220h1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "thozza@redhat.com" <thozza@redhat.com>,
        "dcbw@redhat.com" <dcbw@redhat.com>
Subject: RE: [PATCH V4 05/10] Tools: hv: Add an example script to retrieve
 dhcp state
Thread-Topic: [PATCH V4 05/10] Tools: hv: Add an example script to retrieve
 dhcp state
Thread-Index: AQHNiuRd+TMU4+nMkkGvTOIPJ1HKHZd6zAmAgAAKcsA=
Date: Tue, 4 Sep 2012 23:39:12 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9309DFFA2@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1346795156-25614-1-git-send-email-kys@microsoft.com>
 <1346795202-25655-1-git-send-email-kys@microsoft.com>
 <1346795202-25655-5-git-send-email-kys@microsoft.com>
 <20120904225917.GB3725@kroah.com>
In-Reply-To: <20120904225917.GB3725@kroah.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, September 04, 2012 6:59 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; ben@decadent.org.uk; thozza@redhat.com;
> dcbw@redhat.com
> Subject: Re: [PATCH V4 05/10] Tools: hv: Add an example script to retrieve dhcp
> state
> 
> On Tue, Sep 04, 2012 at 02:46:37PM -0700, K. Y. Srinivasan wrote:
> > To keep the KVP daemon code free of distro specific details, we invoke an
> > external script to retrieve the DHCP state. This is an example script that
> > was used to test the KVP code. This script has to be implemented in a Distro
> > specific fashion. For instance on distros that ship with Network Manager
> enabled,
> > this script can be based on NM APIs.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  tools/hv/hv_get_dhcp_info.sh |   25 +++++++++++++++++++++++++
> >  1 files changed, 25 insertions(+), 0 deletions(-)
> >  create mode 100755 tools/hv/hv_get_dhcp_info.sh
> >
> > diff --git a/tools/hv/hv_get_dhcp_info.sh b/tools/hv/hv_get_dhcp_info.sh
> > new file mode 100755
> > index 0000000..3de4587
> > --- /dev/null
> > +++ b/tools/hv/hv_get_dhcp_info.sh
> > @@ -0,0 +1,25 @@
> > +#!/bin/bash
> > +
> > +# This example script retrieves the DHCP state of a given interface.
> > +# In the interest of keeping the KVP daemon code free of distro specific
> > +# information; the kvp daemon code invokes this external script to gather
> > +# DHCP setting for the specific interface.
> > +#
> > +# Input: Name of the interface
> > +#
> > +# Output: The script prints the string "Enabled" to stdout to indicate
> > +#	that DHCP is enabled on the interface.
> 
> What happens if DHCP is not enabled on the interface?  Shouldn't that
> also return something other than "success"?

The script is expected to write "Enabled" to stdout to indicate if DHCP is enabled; if this 
is not the case, implicitly we assume DHCP is not enabled (since this is a binary state).

Regards,

K. Y 



