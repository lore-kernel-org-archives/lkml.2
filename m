Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab2GTQEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:04:13 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:47321
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805Ab2GTQEL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:04:11 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371Ic89bh542M1432Izz1202hzz8275dhz2fh2a8h683h839hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        =?iso-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH] drivers: hv: use Linux version in guest ID
Thread-Topic: [PATCH] drivers: hv: use Linux version in guest ID
Thread-Index: AQHNZk4sz22otdtLA02vi0WZ/MgtdpcyS40AgAADHNA=
Date: Fri, 20 Jul 2012 16:02:44 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF923547836@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <87fw8mlv7e.fsf@nemi.mork.no>
 <1342771388-24389-1-git-send-email-bjorn@mork.no>
 <20120720152650.GA5201@kroah.com>
In-Reply-To: <20120720152650.GA5201@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%MORK.NO$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, July 20, 2012 11:27 AM
> To: Bjørn Mork
> Cc: KY Srinivasan; Paolo Bonzini; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH] drivers: hv: use Linux version in guest ID
> 
> On Fri, Jul 20, 2012 at 10:03:08AM +0200, Bjørn Mork wrote:
> > Use OS version number in the guest ID as recommended by Microsoft
> >
> > Signed-off-by: Bjørn Mork <bjorn@mork.no>
> > ---
> > So how about something like this?  Yes, I know including
> > linux/version.h often is unwanted, but the spec does
> > recommend using the actual OS version in the guest ID
> >
> > Yes, this will be offensive again when Linux is at
> > version 181.0, but we might have found a better solution by
> > then :-)
> >
> >
> >  drivers/hv/hyperv_vmbus.h |   20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> > index b9426a6..cc0c3f0 100644
> > --- a/drivers/hv/hyperv_vmbus.h
> > +++ b/drivers/hv/hyperv_vmbus.h
> > @@ -29,6 +29,7 @@
> >  #include <asm/sync_bitops.h>
> >  #include <linux/atomic.h>
> >  #include <linux/hyperv.h>
> > +#include <linux/version.h>
> >
> >  /*
> >   * The below CPUID leaves are present if
> VersionAndFeatures.HypervisorPresent
> > @@ -410,10 +411,21 @@ enum {
> >
> >  #define HV_PRESENT_BIT			0x80000000
> >
> > -#define HV_LINUX_GUEST_ID_LO		0x00000000
> > -#define HV_LINUX_GUEST_ID_HI		0xB16B00B5
> > -#define HV_LINUX_GUEST_ID		(((u64)HV_LINUX_GUEST_ID_HI
> << 32) | \
> > -					   HV_LINUX_GUEST_ID_LO)
> > +/* Linux vendor ID allocated by Microsoft */
> > +#define HV_LINUX_GUEST_ID_VENDOR	0xB16B
> > +
> > +/* Creating a guest ID conforming to the encoding recommended by
> > + * Microsoft, with variant and build fixed to 0
> 
> We could use the kernel build number here as well, if we really wanted
> it, right?
> 
> Otherwise, I like this patch, KY, any objection to me taking it?

Greg,

If it is ok with you can we wait a couple of days. I am pushing to get information
back from folks within MSFT. I am hoping  we can fix this issue soon.

Regards,

K. Y
 



