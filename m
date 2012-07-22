Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab2GVPQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 11:16:36 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:18912
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395Ab2GVPQe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 11:16:34 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -13
X-BigFish: VS-13(zz98dI9371Ic89bh3166M542M1432Izz1202hzz8275dhz2fh2a8h683h839hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: =?iso-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] drivers: hv: use Linux version in guest ID
Thread-Topic: [PATCH] drivers: hv: use Linux version in guest ID
Thread-Index: AQHNZk4sz22otdtLA02vi0WZ/MgtdpcyS40AgAADHNCAAAjsgIADE7xg
Date: Sun, 22 Jul 2012 15:16:25 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF923548B6B@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <87fw8mlv7e.fsf@nemi.mork.no>
 <1342771388-24389-1-git-send-email-bjorn@mork.no>
 <20120720152650.GA5201@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF923547836@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120720160953.GA5802@kroah.com>
In-Reply-To: <20120720160953.GA5802@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%MORK.NO$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, July 20, 2012 12:10 PM
> To: KY Srinivasan
> Cc: Bjørn Mork; Paolo Bonzini; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] drivers: hv: use Linux version in guest ID
> 
> On Fri, Jul 20, 2012 at 04:02:44PM +0000, KY Srinivasan wrote:
> > > On Fri, Jul 20, 2012 at 10:03:08AM +0200, Bjørn Mork wrote:
> > > > Use OS version number in the guest ID as recommended by Microsoft
> > > >
> > > > Signed-off-by: Bjørn Mork <bjorn@mork.no>
> > > > ---
> > > > So how about something like this?  Yes, I know including
> > > > linux/version.h often is unwanted, but the spec does
> > > > recommend using the actual OS version in the guest ID
> > > >
> > > > Yes, this will be offensive again when Linux is at
> > > > version 181.0, but we might have found a better solution by
> > > > then :-)
> > > >
> > > >
> > > >  drivers/hv/hyperv_vmbus.h |   20 ++++++++++++++++----
> > > >  1 file changed, 16 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> > > > index b9426a6..cc0c3f0 100644
> > > > --- a/drivers/hv/hyperv_vmbus.h
> > > > +++ b/drivers/hv/hyperv_vmbus.h
> > > > @@ -29,6 +29,7 @@
> > > >  #include <asm/sync_bitops.h>
> > > >  #include <linux/atomic.h>
> > > >  #include <linux/hyperv.h>
> > > > +#include <linux/version.h>
> > > >
> > > >  /*
> > > >   * The below CPUID leaves are present if
> > > VersionAndFeatures.HypervisorPresent
> > > > @@ -410,10 +411,21 @@ enum {
> > > >
> > > >  #define HV_PRESENT_BIT			0x80000000
> > > >
> > > > -#define HV_LINUX_GUEST_ID_LO		0x00000000
> > > > -#define HV_LINUX_GUEST_ID_HI		0xB16B00B5
> > > > -#define HV_LINUX_GUEST_ID		(((u64)HV_LINUX_GUEST_ID_HI
> > > << 32) | \
> > > > -					   HV_LINUX_GUEST_ID_LO)
> > > > +/* Linux vendor ID allocated by Microsoft */
> > > > +#define HV_LINUX_GUEST_ID_VENDOR	0xB16B
> > > > +
> > > > +/* Creating a guest ID conforming to the encoding recommended by
> > > > + * Microsoft, with variant and build fixed to 0
> > >
> > > We could use the kernel build number here as well, if we really wanted
> > > it, right?
> > >
> > > Otherwise, I like this patch, KY, any objection to me taking it?
> >
> > Greg,
> >
> > If it is ok with you can we wait a couple of days. I am pushing to get information
> > back from folks within MSFT. I am hoping  we can fix this issue soon.
> 
> Ok, I'll hold on to it for a week or so.

Greg,

While there is some dependency on the current Linux guest ID, we will go ahead and
change the guest ID for Linux to conform to MSFT documented guidelines. Over the next
couple of days, we are planning on finalizing the ID namespace for non-windows guests
on Hyper-V. I will post our proposal on this mailing list soon. 

Regards,

K. Y
> 
> thanks,
> 
> greg k-h
> 
> 



