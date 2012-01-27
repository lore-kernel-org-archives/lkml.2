Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2A0UrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:47:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33782 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2A0UrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:47:14 -0500
Date: Sat, 28 Jan 2012 00:47:07 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ebiederm@xmission.com, xemul@openvz.org, xemul@parallels.com,
        avagin@openvz.org, kosaki.motohiro@gmail.com, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, glommer@parallels.com,
        andi@firstfloor.org, tj@kernel.org, matthltc@us.ibm.com,
        penberg@kernel.org, eric.dumazet@gmail.com, segoon@openwall.com,
        adobriyan@gmail.com, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120127204707.GS11086@moon>
References: <20120127175342.273260614@openvz.org>
 <20120127175939.795551339@openvz.org>
 <4F2306BB.5090907@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2306BB.5090907@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 03:19:07PM -0500, KOSAKI Motohiro wrote:
...
> > +
> > +		if (filp1 && filp2)
> > +			ret = kcmp_ptr((long)filp1, (long)filp2, KCMP_FILE);
> > +		else
> > +			ret = -ENOENT;
> 
> If my remember is correct, Andrew pointed out EINVAL is better than ENOENT.
> 

Phphphp :) there a version posted already which
returns -EBADFD (as Eric pointed me).

> > +#ifdef CONFIG_SYSVIPC
> > +		ret = kcmp_ptr((long)task1->sysvsem.undo_list,
> > +			       (long)task2->sysvsem.undo_list,
> > +			       KCMP_SYSVSEM);
> > +#else
> > +		ret = -EINVAL;
> 
> ENOTSUP is better, I think. because of, EINVAL implicitly mean _caller_ is wrong.
> but in this case, it is not bad. only the kernel doesn't have enough feature.
> 

I see.

> 
> > +		goto err;
> 
> you don't need err label at all.
> 

yeah, thanks.

> > +
> > +                printf("pid1: %6d pid2: %6d FD: %2d FILES: %2d VM: %2d FS: %2d "
> > +		       "SIGHAND: %2d IO: %2d SYSVSEM: %2d INV: %2d\n",
> > +		       pid1, pid2,
> > +		       sys_kcmp(pid1, pid2, KCMP_FILE,		fd1, fd2),
> > +		       sys_kcmp(pid1, pid2, KCMP_FILES,		0, 0),
> > +		       sys_kcmp(pid1, pid2, KCMP_VM,		0, 0),
> > +		       sys_kcmp(pid1, pid2, KCMP_FS,		0, 0),
> > +		       sys_kcmp(pid1, pid2, KCMP_SIGHAND,	0, 0),
> > +		       sys_kcmp(pid1, pid2, KCMP_IO,		0, 0),
> > +		       sys_kcmp(pid1, pid2, KCMP_SYSVSEM,	0, 0),.
> 
> The best practice of auto test is
> 
>  AssertFooBar(expected_value, actual_value);
> 
> and, just only print "correct or not". Only you know the correct value.
> 

ok

	Cyrill
