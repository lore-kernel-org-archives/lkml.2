Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab2JKQGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:06:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab2JKQGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:06:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C573632-7629-4E7A-8A67-FD4698B7430D@suse.de>
References: <4C573632-7629-4E7A-8A67-FD4698B7430D@suse.de> <20121011120502.0211f1267dedf3776e4cf85b@canb.auug.org.au> <13876.1349947620@warthog.procyon.org.uk>
To: Alexander Graf <agraf@suse.de>
Cc: dhowells@redhat.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        B04825@freescale.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liu Yu <yu.liu@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: manual merge of the kvm-ppc tree with the powerpc-merge tree
Date: Thu, 11 Oct 2012 17:05:57 +0100
Message-ID: <14077.1349971557@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Graf <agraf@suse.de> wrote:

> Do I have to move them to their own header file or can I just #ifdef
> __KERNEL__ around the place where __ASSEMBLY__ starts to the end of the
> file?

That depends on whether it happens before or after my disintegration script is
run on the header.  Ben has pulled my powerpc thing into the powerpc tree
already.  If he doesn't mind repulling, then if you give me a patch or a git
branch to fix it, I can apply that and regenerate the powerpc branch.

Otherwise, you need to disintegrate manually:

 (1) Move the public part to arch/powerpc/include/uapi/asm/epapr_hcalls.h

 (2) #include the public part from arch/powerpc/include/asm/epapr_hcalls.h

 (3) Move the "headers-y += epapr_hcalls.h" line from .../asm/Kbuild to
     .../uapi/asm/Kbuild.

You should not then need __KERNEL__ guards in either header.

David
