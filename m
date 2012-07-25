Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2GYNNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:13:24 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:41694
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754130Ab2GYNNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:13:23 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -13
X-BigFish: VS-13(zz98dI9371I542M1432Izz1202hzz8275bh186Mz2fh2a8h683h839h93fhd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>
Subject: RE: [PATCH 1/1] Drivers: hv: Cleanup the guest ID computation
Thread-Topic: [PATCH 1/1] Drivers: hv: Cleanup the guest ID computation
Thread-Index: AQHNae+sL9Mcy5ytHkK/2crRs+eVQZc5p8uAgABSL0A=
Date: Wed, 25 Jul 2012 13:12:20 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236A8ADA@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1343171518-15189-1-git-send-email-kys@microsoft.com>
 <20120725081647.GB22443@aepfle.de>
In-Reply-To: <20120725081647.GB22443@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6PDDU4d015425



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Wednesday, July 25, 2012 4:17 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com
> Subject: Re: [PATCH 1/1] Drivers: hv: Cleanup the guest ID computation
> 
> On Tue, Jul 24, K. Y. Srinivasan wrote:
> 
> 
> > +/*
> > + * The guest OS needs to register the guest ID with the hypervisor.
> > + * The guest ID is a 64 bit entity and the structure of this ID is
> > + * specified in the Hyper-V specification:
> > + *
> > + * http://msdn.microsoft.com/en-us/library/windows/
> > + * hardware/ff542653%28v=vs.85%29.aspx
> > + *
> > + * While the current guideline does not specify how Linux guest ID(s)
> > + * need to be generated, our plan is to publish the guidelines for
> > + * Linux and other guest operating systems that currently are hosted
> > + * on Hyper-V. The implementation here conforms to this yet
> > + * unpublished guidelines.
> > + *
> > + *
> > + * Bit(s)
> > + * 63 - Indicates if the OS is Open Source or not; 1 is Open Source
> > + * 62:56 - Os Type; Linux is 0x100
> > + * 55:48 - Distro specific identification
> > + * 47:16 - Linux kernel version number
> > + * 15:0  - Distro specific identification
> > + *
> > + *
> > + */
> > +
> > +#define HV_LINUX_VENDOR_ID		0x8100
> 
> I suggest to drop bit 63, why would the hypervisor care about that
> weird detail?

Hypervisor does not care, but on the host side we plan to use this to track
the kind of guest operating systems currently hosted.

Regards,

K. Y
 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
