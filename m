Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2HQV4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:56:49 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:22014 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757909Ab2HQV4a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:56:30 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I1454I542M1432Izz1202hzz8275dhz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH V3 08/14] Tools: hv: Gather DNS information
Thread-Topic: [PATCH V3 08/14] Tools: hv: Gather DNS information
Thread-Index: AQHNfBXfRZ51oH5JRU6o6Q09JaeVqJdeONSAgAACHPCAAAU+AIAAQ2iA
Date: Fri, 17 Aug 2012 21:41:42 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236C20E7@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-8-git-send-email-kys@microsoft.com>
 <20120817165109.GA11323@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9236C1E63@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120817171728.GA14288@kroah.com>
In-Reply-To: <20120817171728.GA14288@kroah.com>
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
> Sent: Friday, August 17, 2012 1:17 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; ben@decadent.org.uk
> Subject: Re: [PATCH V3 08/14] Tools: hv: Gather DNS information
> 
> On Fri, Aug 17, 2012 at 05:07:22PM +0000, KY Srinivasan wrote:
> > > On Thu, Aug 16, 2012 at 06:32:19PM -0700, K. Y. Srinivasan wrote:
> > > > Now, gather DNS information. Invoke an external script (that can be
> > > > distro dependent) to gather the DNS information.
> > >
> > > Where is that script?  Why a script, this really isn't in a standard
> > > method for all Linux distros?  If not, why not work to do that like the
> > > freedesktop.org people have done for other system configuration items?
> >
> > We debated this issue on this mailing list for a long time. The consensus was
> that
> > we would invoke  external "distro" specific scripts for both configuring the
> interface
> > as well as gathering information that could not be gathered in a distro
> independent
> > fashion. That is what I have implemented here. This code specifies the interface
> to this
> > external script. If these external scripts are not there, it is not fatal - on the SET
> side,
> > the interface will not be configured and on the get side some attributes that are
> to be
> > gathered via these external scripts will not be collected.
> 
> I've applied the first 7 patches here, feel free to submit the rest when
> you answer the other questions I asked as well.

Greg,

I have tried to answer your questions in other emails I have sent out on this thread.
To summarize, the current implementation (with external scripts) does not preclude
using Network Manager where it makes sense (in the external scripts).

If you think it will be useful to have example scripts, I could send the scripts I
have used to test this code as example code. The reason I did not send the 
scripts is because (a) not having these scripts is not fatal to this code and 
(b) Given that this is a distro specific script, I did not want code checked 
into the kernel tree that was very distro specific.

Let me know if I have addressed your concerns and if I can re-send the
remaining 7 patches.  
 
Regards,

K. Y


