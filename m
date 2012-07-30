Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab2G3Sdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 14:33:39 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:24008
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206Ab2G3Sdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 14:33:36 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432Izz1202hzzz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH 13/17] Tools: hv: Implement the KVP verb -
 KVP_OP_SET_IP_INFO
Thread-Topic: [PATCH 13/17] Tools: hv: Implement the KVP verb -
 KVP_OP_SET_IP_INFO
Thread-Index: AQHNabffApGkoXQ/oEyNNUVPYtB2bpdCJ8sAgAADC6A=
Date: Mon, 30 Jul 2012 18:32:15 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236AA7DB@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-13-git-send-email-kys@microsoft.com>
 <20120730180326.GB533@aepfle.de>
In-Reply-To: <20120730180326.GB533@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.56.91]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6UIXgw3006278



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Monday, July 30, 2012 2:03 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; netdev@vger.kernel.org;
> ben@decadent.org.uk
> Subject: Re: [PATCH 13/17] Tools: hv: Implement the KVP verb -
> KVP_OP_SET_IP_INFO
> 
> On Tue, Jul 24, K. Y. Srinivasan wrote:
> 
> > +	/*
> > +	 * Set the configuration for the specified interface with
> > +	 * the information provided. Since there is no standard
> > +	 * way to configure an interface, we will have an external
> > +	 * script that does the job of configuring the interface and
> > +	 * flushing the configuration.
> > +	 *
> > +	 * The parameters passed to this external script are:
> > +	 * 1. A configuration file that has the specified configuration.
> 
> Maybe this should be written as 'A info file that has the requested
> network configuration' or something like that.

That is the idea. This configuration file simply reflects all the information we have
perhaps with some additional constant information. The script is free to ignore what
it does not need. 

> 
> > +	 *
> > +	 * We will embed the name of the interface in the configuration
> > +	 * file: ifcfg-ethx (where ethx is the interface name).
> 
> I think the intention here is to use the generated file as is. Depending
> on the distro in the guest the file may need some processing. So I think
> the actual interface name should also be part of the file.

That is not the intention although on some distros, the format of this file
may be closer to the distro specific configuration file than others. I will 
however include the name of the interface in the file as well.
 

> 
> > +	 *
> > +	 * Here is the format of the ip configuration file:
> > +	 *
> > +	 * HWADDR=macaddr
> > +	 * BOOTPROTO=dhcp (dhcp enabled for the interface)
> 
> While BOOTPROTO= is used in current network config files, its meaning
> there is unrelated to what its meant here. Here it means DHCP=yes/no, so
> I think the file should contain just that. And as the code is written
> now BOOTPROTO= is optional, which is not mentioned in the comment.

I will fix this.

> 
> > +	 * NM_CONTROLLED=no (this interface will not be controlled by NM)
> 
> I think this is not up to kvp_deamon to decide what controls the
> interface. Maybe one day NM is sufficiently advanced technology that it
> can cope with such requests?
> The helper script should decide if the NM flag should be written to the
> final config file.

As I noted earlier, the external script can choose to interpret the contents of this
file in a way that it makes sense for the distribution. Maybe, I will get rid of all the 
constant information.

> 
> > +	 * PEERDNS=yes
> > +	 * IPADDR_x=ipaddr
> > +	 * NETMASK_x=netmask
> > +	 * GATEWAY_x=gateway
> 
> This should mention that its either IPADDR=ipaddr1 or 'IPADDR=ipaddr1;
> IPADDR_1=ipaddr2'
> 
> > +	 * DNSx=dns
> 
> This should mention that its either DNS=ipaddr1 or 'DNS=ipaddr1;
> DNS1=ipaddr2'

I take it that you want the comments to be more explicit on the format.

> 
> Olaf
> 
> 

Thank you Olaf,

K. Y

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
