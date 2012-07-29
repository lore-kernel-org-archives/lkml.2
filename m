Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab2G2XHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 19:07:30 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:43243 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087Ab2G2XH2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 19:07:28 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zz98dI9371I15bfK542M1432Izz1202hzzz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH 00/17] drivers: hv: kvp
Thread-Topic: [PATCH 00/17] drivers: hv: kvp
Thread-Index: AQHNabSkfWrHUwMdq0aZLskIIp9mC5dA5C9g
Date: Sun, 29 Jul 2012 22:50:56 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236AA5A6@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <20120724155412.GA23918@kroah.com>
In-Reply-To: <20120724155412.GA23918@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.56.91]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, July 24, 2012 11:54 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; olaf@aepfle.de; apw@canonical.com;
> netdev@vger.kernel.org; ben@decadent.org.uk
> Subject: Re: [PATCH 00/17] drivers: hv: kvp
> 
> On Tue, Jul 24, 2012 at 09:01:12AM -0700, K. Y. Srinivasan wrote:
> > This patchset expands the KVP (Key Value Pair) functionality to
> > implement the mechanism to GET/SET IP addresses in the guest. This
> > functionality is used in Windows Server 2012 to implement VM
> > replication functionality. The way IP configuration information
> > is managed is distro specific. Based on the feedback I have gotten
> > from Olaf, Greg, Steve, Ben and Mairus, I have chosen to seperate
> > distro specific code from this patch-set. Most of the GET operation
> > can be implemented in a way that is completely distro independent and
> > I have implemented that as such and is included in this patch-set.
> > Some of the attributes that can only be fetched in a distro
> > dependent way as well the mechanism for configuring an interface
> > (the SET operation) that is clearly distro specific is to be
> > implemented via external scripts that will be invoked via the KVP
> > code. We define here the interface to these scripts.
> >
> > Adding support for IP injection resulted in some changes to the
> > protocol between the user level daemon and the kernel driver.
> > These changes have been implemented in way that would retain
> > compatibility with older daemons. I would like to thank Olaf and
> > Greg for pointing out the compatibility issue.
> 
> Due to this being the middle of the merge window, I will not be able to
> look at this until after 3.6-rc1 is out.

Thanks Greg. In the meantime, I have addressed all the comments that both Olaf
and Ben have posted on this patch-set. Since addressing these comments changed
some data structures, I think it will be best if you dropped this patch-set. I will post the 
updated patch-set shortly.

Regards,

K. Y



