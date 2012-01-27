Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2A0SL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:11:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54650 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2A0SLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:11:25 -0500
Date: Fri, 27 Jan 2012 22:11:19 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120127181119.GE11086@moon>
References: <20120127175342.273260614@openvz.org>
 <20120127175939.795551339@openvz.org>
 <4F22E75E.6090602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F22E75E.6090602@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 10:05:18AM -0800, H. Peter Anvin wrote:
> + */
> > +static int kcmp_ptr(long v1, long v2, enum kcmp_type type)
> > +{
> > +	long ret;
> > +
> > +	ret = kptr_obfuscate(v1, type) - kptr_obfuscate(v2, type);
> > +
> > +	return (ret < 0) | ((ret > 0) << 1);
> > +}
> > +
> 
> I just want to point out that we could do hard cryptography, too --
> using DES or AES and compare the result since symmetric cryptography is
> an isomorphism.  One would have to compare the whole result, obviously,
> not a truncated one, so using memcmp() or the similar.
> 
> I'll leave it up to the security guys to worry about if that is needed,
> but since it is something that can be slotted in without changing the
> API it seems reasonably safe.
> 

Yes, it's internal operations not visible to user-space. Actually I thought
to even introduce kind of sysctl later so admin would be able to refresh
cookies manually when needed or completely disable this interface as well.
But not in this patch ;)

	Cyrill
