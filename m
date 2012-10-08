Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab2JHOyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 10:54:03 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:50954
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779Ab2JHOx7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 10:53:59 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz9371I542M1432Izz1202h1d1ah1d2ahzz8275bh8275dhz2fh2a8h683h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Rusty Russell <rusty@ozlabs.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: RE: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
Thread-Topic: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
Thread-Index: AQHNpOUXgnwlsoeYd0afghaYt4KseJeu5pOAgACYMjA=
Date: Mon, 8 Oct 2012 14:53:39 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930A1FC60@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
 <1349654386-18378-1-git-send-email-kys@microsoft.com>
 <1349654386-18378-2-git-send-email-kys@microsoft.com>
 <87obkdpld8.fsf@rustcorp.com.au>
In-Reply-To: <87obkdpld8.fsf@rustcorp.com.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%OZLABS.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Rusty Russell [mailto:rusty@ozlabs.org]
> Sent: Monday, October 08, 2012 1:46 AM
> To: KY Srinivasan; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> akpm@linux-foundation.org; andi@firstfloor.org
> Cc: KY Srinivasan
> Subject: Re: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
> 
> "K. Y. Srinivasan" <kys@microsoft.com> writes:
> > +static int hot_add;
> > +
> > +module_param(hot_add, int, S_IRUGO);
> > +MODULE_PARM_DESC(hot_add, "If set attempt memory hot_add");
> 
> I think this should be a 'bool', but I can't tell, since it's not used
> in this patch.

You are right; currently, I unconditionally fail the hot add request. Hopefully,
I will soon be able to support hot add once I get the needed host side
changes.

Regards,

K. Y


