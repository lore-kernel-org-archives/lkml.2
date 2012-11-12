Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2KLXAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:00:55 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.32]:36242
	"EHLO na01-by2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752267Ab2KLXAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:00:53 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
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
        "yinghan@google.com" <yinghan@google.com>,
        "dan.magenheimer@oracle.com" <dan.magenheimer@oracle.com>
Subject: RE: [PATCH 1/1] mm: Export a function to read vm_committed_as
Thread-Topic: [PATCH 1/1] mm: Export a function to read vm_committed_as
Thread-Index: AQHNv7DISCAw0NqBFkOLHpdn/+FFI5fj6u+AgABoguCAAm2CAIAAAQFA
Date: Mon, 12 Nov 2012 22:58:11 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E39FBC@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1352600728-17766-1-git-send-email-kys@microsoft.com>
 <alpine.DEB.2.00.1211101830250.18494@chino.kir.corp.google.com>
 <426367E2313C2449837CD2DE46E7EAF930E35B45@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <alpine.DEB.2.00.1211121349130.23347@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211121349130.23347@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [60.247.110.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
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
X-FOPE-CONNECTOR: Id%59$Dn%ORACLE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(51914002)(377454001)(24454001)(13464001)(74662001)(54316001)(33656001)(23726001)(5343635001)(54356001)(46102001)(51856001)(16676001)(74502001)(53806001)(76482001)(47736001)(49866001)(46406002)(44976002)(50466001)(47446002)(50986001)(6806001)(47776002)(4396001)(31966008)(47976001)(55846005);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0663390E1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Rientjes [mailto:rientjes@google.com]
> Sent: Monday, November 12, 2012 4:54 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> kamezawa.hiroyuki@gmail.com; mhocko@suse.cz; hannes@cmpxchg.org;
> yinghan@google.com
> Subject: RE: [PATCH 1/1] mm: Export a function to read vm_committed_as
> 
> On Sun, 11 Nov 2012, KY Srinivasan wrote:
> 
> > Thanks for the prompt response. For the Linux balloon driver for Hyper-V, I
> need access
> > to the metric that reflects the system wide memory commitment made by the
> guest kernel.
> > In the Hyper-V case, this information is one of the many metrics used to drive
> the policy engine
> > on the host. Granted, the interface name I have chosen here could be more
> generic; how about
> > read_mem_commit_info(void). I am open to suggestions here.
> >
> 
> I would suggest vm_memory_committed() and there shouldn't be a comment
> describing that this is just a wrapper for modules to read
> vm_committed_as, that's apparent from the implementation: it should be
> describing exactly what this value represents and why it is a useful
> metric (at least in the case that you're concerned about).

Will do; thanks.
> 
> > With regards to making changes to the Xen self ballooning code, I would like to
> separate that patch
> > from the patch that implements the exported mechanism to access the
> memory commitment information.
> 
> Why?  Is xen using it for a different inference?

I think it is good to separate these patches. Dan (copied here) wrote the code for the
Xen self balloon driver. If it is ok with him I can submit the patch for Xen as well. 


Regards,

K. Y



> 


