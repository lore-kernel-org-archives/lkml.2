Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1LLWBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:01:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39279 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1LLWBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:01:37 -0500
Date: Tue, 13 Dec 2011 02:01:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [patch 3/3] [PATCH] prctl: Add PR_SET_MM codes to set up
 mm_struct entires v3
Message-ID: <20111212220132.GT2199@moon>
References: <20111212200642.836001668@openvz.org>
 <20111212201715.244414996@openvz.org>
 <CAGXu5jLSrwLeWoQNAA5uyWEewugnr1cWrxzH=wD9JnvZwgAggw@mail.gmail.com>
 <20111212205114.GR2199@moon>
 <20111212135323.2f757d9b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111212135323.2f757d9b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 01:53:23PM -0800, Andrew Morton wrote:
...
> >
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +static int prctl_set_mm(int opt, unsigned long addr,
> > +			unsigned long arg4, unsigned long arg5)
> > +{
> > +	unsigned long rlim = rlimit(RLIMIT_DATA);
> > +	unsigned long vm_req_flags;
> > +	unsigned long vm_bad_flags;
> > +	struct vm_area_struct *vma;
> > +	int error = 0;
> > +
> > +	if (arg4 | arg5)
> > +		return -EINVAL;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	if (addr >= TASK_SIZE)
> > +		return -EINVAL;
> > +
> > +	down_read(&current->mm->mmap_sem);
> 
> This may not be true of all compiler versions, but when I cache
> current->mm in a local, the code size is reduced rather a lot:
> 
> akpm:/usr/src/25> size kernel/sys.o
>    text    data     bss     dec     hex filename
>   22685   14376    7616   44677    ae85 kernel/sys.o
>   22489   14376    7616   44481    adc1 kernel/sys.o
> 

Hmm, this is great and weird. Letme try...

	Cyrill
