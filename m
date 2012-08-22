Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab2HVPp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:45:56 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:21023
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732Ab2HVPpv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:45:51 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432Izz1202hzz8275dhz2fh2a8h683h839h944hd25hf0ah107ah1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "Thomas Graf (tgraf@redhat.com)" <tgraf@redhat.com>
Subject: RE: [PATCH V3 08/14] Tools: hv: Gather DNS information
Thread-Topic: [PATCH V3 08/14] Tools: hv: Gather DNS information
Thread-Index: AQHNfBXfRZ51oH5JRU6o6Q09JaeVqJdeONSAgAfDkAA=
Date: Wed, 22 Aug 2012 15:45:31 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236C3FF4@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-8-git-send-email-kys@microsoft.com>
 <20120817165109.GA11323@kroah.com>
In-Reply-To: <20120817165109.GA11323@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
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
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, August 17, 2012 12:51 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; olaf@aepfle.de; apw@canonical.com;
> ben@decadent.org.uk
> Subject: Re: [PATCH V3 08/14] Tools: hv: Gather DNS information
> 
> On Thu, Aug 16, 2012 at 06:32:19PM -0700, K. Y. Srinivasan wrote:
> > Now, gather DNS information. Invoke an external script (that can be
> > distro dependent) to gather the DNS information.
> 
> Where is that script? 

If you think it is useful, I could send you the scripts that I have used to test this
functionality as example scripts. 
  
> Why a script, this really isn't in a standard
> method for all Linux distros?  If not, why not work to do that like the
> freedesktop.org people have done for other system configuration items?

When discussing this while preparing the patches it was clear that there
really is no single way to obtain the network information, if you are
using network manager you need to use dbus, basic debian networking as
on a server you need to look in /etc/resolv.conf, if you have dnsmasq
installed you need to look in a third place.  On the SLES side that I am somewhat 
familiar with, if I recall correctly, none of the appliance images have Network Manager installed.
The consensus was that  we should avoid pulling a vast pile of distro smarts into the source which
lead to the hook API proposed in these patches.

The approach chosen here does not preclude using Network Manager in the external scripts
if a particular distro chooses to go that route. The current implementation supports maximum
flexibility without sacrificing anything. While the current scripts I have do not use NM APIs, we could
work on external scripts using DBUS APIs.

If it is ok with you, I could send you the remaining 7 patches along with the scripts I am
currently using to test this code. These scripts should be viewed just example code. 

Regards,

K. Y

 



