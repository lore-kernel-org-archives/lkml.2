Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab2JRNgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:36:17 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:27804 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab2JRNgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:36:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,607,1344211200"; 
   d="scan'208";a="15255810"
Date: Thu, 18 Oct 2012 14:35:51 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH 5/6] xen: arm: implement remap interfaces needed for
 privcmd mappings.
In-Reply-To: <1350567209.2460.145.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1210181434420.2689@kaball.uk.xensource.com>
References: <1350473518.2460.58.camel@zakaz.uk.xensource.com>  <1350473532-15863-5-git-send-email-ian.campbell@citrix.com>  <alpine.DEB.2.02.1210181426090.2689@kaball.uk.xensource.com> <1350567209.2460.145.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Ian Campbell wrote:
> On Thu, 2012-10-18 at 14:27 +0100, Stefano Stabellini wrote:
> > On Wed, 17 Oct 2012, Ian Campbell wrote:
> > > We use XENMEM_add_to_physmap_range which is the preferred interface
> > > for foreign mappings.
> > > 
> > > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > 
> > It looks OK but there are few code style issues, please run the patch
> > through checkpatch.
> 
> The only one I get is:
> WARNING: please, no spaces at the start of a line
> #83: FILE: include/xen/interface/memory.h:175:
> +    uint16_t    size;$
> 
> total: 0 errors, 1 warnings, 64 lines checked
> 
> The prevailing indentation in that file is 4 spaces so I think we should
> ignore the warning in this case in the interests of consistency with the
> surrounding code.

Strange, I get:

ERROR: spaces required around that '=' (ctx:VxV)
#140: FILE: arch/arm/xen/enlighten.c:130:
+       for (i=0; i<nr; i++) {
              ^

ERROR: spaces required around that '<' (ctx:VxV)
#140: FILE: arch/arm/xen/enlighten.c:130:
+       for (i=0; i<nr; i++) {
                   ^

WARNING: please, no spaces at the start of a line
#185: FILE: include/xen/interface/memory.h:196:
+    domid_t domid;$

WARNING: please, no spaces at the start of a line
#186: FILE: include/xen/interface/memory.h:197:
+    uint16_t space; /* => enum phys_map_space */$

WARNING: please, no spaces at the start of a line
#189: FILE: include/xen/interface/memory.h:200:
+    uint16_t size;$

WARNING: please, no spaces at the start of a line
#190: FILE: include/xen/interface/memory.h:201:
+    domid_t foreign_domid; /* IFF gmfn_foreign */$

WARNING: please, no spaces at the start of a line
#193: FILE: include/xen/interface/memory.h:204:
+    GUEST_HANDLE(xen_ulong_t) idxs;$

WARNING: please, no spaces at the start of a line
#196: FILE: include/xen/interface/memory.h:207:
+    GUEST_HANDLE(xen_pfn_t) gpfns;$

total: 2 errors, 6 warnings, 162 lines checked



The ones that bother me a bit are:

+       for (i=0; i<nr; i++) {

that should be

+       for (i = 0; i < nr; i++) {
