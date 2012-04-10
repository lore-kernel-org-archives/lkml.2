Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab2DJXKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:10:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab2DJXKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:10:07 -0400
Date: Wed, 11 Apr 2012 01:08:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120410230833.GA17620@redhat.com>
References: <20120215143606.GA14037@redhat.com> <20120215160652.GA17680@redhat.com> <20120215162752.GF4533@moon> <20120409151027.7f3e0fa5.akpm@linux-foundation.org> <20120409222443.GW1625@moon> <4F836F3E.9090207@zytor.com> <20120410223758.GL24857@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410223758.GL24857@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Cyrill Gorcunov wrote:
>
> --- linux-2.6.git.orig/kernel/kcmp.c
> +++ linux-2.6.git/kernel/kcmp.c
> @@ -17,6 +17,17 @@
>   * reasons, still the comparison results should be suitable for
>   * sorting. Thus, we obfuscate kernel pointers values and compare
>   * the production instead.
> + *
> + * The obfuscation is done in two steps. First -- we use xor on
> + * kernel pointer with random value, which puts pointer into
> + * a new position in reordered space. Second -- we multiply
> + * the xor production with big odd random number to permute
> + * bits even more (the oddity is important here, it allow
> + * us to have meaningful production even if multiplicants
> + * are big numbers).
> + *
> + * Note also the obfuscation itself is invisible to user-space
> + * and if needed it can be changed to any suitable scheme.
>   */
>  static unsigned long cookies[KCMP_TYPES][2] __read_mostly;

OK, since this is discussed again...

Can this comment can also explain why do we obfuscate the pointers
by type? I mean, I don't really understand why the one-dimensional
cookies[2] is "not enough" from security pov.

Oleg.

