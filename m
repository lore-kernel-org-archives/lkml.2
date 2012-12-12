Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2LLOZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:25:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42202 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2LLOZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:25:26 -0500
MIME-Version: 1.0
In-Reply-To: <CALLzPKZVJqjiVJ1geXHmmKnhiYxoT8wQYQzqfoXVzu-kh0-FmA@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	<CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
	<CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
	<1355234914.2356.85.camel@falcor>
	<CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
	<1355249884.2356.108.camel@falcor>
	<CACLa4pvLbrCbivWSNTuxROBf5qDNJZmnFVyQaQ=7qcZRtSfcfg@mail.gmail.com>
	<1355252392.2356.131.camel@falcor>
	<CA+55aFwG31fi9=r0Zta2hoo60vdgM61hbh4BC9Rgs8i7S82Haw@mail.gmail.com>
	<1355255320.2356.148.camel@falcor>
	<CACLa4psVpx8YPcgiQs0FETg8d+zLcjivnks_So6Dpii48pDNBQ@mail.gmail.com>
	<CALLzPKbqAa7-vJnXbYFbkaD5NVW=6wHQQMDc_Ww==p1hwQ1EJg@mail.gmail.com>
	<CACLa4pske6okjDj5mRC1+20VhWZmFt+L6j+Y6e=weA7PvD13yw@mail.gmail.com>
	<CALLzPKZVJqjiVJ1geXHmmKnhiYxoT8wQYQzqfoXVzu-kh0-FmA@mail.gmail.com>
Date: Wed, 12 Dec 2012 09:25:25 -0500
Message-ID: <CACLa4pv_QhAtoz8Q3AkRqMvJjBsA_yi__woh7+34gkUVKbrBkQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: Eric Paris <eparis@parisplace.org>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 8:56 AM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:

> I have done few tests.
> Ratio between lookups is different, but I do not really remember what
> exactly it was.
> Probably I did measurement with directory integrity protection...
>
> First test is done using upstream IMA.
>
> IMA-appraisal
> [   59.554072] counter1 - before (inode->i_flags & S_NOIMA): 74586
> [   59.554628] counter2 - after (inode->i_flags & S_NOIMA): 74558
> [   59.555024] counter3 - after (inode->i_sb->s_feature_flags & SF_NOIMA): 52895
>
> You can see 3 counters after 55 seconds uptime.
> Counters count entries to the policy search function.
> First counter counts every entry.
> Second counter counts if control passes after inode flag S_NOIMA.
> Third counts if control passes after SB flag SF_NOIMA.
>
> As you can see, inode flag does not make a difference - just 28
> entries differences.

That is quite shocking to me that on system start up we only ever
reference the same /proc file 28 times.  Wow.  I just don't know what
to say.  Obviously the per inode flag is dead.  Now there is probably
some CPU benefit to a per-sb flag, but I'm not sure it is worth the
code to do it if you can't really measure that as something that makes
a difference in userspace.

Maybe if you can show that after your integrity protection work is
done we can revisit.  But I'd think this patch is dead until you can
show the impact on real userspace.  Someone else might disagree, but
that's my thought.

Sorry.

-Eric
