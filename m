Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab1FFHI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:08:57 -0400
Received: from ozlabs.org ([203.10.76.45]:52403 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab1FFHIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:08:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        "Venkatesh Pallipadi \(Venki\)" <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>,
        John Stultz <johnstul@us.ibm.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, trivial@kernel.org
Subject: Re: [PATCH 8/8] arch/x86: use printk_ratelimited instead of printk_ratelimit
In-Reply-To: <fce87f1efab55e15e91b21f1b73f0e86016a27d9.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
References: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de> <fce87f1efab55e15e91b21f1b73f0e86016a27d9.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 06 Jun 2011 16:05:17 +0930
Message-ID: <874o43ii1m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Jun 2011 17:37:04 +0200, Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de> wrote:
> Since printk_ratelimit() shouldn't be used anymore (see comment in
> include/linux/printk.h), replace it with printk_ratelimited.

Acked-by: Rusty Russell <rusty@rustcorp.com.au> (lguest part)

> diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
> index db832fd..23a6eff 100644
> --- a/arch/x86/lguest/boot.c
> +++ b/arch/x86/lguest/boot.c
> @@ -56,6 +56,7 @@
>  #include <linux/lguest_launcher.h>
>  #include <linux/virtio_console.h>
>  #include <linux/pm.h>
> +#include <linux/ratelimit.h>
>  #include <asm/apic.h>
>  #include <asm/lguest.h>
>  #include <asm/paravirt.h>

Is this new include really needed?  The printk_ratelimited() definition
is in printk.h...

Thanks,
Rusty.
