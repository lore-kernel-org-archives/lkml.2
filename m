Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2A0Uud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:50:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65460 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab2A0Uuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:50:32 -0500
Date: Sat, 28 Jan 2012 00:50:26 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        xemul@openvz.org, xemul@parallels.com, avagin@openvz.org,
        kosaki.motohiro@gmail.com, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, glommer@parallels.com, andi@firstfloor.org,
        tj@kernel.org, matthltc@us.ibm.com, penberg@kernel.org,
        eric.dumazet@gmail.com, segoon@openwall.com, adobriyan@gmail.com,
        Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120127205026.GT11086@moon>
References: <20120127175342.273260614@openvz.org>
 <20120127175939.795551339@openvz.org>
 <4F2306BB.5090907@jp.fujitsu.com>
 <m1aa5828e4.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1aa5828e4.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 12:33:07PM -0800, Eric W. Biederman wrote:
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
> >> +			ret = kcmp_ptr((long)filp1, (long)filp2, KCMP_FILE);
> >> +		else
> >> +			ret = -ENOENT;
> >
> > If my remember is correct, Andrew pointed out EINVAL is better than ENOENT.
> 
> Ah yes.  And really what it should be is
> 		if (!filp1 || !filp2)
>  			return -EBADF;
> 
> At least EBADF is what you return if it is your process that doesn't
> have the filedescriptor.
> 

Eric, I've sent out version with

		if (filp1 && filp2)
			...
		else
			ret = -EBADF;

maybe you're lookin into previous version?

> >> +			       KCMP_SYSVSEM);
> >> +#else
> >> +		ret = -EINVAL;
> >
> > ENOTSUP is better, I think. because of, EINVAL implicitly mean _caller_ is wrong.
> > but in this case, it is not bad. only the kernel doesn't have enough
> > feature.
> 
> Careful a type compiled out should in principle match a type whose
> support has not been implemented. That is the default case should match
> what happens when you don't compile in sysvipc support.

I don't get it :) Will -EINVAL be enough or not?

	Cyrill
