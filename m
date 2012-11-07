Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab2KGOt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:49:27 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47058 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab2KGOt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:49:26 -0500
Date: Wed, 7 Nov 2012 08:48:31 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add tpm_xenu.ko: Xen Virtual TPM frontend driver
Message-ID: <20121107144831.GB14628@ennui.austin.ibm.com>
References: <1352128197-1539-1-git-send-email-matthew.fioravante@jhuapl.edu>
 <20121106193921.GC28473@phenom.dumpdata.com>
 <509A6AA6.2000208@jhuapl.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509A6AA6.2000208@jhuapl.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110714-7182-0000-0000-0000031E2C0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>+static struct attribute *vtpm_attrs[] = {
> >>+     &dev_attr_pubek.attr,
> >>+     &dev_attr_pcrs.attr,
> >>+     &dev_attr_enabled.attr,
> >>+     &dev_attr_active.attr,
> >>+     &dev_attr_owned.attr,
> >>+     &dev_attr_temp_deactivated.attr,
> >>+     &dev_attr_caps.attr,
> >>+     &dev_attr_cancel.attr,
> >>+     NULL,
> >So are these going to show up in SysFS? If so, there should also be
> >a corresponding file in Documentation/.../sysfs/something.
> These are similar to the entries made by the other tpm drivers. I
> don't see any documentation about those either. TPM maintainers, any
> guidance there?

  Yep, those show up in sysfs. I'll put docs on my todo list.

Kent

> >
> >>+#include "tpm.h"
> >>+#include "tpm_vtpm.h"
> >>+
> >>+#undef DEBUG
> >>+
> >>+#define GRANT_INVALID_REF 0
> >Interesting. The 0 grant value is actually a valid one. I think you
> >want (-1ULL).
> Is it?
> drivers/block/xen-blkfront.c and
> drivers/net/xen-netfront.c
> 
> do the exact same thing
> >>+
> >>+     init_tpm_xenbus();
> >>+     return 0;
> >>+}
> >>+
> >>+
> >>+module_init(tpmif_init);
> >no module_exit?
> Will fix
> 
> 


