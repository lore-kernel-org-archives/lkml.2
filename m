Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab2JJSKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:10:04 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:10964 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab2JJSKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:10:00 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJji0Kfg==
X-RZG-CLASS-ID: mo00
Date: Wed, 10 Oct 2012 20:09:56 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] xen/pv-on-hvm kexec: add quirk for Xen 3.4 and
 shutdown watches.
Message-ID: <20121010180956.GA2130@aepfle.de>
References: <1349890849-17471-1-git-send-email-konrad.wilk@oracle.com>
 <1349890849-17471-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1349890849-17471-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21.rev5555 (2012-07-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, Konrad Rzeszutek Wilk wrote:

> The commit 254d1a3f02ebc10ccc6e4903394d8d3f484f715e, titled
> "xen/pv-on-hvm kexec: shutdown watches from old kernel" assumes that the
> XenBus backend can deal with reading of values from:
>  "control/platform-feature-xs_reset_watches":
> 
>     ... a patch for xenstored is required so that it
>     accepts the XS_RESET_WATCHES request from a client (see changeset
>     23839:42a45baf037d in xen-unstable.hg). Without the patch for xenstored
>     the registration of watches will fail and some features of a PVonHVM
>     guest are not available. The guest is still able to boot, but repeated
>     kexec boots will fail."
> 
> Sadly this is not true when using a Xen 3.4 hypervisor and booting a PVHVM
> guest. We end up hanging at:

This is sad.
So far I have not seen reports like that with a sles11sp1 or sles11sp2
guest. Thats either because noone uses Xen 3.4+sles11 (or recent
openSuSE) HVM guests, or because it happens to work with that
combination.

If the patch solves the issue:

Acked-by: Olaf Hering <olaf@aepfle.de>

Olaf
