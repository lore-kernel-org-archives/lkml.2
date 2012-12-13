Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab2LMPdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:33:31 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.30]:10025
	"EHLO NA01-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab2LMPd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:33:29 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BLUPR03MB051;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: balloon: Fix a memory leak
Thread-Topic: [PATCH 1/1] Drivers: hv: balloon: Fix a memory leak
Thread-Index: AQHN18/BVRsjwO5gcUuUGGMvd7DphJgWe10AgABhtuA=
Date: Thu, 13 Dec 2012 15:29:58 +0000
Message-ID: <be0dc05173404e6f8bba143a053b3823@BLUPR03MB050.namprd03.prod.outlook.com>
References: <1355252837-9827-1-git-send-email-kys@microsoft.com>
 <20121213093740.GW6568@mwanda>
In-Reply-To: <20121213093740.GW6568@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: BL2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ORACLE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454001)(377454001)(13464002)(51704002)(54316002)(46102001)(23726001)(50466001)(56776001)(47976001)(49866001)(50986001)(47736001)(16676001)(51856001)(47776002)(5343635001)(33646001)(74662001)(44976002)(31966008)(6806001)(46406002)(77982001)(53806001)(47446002)(56816002)(54356001)(76482001)(59766001)(74502001)(4396001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB039;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0694C54398
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Thursday, December 13, 2012 4:38 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: balloon: Fix a memory leak
> 
> On Tue, Dec 11, 2012 at 11:07:17AM -0800, K. Y. Srinivasan wrote:
> > -probe_error1:
> > +probe_error2:
> >  	kthread_stop(dm_device.thread);
> >
> > -probe_error0:
> > +probe_error1:
> >  	vmbus_close(dev->channel);
> > +probe_error0:
> > +	kfree(send_buffer);
> 
> If you used labels that describe what the code does instead of
> GW-BASIC labels then you wouldn't need to rename them.
> 
> err_stop_thread:
> 	kthread_stop(dm_device.thread);
> err_close_vmbus:
> 	vmbus_close(dev->channel);
> err_free_send_buf:
> 	kfree(send_buffer);

Thanks Dan. I am not sure how this labeling scheme would work in general where each error
recovery block is a collection of rollback operation. I see your point though.

Regards,

K. Y 
 


