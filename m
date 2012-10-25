Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab2JYOZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:25:47 -0400
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.23]:46326
	"EHLO NA01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759628Ab2JYOZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:25:43 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: 0
X-BigFish: PS0(za62pz98dI9371I542M1432Izz1202h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 3/3] Drivers: hv: Get rid of hv_ringbuffer_cleanup()
Thread-Topic: [PATCH 3/3] Drivers: hv: Get rid of hv_ringbuffer_cleanup()
Thread-Index: AQHNqLSODguR4KuZZkulpaQY6eE9PpfJIR4AgAD65hA=
Date: Thu, 25 Oct 2012 14:13:28 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930A468BC@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1350073335-10575-1-git-send-email-kys@microsoft.com>
 <1350073363-10614-1-git-send-email-kys@microsoft.com>
 <1350073363-10614-3-git-send-email-kys@microsoft.com>
 <20121024224528.GA30009@kroah.com>
In-Reply-To: <20121024224528.GA30009@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(377454001)(24454001)(13464001)(5343635001)(47446002)(16696001)(50986001)(47976001)(16616001)(16676001)(20776001)(46102001)(49866001)(74502001)(876001)(50466001)(1076001)(51856001)(4396001)(5836001)(2666001)(74662001)(47776002)(44976002)(31966008)(3846001)(6806001)(8716001)(47736001)(53806001)(33656001)(48376001)(54356001)(4196001)(54316001)(316001)(26583001)(3746001)(3556001);DIR:OUT;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0645BEB7AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, October 24, 2012 6:45 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 3/3] Drivers: hv: Get rid of hv_ringbuffer_cleanup()
> 
> On Fri, Oct 12, 2012 at 01:22:43PM -0700, K. Y. Srinivasan wrote:
> > hv_ringbuffer_cleanup() is an empty function; get rid of it.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reported-by: Jason Wang <jasowang@redhat.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/hv/channel.c      |    4 ----
> >  drivers/hv/hyperv_vmbus.h |    1 -
> >  drivers/hv/ring_buffer.c  |   11 -----------
> >  3 files changed, 0 insertions(+), 16 deletions(-)
> 
> That's nice, but this patch causes build failures, so I can't accept it.
> 
> Please test your patches better (hint, a simple 'git grep' would have
> worked here...)

Sorry about that. I am pretty sure I built (with this patch) both vmbus and the util drivers.
This function is  a private function for the vmbus driver and in fact I went back and rebuilt the
drivers in the hv directory without any problem (with this patch applied) in the same tree where
I developed these patches (linux-next tree dated October 2, 2012). Specifically, what was
the build problem you ran into.

Regards,

K. Y


