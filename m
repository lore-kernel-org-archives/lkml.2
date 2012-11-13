Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2KMFcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:32:07 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.27]:47618
	"EHLO na01-by2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750779Ab2KMFcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:32:05 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -4
X-BigFish: PS-4(zz98dI9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0l1155h)
From: KY Srinivasan <kys@microsoft.com>
To: David Rientjes <rientjes@google.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Konrad Wilk <konrad.wilk@oracle.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Thread-Index: AQHNv7DISCAw0NqBFkOLHpdn/+FFI5fj6u+AgABoguCAAm2CAIAAAQFAgAAaioCAAATFgIAAXTgA
Date: Tue, 13 Nov 2012 05:24:57 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E3E0B5@BL2PRD0310MB375.namprd03.prod.outlook.com>
References: <1352600728-17766-1-git-send-email-kys@microsoft.com>
 <alpine.DEB.2.00.1211101830250.18494@chino.kir.corp.google.com>
 <426367E2313C2449837CD2DE46E7EAF930E35B45@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <alpine.DEB.2.00.1211121349130.23347@chino.kir.corp.google.com>
 <426367E2313C2449837CD2DE46E7EAF930E39FBC@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <c04bb062-bbce-4980-b2b3-fbbb18e64b66@default>
 <alpine.DEB.2.00.1211121547450.3841@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211121547450.3841@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [207.46.92.17]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: BL2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOGLE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ORACLE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
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
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(51704002)(24454001)(13464001)(47776002)(46406002)(6806001)(53806001)(49866001)(50466001)(31966008)(44976002)(46102001)(16676001)(23726001)(47976001)(50986001)(4396001)(51856001)(74662001)(76482001)(54316001)(47736001)(54356001)(5343635001)(74502001)(47446002)(33656001)(55846005);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 06640999CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Rientjes [mailto:rientjes@google.com]
> Sent: Monday, November 12, 2012 6:49 PM
> To: Dan Magenheimer
> Cc: KY Srinivasan; Konrad Wilk; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; andi@firstfloor.org; akpm@linux-foundation.org; linux-
> mm@kvack.org; kamezawa.hiroyuki@gmail.com; mhocko@suse.cz;
> hannes@cmpxchg.org; yinghan@google.com
> Subject: RE: [PATCH 1/1] mm: Export a function to read vm_committed_as
> 
> On Mon, 12 Nov 2012, Dan Magenheimer wrote:
> 
> > > > Why?  Is xen using it for a different inference?
> > >
> > > I think it is good to separate these patches. Dan (copied here) wrote the code
> for the
> > > Xen self balloon driver. If it is ok with him I can submit the patch for Xen as
> well.
> >
> > Hi KY --
> >
> > If I understand correctly, this would be only a cosmetic (function renaming)
> change
> > to the Xen selfballooning code.  If so, then I will be happy to Ack when I
> > see the patch.  However, Konrad (konrad.wilk@oracle.com) is the maintainer
> > for all Xen code so you should ask him... and (from previous painful experience)
> > it can be difficult to sync even very simple interdependent changes going
> through
> > different maintainers without breaking linux-next.  So I can't offer any
> > help with that process, only commiseration. :-(
> >
> 
> I think this should be done in the same patch as the function getting
> introduced with a cc to Konrad and routed through -mm; even better,
> perhaps he'll have some useful comments for how this is used for xen that
> can be included for context.
> 
Ok; I will send out a single patch. I am hoping this can be applied soon as Hyper-V balloon
driver is queued behind this.

Regards,

K. Y



