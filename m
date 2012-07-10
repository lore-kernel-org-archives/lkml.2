Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2GJPY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:24:28 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:10757 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab2GJPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:24:27 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr387qFmLE
X-RZG-CLASS-ID: mo00
Date: Tue, 10 Jul 2012 17:24:25 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/pv-on-hvm kexec: shutdown watches from
 old kernel
Message-ID: <20120710152424.GB31819@aepfle.de>
References: <1341924603-18978-1-git-send-email-olaf@aepfle.de>
 <20120710141906.GC1791@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120710141906.GC1791@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, Konrad Rzeszutek Wilk wrote:

> On Tue, Jul 10, 2012 at 02:50:03PM +0200, Olaf Hering wrote:
> > Add xs_reset_watches function to shutdown watches from old kernel after
> > kexec boot.  The old kernel does not unregister all watches in the
> > shutdown path.  They are still active, the double registration can not
> > be detected by the new kernel.  When the watches fire, unexpected events
> > will arrive and the xenwatch thread will crash (jumps to NULL).  An
> > orderly reboot of a hvm guest will destroy the entire guest with all its
> > resources (including the watches) before it is rebuilt from scratch, so
> > the missing unregister is not an issue in that case.
> > 
> > With this change the xenstored is instructed to wipe all active watches
> > for the guest.  However, a patch for xenstored is required so that it
> > accepts the XS_RESET_WATCHES request from a client (see changeset
> > 23839:42a45baf037d in xen-unstable.hg). Without the patch for xenstored
> > the registration of watches will fail and some features of a PVonHVM
> > guest are not available. The guest is still able to boot, but repeated
> > kexec boots will fail.
> 
> OK, so this should make the reset of xenstore work with the new hypervisor,
> but with older ones (like Amazon), it won't and we won't have regressions, right?

The reset happens only if "platform-feature-xs_reset_watches" exists, so
old hosts are supposed to be ok.

Olaf
