Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab2KLVjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:39:41 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.23]:16714
	"EHLO na01-bl2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752157Ab2KLVjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:39:35 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -5
X-BigFish: PS-5(zz98dI9371I542M1432I1447Izz1de0h1202h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0l1155h)
From: KY Srinivasan <kys@microsoft.com>
To: David Rientjes <rientjes@google.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>
Subject: RE: [PATCH 1/1] mm: Export a function to read vm_committed_as
Thread-Topic: [PATCH 1/1] mm: Export a function to read vm_committed_as
Thread-Index: AQHNv7DISCAw0NqBFkOLHpdn/+FFI5fj6u+AgABoguCAAmgXYA==
Date: Mon, 12 Nov 2012 21:36:10 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E39F5B@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1352600728-17766-1-git-send-email-kys@microsoft.com>
 <alpine.DEB.2.00.1211101830250.18494@chino.kir.corp.google.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [60.247.110.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOGLE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KVACK.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CMPXCHG.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(24454001)(51914002)(13464001)(51704002)(44976002)(33656001)(47446002)(47736001)(76482001)(49866001)(74662001)(51856001)(4396001)(50986001)(54316001)(74502001)(47776002)(53806001)(23726001)(46102001)(31966008)(47976001)(46406002)(54356001)(16676001)(6806001)(50466001)(5343635001)(55846005);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0663390E1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: KY Srinivasan
> Sent: Sunday, November 11, 2012 4:24 AM
> To: 'David Rientjes'
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> kamezawa.hiroyuki@gmail.com; mhocko@suse.cz; hannes@cmpxchg.org;
> yinghan@google.com
> Subject: RE: [PATCH 1/1] mm: Export a function to read vm_committed_as
> 
> 
> 
> > -----Original Message-----
> > From: David Rientjes [mailto:rientjes@google.com]
> > Sent: Saturday, November 10, 2012 9:35 PM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> > kamezawa.hiroyuki@gmail.com; mhocko@suse.cz; hannes@cmpxchg.org;
> > yinghan@google.com
> > Subject: Re: [PATCH 1/1] mm: Export a function to read vm_committed_as
> >
> > On Sat, 10 Nov 2012, K. Y. Srinivasan wrote:
> >
> > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > index 2d94235..e527239 100644
> > > --- a/mm/mmap.c
> > > +++ b/mm/mmap.c
> > > @@ -89,6 +89,17 @@ int sysctl_max_map_count __read_mostly =
> > DEFAULT_MAX_MAP_COUNT;
> > >  struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
> > >
> > >  /*
> > > + * A wrapper to read vm_committed_as that can be used by external
> > modules.
> > > + */
> > > +
> > > +unsigned long read_vm_committed_as(void)
> > > +{
> > > +	return percpu_counter_read_positive(&vm_committed_as);
> > > +}
> > > +
> > > +EXPORT_SYMBOL_GPL(read_vm_committed_as);
> > > +
> > > +/*
> > >   * Check that a process has enough memory to allocate a new virtual
> > >   * mapping. 0 means there is enough memory for the allocation to
> > >   * succeed and -ENOMEM implies there is not.
> >
> > This is precisely what I didn't want to see; I was expecting that this
> > function was going to have some name that would describe what a hypervisor
> > would use it for, regardless of its implementation and current use of
> > vm_committed_as.  read_vm_committed_as() misses the entire point of the
> > suggestion and a few people have mentioned that they think this
> > implementation will evolve over time.
> >
> > Please think of what you're trying to determine in the code that will
> > depend on this and then convert the existing user in
> > drivers/xen/xen-selfballoon.c.
> 
> David,
> 
> Thanks for the prompt response. For the Linux balloon driver for Hyper-V, I need
> access
> to the metric that reflects the system wide memory commitment made by the
> guest kernel.
> In the Hyper-V case, this information is one of the many metrics used to drive the
> policy engine
> on the host. Granted, the interface name I have chosen here could be more
> generic; how about
> read_mem_commit_info(void). I am open to suggestions here.
> 
> With regards to making changes to the Xen self ballooning code, I would like to
> separate that patch
> from the patch that implements the exported mechanism to access the memory
> commitment information.
> Once we settle on this patch, I can submit the patch to fix the Xen self ballooning
> driver to use this new
> interface along with the Hyper-V balloon driver that is currently blocked on
> resolving this issue.

David,

I want to finalize this ASAP. Please give me your feedback so I can move this forward.

Regards,

K. Y


