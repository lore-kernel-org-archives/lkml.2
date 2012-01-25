Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab2AYPsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:48:17 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:55776 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2AYPsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:48:16 -0500
X-IronPort-AV: E=Sophos;i="4.71,568,1320624000"; 
   d="scan'208";a="10285648"
Subject: RE: [Xen-devel] Regressions in v3.3-rc1 introduced by
 "xen/granttable: Grant tables V2 implementation"
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Paul Durrant <Paul.Durrant@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "annie.li@oracle.com" <annie.li@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jan 2012 15:47:42 +0000
In-Reply-To: <291EDFCB1E9E224A99088639C4762022C80E2F0F20@LONPMAILBOX01.citrite.net>
References: <20120125044949.GB29759@phenom.dumpdata.com>
	 <20120125051253.GA15501@phenom.dumpdata.com>
	 <1327485333.24561.232.camel@zakaz.uk.xensource.com>
	 <291EDFCB1E9E224A99088639C4762022C80E2F0F20@LONPMAILBOX01.citrite.net>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1327506463.24561.335.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 15:16 +0000, Paul Durrant wrote:
> > -----Original Message-----
> > 
> > On HVM for gnttab_shared we make an add_to_physmap call with
> > XENMAPSPACE_grant_table (in gnttab_map). I don't see any support call to
> > do something similar for the status array though and I don't see a
> > XENMAPSPACE_* specifically for that case either in the hypervisor either.
> > 
> 
> There is no map-space for the status pages. To map them you use the
> standard map space but OR a bit (top bit IIRC) into in the idx. It's a
> bit icky, but that's how it is.

I can't see that happening anywhere in the current Linux tree, there's
only one call to XENMAPSPACE_grant_table and it doesn't set the top bit,
so presumably this is at least part of the problem.

I hope that "top bit" is consistent for 32 and 64 bit domains....

Ian.

