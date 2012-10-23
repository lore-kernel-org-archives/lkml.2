Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab2JWOZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:25:43 -0400
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.25]:31401
	"EHLO na01-bl2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751789Ab2JWOZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:25:42 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -8
X-BigFish: PS-8(zz98dI9371I542M1432Izz1202h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: 3.7 RC1
Thread-Topic: 3.7 RC1
Thread-Index: AQHNsOIGU0KUrLGfdEyGNzYIQgNVg5fGw7oA
Date: Tue, 23 Oct 2012 14:24:58 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930A45A90@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1350949065-24655-1-git-send-email-kys@microsoft.com>
 <20121023054716.GA20120@mwanda>
In-Reply-To: <20121023054716.GA20120@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ORACLE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464001)(24454001)(51704002)(377454001)(47446002)(53806001)(51856001)(44976002)(16676001)(5343635001)(31966008)(74502001)(33656001)(46102001)(74662001)(47776002)(48376001)(42186003)(49866001)(1076001)(876001)(2666001)(47736001)(3846001)(50986001)(50466001)(4196001)(5836001)(6806001)(20776001)(4396001)(16616001)(8716001)(16696001)(47976001)(316001)(3556001)(3746001)(37146003);DIR:OUT;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0643BDA83C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Tuesday, October 23, 2012 1:47 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: 3.7 RC1
> 
> On Mon, Oct 22, 2012 at 04:37:45PM -0700, K. Y. Srinivasan wrote:
> >
> > While testing 3.7 RC1 I discovered that invoking the function
> orderly_poweroff()
> > from an interrupt context will trigger an ASSERT(). This was not the case till
> > recently. The comment preceding the orderly_poweroff() function claims that
> this
> > function can be invoked from any context and in the current Hyper-V util driver,
> > we support host-driven orderly shut down of the guest by invoking this
> > orderly_poweroff() function in the context of the message callback. This code
> has
> > been working for a very long time and it is broken now. Is my assumption that
> > orderly_poweroff() could be invoked from the interrupt context a wrong
> assumption?
> 
> You can't call orderly_poweroff() from interrupt context.

Thanks Dan; I am curious  to understand the basis for your assertion.
As I noted earlier  the documentation for this function clearly says it can
be called from any context. Furthermore, __orderly_poweroff(), the helper
function allocates memory with the GFP_ATOMIC flag set. Lastly, the behavior
of orderly_poweroff() has been such that this function could be called from interrupt context
for a very long time and something has changed now. For what it is worth, there are other users in
the kernel (in 3.7 RC1) that are invoking the orderly_poweroff() function from interrupt
context other than the Hyper-V shutdown handler:  fsl_hv_shutdown_isr() in drivers/virt/fsl_hypervisor.c.
I suspect there are other users as well that have made this similar assumption.


Regards,

K. Y




