Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab2GYOLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:11:09 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:17187 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932927Ab2GYOLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:11:04 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I936eI542M1432Izz1202hzz8275bh8275dhz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 08/17] Tools: hv: Gather subnet information
Thread-Topic: [PATCH 08/17] Tools: hv: Gather subnet information
Thread-Index: AQHNabf0p+M7mqXsXUqIzNQ3Ihse95c5MicAgADY2qA=
Date: Wed, 25 Jul 2012 14:10:51 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236A8B6D@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
	 <1343145701-3691-1-git-send-email-kys@microsoft.com>
	 <1343145701-3691-8-git-send-email-kys@microsoft.com>
 <1343178850.5132.104.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1343178850.5132.104.camel@deadeye.wl.decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6PEBaIs015647



> -----Original Message-----
> From: Ben Hutchings [mailto:ben@decadent.org.uk]
> Sent: Tuesday, July 24, 2012 9:14 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; olaf@aepfle.de;
> apw@canonical.com; netdev@vger.kernel.org
> Subject: Re: [PATCH 08/17] Tools: hv: Gather subnet information
> 
> On Tue, 2012-07-24 at 09:01 -0700, K. Y. Srinivasan wrote:
> > Now gather sub-net information for the specified interface.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  tools/hv/hv_kvp_daemon.c |   31 +++++++++++++++++++++++++++++--
> >  1 files changed, 29 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> > index 79eb130..2c24ebf 100644
> > --- a/tools/hv/hv_kvp_daemon.c
> > +++ b/tools/hv/hv_kvp_daemon.c
> > @@ -534,6 +534,7 @@ kvp_get_ip_address(int family, char *if_name, int op,
> >  	struct ifaddrs *ifap;
> >  	struct ifaddrs *curp;
> >  	int offset = 0;
> > +	int sn_offset = 0;
> >  	const char *str;
> >  	int error = 0;
> >  	char *buffer;
> > @@ -594,12 +595,38 @@ kvp_get_ip_address(int family, char *if_name, int op,
> >  			 * Gather info other than the IP address.
> >  			 * IP address info will be gathered later.
> >  			 */
> > -			if (curp->ifa_addr->sa_family == AF_INET)
> > +			if (curp->ifa_addr->sa_family == AF_INET) {
> >  				ip_buffer->addr_family |= ADDR_FAMILY_IPV4;
> > -			else
> > +				/*
> > +				 * Get subnet info.
> > +				 */
> > +				error = kvp_process_ip_address(
> > +							curp->ifa_netmask,
> > +							AF_INET,
> > +							(char *)
> > +							ip_buffer->sub_net,
> > +							length,
> > +							&sn_offset);
> [...]
> 
> This is barely readable; why don't you indent the arguments by just one
> extra tab?

Will do.

Regards,

K. Y
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
