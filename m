Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2GXRSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:18:20 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:52834
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755490Ab2GXRSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:18:18 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432Izz1202hzz8275bhz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>, Stephen Hemminger <shemminger@vyatta.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH 10/17] Tools: hv: Gather ipv[4,6] gateway information
Thread-Topic: [PATCH 10/17] Tools: hv: Gather ipv[4,6] gateway information
Thread-Index: AQHNabOMN3x+AARaaU2GSNtsd+dZtJc4n4UAgAAG6oCAAAHiMA==
Date: Tue, 24 Jul 2012 17:17:23 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236A776D@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-10-git-send-email-kys@microsoft.com>
 <20120724092914.60f3d90a@nehalam.linuxnetplumber.net>
 <20120724165359.GA8409@aepfle.de>
In-Reply-To: <20120724165359.GA8409@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VYATTA.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6OHIQmA010796



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, July 24, 2012 12:54 PM
> To: Stephen Hemminger
> Cc: KY Srinivasan; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; apw@canonical.com;
> netdev@vger.kernel.org; ben@decadent.org.uk
> Subject: Re: [PATCH 10/17] Tools: hv: Gather ipv[4,6] gateway information
> 
> On Tue, Jul 24, Stephen Hemminger wrote:
> 
> > On Tue, 24 Jul 2012 09:01:34 -0700
> > "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> >
> > > +	memset(cmd, 0, sizeof(cmd));
> > > +	strcat(cmd, "/sbin/ip -f inet  route | grep -w ");
> > > +	strcat(cmd, if_name);
> > > +	strcat(cmd, " | awk '/default/ {print $3 }'");
> >
> >
> > Much simpler method:
> >
> > ip route show match 0/0
> 
> This also has the benefit that ip is not called with absolute path, now
> that distros move binaries around.

I could have chosen to not specify the full path for the ip command and for that
matter all the external scripts I invoke from the KVP daemon. Do you mind if I 
submitted a patch to get rid of the absolute paths in this code.

Stephen's suggestion is clearly simpler (I don't need to invoke awk to filter what 
we want). Steve, I could make this change as well as an additional patch.

Regards,

K. Y 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
