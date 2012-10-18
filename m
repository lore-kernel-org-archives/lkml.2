Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2JRHUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 03:20:13 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:34327 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2JRHUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 03:20:10 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="15245287"
Message-ID: <1350544809.28188.5.camel@dagon.hellion.org.uk>
Subject: Re: [PATCH 6/6] xen: x86 pvh: use XENMEM_add_to_physmap_range for
 foreign gmfn mappings
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Date: Thu, 18 Oct 2012 08:20:09 +0100
In-Reply-To: <20121017165718.683fa30f@mantra.us.oracle.com>
References: <1350473518.2460.58.camel@zakaz.uk.xensource.com>
	 <1350473532-15863-6-git-send-email-ian.campbell@citrix.com>
	 <20121017165718.683fa30f@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 00:57 +0100, Mukesh Rathor wrote:
> On Wed, 17 Oct 2012 12:32:12 +0100
> Ian Campbell <ian.campbell@citrix.com> wrote:
> 
> > Squeezing the necessary fields into the existing XENMEM_add_to_physmap
> > interface was proving to be a bit tricky so we have decided to go with
> > a new interface upstream (the XENMAPSPACE_gmfn_foreign interface using
> > XENMEM_add_to_physmap was never committed anywhere). This interface
> > also allows for batching which was impossible to support at the same
> > time as foreign mfns in the old interface.
> > 
> > This reverts the relevant parts of "PVH: basic and header changes,
> > elfnote changes, ..." and followups and trivially converts
> > pvh_add_to_xen_p2m over.
> 
> 
> Hmm... I don't see xen side implementation of XENMEM_add_to_physmap_range,

I said in the 0/6 patch, but should have repeated here:

        The final patch requires that XENMEM_add_to_physmap_range be implemented
        for x86 on the hypervisor side. For inspiration the ARM version can be
        found at <1350314444-17148-1-git-send-email-ian.campbell@citrix.com>
        (and will likely be in xen-unstable soon).

In the end I checked it in yesterday.

> and since I've already got my patches tested and cut, I'm going to send
> them now. We can apply this change easily in konrad's tree.

Sure, no problem.

Ian.


