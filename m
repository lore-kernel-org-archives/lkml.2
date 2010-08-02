Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0HBAth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:49:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:32408 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab0HBAtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:49:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,300,1278313200"; 
   d="scan'208";a="823759635"
Date: Mon, 2 Aug 2010 08:49:34 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [trival patch]x86: unmap vdso pages are missed
Message-ID: <20100802004934.GA2505@sli10-desk.sh.intel.com>
References: <1280476549.10564.2.camel@sli10-desk.sh.intel.com>
 <4C53058A.2050408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C53058A.2050408@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 01:02:02AM +0800, H. Peter Anvin wrote:
> On 07/30/2010 12:55 AM, Shaohua Li wrote:
> > The memory hasn't been unmapped.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> Looks right, but it would be really good if you could provide a more
> verbose description about why this is the right thing to do.
 
We mapped vdso pages but never unmapped them and the vitrual address is lost after
exitting from the function. So unmap vdso pages here.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index ac74869..80f23ed 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -67,6 +67,7 @@ static int __init init_vdso_vars(void)
 	*(typeof(__ ## x) **) var_ref(VDSO64_SYMBOL(vbase, x), #x) = &__ ## x;
 #include "vextern.h"
 #undef VEXTERN
+	vunmap(vbase);
 	return 0;
 
  oom:
