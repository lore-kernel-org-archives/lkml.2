Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644Ab2FVSz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:55:29 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:39828
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758444Ab2FVSz1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:55:27 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432Izz1202hzz8275bhz2fh2a8h683h839h944hd25hf0ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Jesper Juhl <jj@chaosbits.net>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "apw@canonical.com" <apw@canonical.com>
Subject: RE: [PATCH 00/13] drivers: hv: kvp
Thread-Topic: [PATCH 00/13] drivers: hv: kvp
Thread-Index: AQHNT/NB00SQsXjmDEmcq7JSjap8hpcFa+qAgAFEZeA=
Date: Fri, 22 Jun 2012 18:54:34 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9155EC53B@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1206220125410.7671@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1206220125410.7671@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.53.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CHAOSBITS.NET$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jesper Juhl [mailto:jj@chaosbits.net]
> Sent: Thursday, June 21, 2012 7:31 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> apw@canonical.com
> Subject: Re: [PATCH 00/13] drivers: hv: kvp
> 
> On Thu, 21 Jun 2012, K. Y. Srinivasan wrote:
> 
> > This patchset expands the KVP (Key Value Pair) functionality to
> > implement the mechanism to get/set IP addresses in the guest. This
> > functionality is used in Windows Server 2012 to implement VM
> > replication functionality. The way IP configuration information
> > is managed is distro specific. The current implementation supports
> > RedHat way of doing things. We will expand support to other distros
> > incrementally.
> >
> So there is going to be a continuous flow of patches to add support for
> new distros (Arch Linux, Slackware, Linux Mint, SuSE, Debian, etc etc) and
> if different versions of a distro handles things differently then you are
> also going to deal with that? Might be fine, but it just sounds a bit
> scary to me to try to support m different distros, each in n different
> versions from the kernel... Couldn't this somehow be done once and for all
> in a distro neutral way?
> Just asking :-)

Most of the code is not going to be distro specific. Obviously the kernel component
Is not distro specific. To the extent that the way the IP configuration state is managed
differently across distros, the user level component of the KVP code needs to 
accommodate that. Even here most of the code is distro independent. 

Regards,

K. Y


