Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2GaKe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:34:56 -0400
Received: from [213.199.154.204] ([213.199.154.204]:2881 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753302Ab2GaKev convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:34:51 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I542M1432I1418Izz1202hzz8275dhz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 13/17] Tools: hv: Implement the KVP verb -
 KVP_OP_SET_IP_INFO
Thread-Topic: [PATCH 13/17] Tools: hv: Implement the KVP verb -
 KVP_OP_SET_IP_INFO
Thread-Index: AQHNabffApGkoXQ/oEyNNUVPYtB2bpdCJ8sAgAADC6CAABIigIAA/ULQ
Date: Tue, 31 Jul 2012 10:34:03 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236AA976@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-13-git-send-email-kys@microsoft.com>
 <20120730180326.GB533@aepfle.de>
 <426367E2313C2449837CD2DE46E7EAF9236AA7DB@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120730191912.GH1894@decadent.org.uk>
In-Reply-To: <20120730191912.GH1894@decadent.org.uk>
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
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ben Hutchings [mailto:ben@decadent.org.uk]
> Sent: Monday, July 30, 2012 3:19 PM
> To: KY Srinivasan
> Cc: Olaf Hering; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; netdev@vger.kernel.org
> Subject: Re: [PATCH 13/17] Tools: hv: Implement the KVP verb -
> KVP_OP_SET_IP_INFO
> 
> On Mon, Jul 30, 2012 at 06:32:15PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Olaf Hering [mailto:olaf@aepfle.de]
> > > Sent: Monday, July 30, 2012 2:03 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; apw@canonical.com; netdev@vger.kernel.org;
> > > ben@decadent.org.uk
> > > Subject: Re: [PATCH 13/17] Tools: hv: Implement the KVP verb -
> > > KVP_OP_SET_IP_INFO
> > >
> > > On Tue, Jul 24, K. Y. Srinivasan wrote:
> > >
> > > > +	/*
> > > > +	 * Set the configuration for the specified interface with
> > > > +	 * the information provided. Since there is no standard
> > > > +	 * way to configure an interface, we will have an external
> > > > +	 * script that does the job of configuring the interface and
> > > > +	 * flushing the configuration.
> > > > +	 *
> > > > +	 * The parameters passed to this external script are:
> > > > +	 * 1. A configuration file that has the specified configuration.
> > >
> > > Maybe this should be written as 'A info file that has the requested
> > > network configuration' or something like that.
> >
> > That is the idea. This configuration file simply reflects all the
> > information we have perhaps with some additional constant
> > information. The script is free to ignore what it does not need.
> [...]
> 
> This does not strike me as a sensible interface.  If scripts are
> 'free to ignore' information then the KVP interface becomes unreliable
> as a means for managing networking on Linux guests.  I would suggest
> that at the least the script should be able to report that it did not
> recognise some parts of the configuration.  This would be logged
> and/or reported back to the hypervisor.
> 
> (This is separate from the issue of constant configuration lines;
> for some distributions the script might recognise but ignore them
> because they have no use on that distribution.  I don't see the
> point in constant lines, but they don't seem to result in any
> unreliability.)

Ben,

I see your point. I have cleaned up the contents of the KVP produced
configuration file to not include constant information that can be
auto generated by the distro specific script if it needs to. Also, I have
tried to make the documentation of the contents of the file a little
better. I will send out these new patches soon. Still, there is a possibility that
some of the content of this file may be redundant on a specific distro and I think
that should be fine. For instance, per Olaf's suggestion, I have included a line that
specifies the interface name in the file (in addition to the mac address). Given the
current format of the name of the config file (where the interface name is embedded
in the config file name, this additional name entry may be redundant on some distros.

Once again, thank you for taking the time to review this code.

Regards,

K. Y 


