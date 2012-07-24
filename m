Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab2GXWNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 18:13:43 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:40090
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836Ab2GXWNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 18:13:41 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I936eI542M1432Izz1202hzz8275bhz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Dan Williams <dcbw@redhat.com>, Stephen Hemminger <shemminger@vyatta.com>
CC: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH 10/17] Tools: hv: Gather ipv[4,6] gateway information
Thread-Topic: [PATCH 10/17] Tools: hv: Gather ipv[4,6] gateway information
Thread-Index: AQHNabOMN3x+AARaaU2GSNtsd+dZtJc4n4UAgAAG6oCAAADXgIAAG+YAgAA35EA=
Date: Tue, 24 Jul 2012 22:13:00 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236A78D1@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
	 <1343145701-3691-1-git-send-email-kys@microsoft.com>
	 <1343145701-3691-10-git-send-email-kys@microsoft.com>
	 <20120724092914.60f3d90a@nehalam.linuxnetplumber.net>
	 <20120724165359.GA8409@aepfle.de>
	 <20120724095659.5c869511@nehalam.linuxnetplumber.net>
 <1343155010.29196.1.camel@dcbw.foobar.com>
In-Reply-To: <1343155010.29196.1.camel@dcbw.foobar.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VYATTA.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6OMDwrF011895



> -----Original Message-----
> From: Dan Williams [mailto:dcbw@redhat.com]
> Sent: Tuesday, July 24, 2012 2:37 PM
> To: Stephen Hemminger
> Cc: Olaf Hering; KY Srinivasan; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; apw@canonical.com; netdev@vger.kernel.org;
> ben@decadent.org.uk
> Subject: Re: [PATCH 10/17] Tools: hv: Gather ipv[4,6] gateway information
> 
> On Tue, 2012-07-24 at 09:56 -0700, Stephen Hemminger wrote:
> > On Tue, 24 Jul 2012 18:53:59 +0200
> > Olaf Hering <olaf@aepfle.de> wrote:
> >
> > > On Tue, Jul 24, Stephen Hemminger wrote:
> > >
> > > > On Tue, 24 Jul 2012 09:01:34 -0700
> > > > "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> > > >
> > > > > +	memset(cmd, 0, sizeof(cmd));
> > > > > +	strcat(cmd, "/sbin/ip -f inet  route | grep -w ");
> > > > > +	strcat(cmd, if_name);
> > > > > +	strcat(cmd, " | awk '/default/ {print $3 }'");
> > > >
> > > >
> > > > Much simpler method:
> > > >
> > > > ip route show match 0/0
> > >
> > > This also has the benefit that ip is not called with absolute path, now
> > > that distros move binaries around.
> > >
> > > Olaf
> >
> > It is also not hard to do the same thing with a little function
> > using libmnl
> 
> Yeah seriously, netlink anyone?  You'll even get nicer error reporting
> that way.

While I will be the first admit that using C API is always better (in C code),
in this particular instance I am not so sure. All I am doing is retrieving information
on default gateways. If there is an error, that is ok and this won't be reported
back to the host. Using the ip command significantly simplifies the code here.

Regards,

K. Y  

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
