Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab2GYOs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:48:58 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:55220
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933101Ab2GYOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:48:56 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I936eI542M1432Izz1202hzz8275dhz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 13/17] Tools: hv: Implement the KVP verb -
 KVP_OP_SET_IP_INFO
Thread-Topic: [PATCH 13/17] Tools: hv: Implement the KVP verb -
 KVP_OP_SET_IP_INFO
Thread-Index: AQHNabffApGkoXQ/oEyNNUVPYtB2bpc5NSOAgADYO8A=
Date: Wed, 25 Jul 2012 14:48:14 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236A8BD0@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
	 <1343145701-3691-1-git-send-email-kys@microsoft.com>
	 <1343145701-3691-13-git-send-email-kys@microsoft.com>
 <1343179491.5132.112.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1343179491.5132.112.camel@deadeye.wl.decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6PEnIGd015952

Ben,

At the outset I want to thank you for taking the time to review this code. Given that Greg
has indicated that he will not be able to look at this patch set till 3.6 and the nature of review
comments I have gotten from you and others, I will re-spin this patch set to address all the
comments I have gotten to date. Specific responses to your comments are in-line.

Regards,

K. Y 

> -----Original Message-----
> From: Ben Hutchings [mailto:ben@decadent.org.uk]
> Sent: Tuesday, July 24, 2012 9:25 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; olaf@aepfle.de;
> apw@canonical.com; netdev@vger.kernel.org
> Subject: Re: [PATCH 13/17] Tools: hv: Implement the KVP verb -
> KVP_OP_SET_IP_INFO
> 
> On Tue, 2012-07-24 at 09:01 -0700, K. Y. Srinivasan wrote:
> > Implement the KVP verb - KVP_OP_SET_IP_INFO. This operation configures
> the
> > specified interface based on the given configuration. Since configuring
> > an interface is very distro specific, we invoke an external script to
> > configure the interface.
> [...]
> > +static int kvp_write_file(FILE *f, char *s1, char *s2, char *s3)
> > +{
> > +	char str[256];
> > +	int error;
> > +
> > +	memset(str, 0, sizeof(str));
> > +	strcat(str, s1);
> > +	if (s2 != NULL)
> > +		strcat(str, s2);
> > +	strcat(str, "=");
> > +	strcat(str, s3);
> > +	strcat(str, "\n");
> > +
> > +	error = fputs(str, f);
> 
> This style of string pasting is crazy; have you never heard of
> fprintf()?
> 
> [...]
> > +	/*
> > +	 * Set the configuration for the specified interface with
> > +	 * the information provided. Since there is no standard
> > +	 * way to configure an interface, we will have an external
> > +	 * script that does the job of configuring the interface and
> > +	 * flushing the configuration.
> > +	 *
> > +	 * The parameters passed to this external script are:
> > +	 * 1. A configuration file that has the specified configuration.
> > +	 *
> > +	 * We will embed the name of the interface in the configuration
> > +	 * file: ifcfg-ethx (where ethx is the interface name).
> > +	 *
> > +	 * Here is the format of the ip configuration file:
> > +	 *
> > +	 * HWADDR=macaddr
> 
> Is the interface supposed to be matched by name or by MAC address?

I do not dictate that. My plan was to package all the information I have about
the interface and the desired configuration in a file and invoke the external
distro specific script to do its magic. This external  script is free to ignore 
what it does not need.

> 
> > +	 * BOOTPROTO=dhcp (dhcp enabled for the interface)
> 
> The BOOTPROTO line may or may not appear.
> 
> > +	 * NM_CONTROLLED=no (this interface will not be controlled by NM)
> > +	 * PEERDNS=yes
> 
> I wonder what the point is of including constant lines in the file.
> What is the external script supposed to do if it these apparent
> constants change in future?

As you can see, I did my testing on a RHEL system and I was too lazy to create
a RHEL specific config file in the external script and so I ended up creating pretty much
the config file needed by RHEL in this daemon. All the external script had to do was to
simply copy this file into the right location and bring up the interface. So, if you prefer
that we not populate the config file with these constant lines, I can get rid of them.
As I noted earlier external scripts may not choose to use all the information in the file
that this daemon generates. What I have done here, simplifies the external script
at least for one distro.

> 
> > +	 * IPADDR_x=ipaddr
> > +	 * NETMASK_x=netmask
> > +	 * GATEWAY_x=gateway
> > +	 * DNSx=dns
> 
> A strangely familiar format...
> 
> > +	 * IPV6 addresses will be tagged as IPV6ADDR, IPV6 gateway will be
> > +	 * tagged as IPV6_DEFAULTGW and IPV6 NETMASK will be tagged as
> > +	 * IPV6NETMASK.
> > +	 */
> > +
> > +	memset(if_file, 0, sizeof(if_file));
> > +	strcat(if_file, "/var/opt/hyperv/ifcfg-");
> 
> Like I said before about the key-value files, this should be under
> /var/lib if the daemon is included in a distribution.  You should
> perhaps use a macro for the "/var/opt" part so it can be overridden
> depending on whether it's built as a distribution or add-on package.

I will make this a macro.

> 
> > +	strcat(if_file, if_name);
> > +
> > +	file = fopen(if_file, "w");
> > +
> > +	if (file == NULL) {
> > +		syslog(LOG_ERR, "Failed to open config file");
> > +		return HV_E_FAIL;
> > +	}
> > +
> > +	/*
> > +	 * First write out the MAC address.
> > +	 */
> > +
> > +	mac_addr = kvp_if_name_to_mac(if_name);
> > +	if (mac_addr == NULL) {
> > +		error = HV_E_FAIL;
> > +		goto setval_error;
> > +	}
> > +
> > +	error = kvp_write_file(file, "HWADDR", NULL, mac_addr);
> > +	if (error)
> > +		goto setval_error;
> > +
> > +	error = kvp_write_file(file, "ONBOOT", NULL, "yes");
> > +	if (error)
> > +		goto setval_error;
> > +
> > +	error = kvp_write_file(file, "IPV6INIT", NULL, "yes");
> > +	if (error)
> > +		goto setval_error;
> [...]
> 
> This line isn't mentioned in the above comment.
> 
> Ben.
> 
> --
> Ben Hutchings
> If more than one person is responsible for a bug, no one is at fault.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
