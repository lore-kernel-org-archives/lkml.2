Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab2HQRzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:55:51 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:9789
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430Ab2HQRzn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:55:43 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432Izz1202hzz8275bh8275dhz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>, Ben Hutchings <ben@decadent.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>
Subject: RE: [PATCH V3 08/14] Tools: hv: Gather DNS information
Thread-Topic: [PATCH V3 08/14] Tools: hv: Gather DNS information
Thread-Index: AQHNfBXfRZ51oH5JRU6o6Q09JaeVqJdeONSAgAALdYCAAAHOgIAAAn/w
Date: Fri, 17 Aug 2012 17:55:04 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236C1F42@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-8-git-send-email-kys@microsoft.com>
 <20120817165109.GA11323@kroah.com> <20120817173209.GA29217@decadent.org.uk>
 <20120817173837.GA3080@kroah.com>
In-Reply-To: <20120817173837.GA3080@kroah.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, August 17, 2012 1:39 PM
> To: Ben Hutchings
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com
> Subject: Re: [PATCH V3 08/14] Tools: hv: Gather DNS information
> 
> On Fri, Aug 17, 2012 at 06:32:09PM +0100, Ben Hutchings wrote:
> > On Fri, Aug 17, 2012 at 09:51:09AM -0700, Greg KH wrote:
> > > On Thu, Aug 16, 2012 at 06:32:19PM -0700, K. Y. Srinivasan wrote:
> > > > Now, gather DNS information. Invoke an external script (that can be
> > > > distro dependent) to gather the DNS information.
> > >
> > > Where is that script?  Why a script, this really isn't in a standard
> > > method for all Linux distros?  If not, why not work to do that like the
> > > freedesktop.org people have done for other system configuration items?
> >
> > I suggested using the Network Manager D-Bus API.  That obviously
> > isn't going to work everywhere, but it seems to cover the same simple
> > cases that this hypervisor-guest interface allows for.
> 
> That's a great start, as I think all of the distros have now pretty much
> standardized on this format, right?

Based on Ben's suggestion I was looking at using NM D-Bus API. Subsequently,
talking to Olaf and Mairus, I chose to go with the external script approach since 
each Distro could pretty much decide how the functionality would be implemented
on a specific Distro including for instance by using the NM D-Bus API in the script.
I think the approach of having an external script while not precluding anything 
makes the KVP code more generic and  more widely applicable without sacrificing
anything.

Regards,

K. Y 



