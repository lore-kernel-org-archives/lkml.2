Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2AYPRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:17:06 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:25599 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2AYPRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:17:03 -0500
X-IronPort-AV: E=Sophos;i="4.71,568,1320624000"; 
   d="scan'208";a="10284872"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "annie.li@oracle.com" <annie.li@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jan 2012 15:16:59 +0000
Subject: RE: [Xen-devel] Regressions in v3.3-rc1 introduced by
 "xen/granttable: Grant tables V2 implementation"
Thread-Topic: [Xen-devel] Regressions in v3.3-rc1 introduced by
 "xen/granttable: Grant tables V2 implementation"
Thread-Index: AczbR6urhH5y2nAfQyqLZl2xeNa+3wALHyNw
Message-ID: <291EDFCB1E9E224A99088639C4762022C80E2F0F20@LONPMAILBOX01.citrite.net>
References: <20120125044949.GB29759@phenom.dumpdata.com>
	<20120125051253.GA15501@phenom.dumpdata.com>
 <1327485333.24561.232.camel@zakaz.uk.xensource.com>
In-Reply-To: <1327485333.24561.232.camel@zakaz.uk.xensource.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> 
> On HVM for gnttab_shared we make an add_to_physmap call with
> XENMAPSPACE_grant_table (in gnttab_map). I don't see any support call to
> do something similar for the status array though and I don't see a
> XENMAPSPACE_* specifically for that case either in the hypervisor either.
> 

There is no map-space for the status pages. To map them you use the standard map space but OR a bit (top bit IIRC) into in the idx. It's a bit icky, but that's how it is.

  Paul
