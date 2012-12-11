Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2LKSxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:53:47 -0500
Received: from mga05.intel.com ([192.55.52.89]:8946 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754600Ab2LKSxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:53:42 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwhY2+UG-VCGrUk=N3KNXvDudA-QHnDqPbWU5pf4Ty5jw@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	<CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
	<CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
	<1355234914.2356.85.camel@falcor>
	<CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
	<CALLzPKZQ3=qNOxJk-yqDGEzqkcKLoc9tPPD8o9QbJOUOB1nWuQ@mail.gmail.com>
	<CA+55aFxh2SH9WcXbb+hD3PtWa4ZTqYNUxvbqZh27vwANuUTE8w@mail.gmail.com>
	<CALLzPKakDLO-_ERScq_cAvAVLFU_5rRSyvoudjba=cFo96c-Mw@mail.gmail.com>
	<CA+55aFwhY2+UG-VCGrUk=N3KNXvDudA-QHnDqPbWU5pf4Ty5jw@mail.gmail.com>
Date: Tue, 11 Dec 2012 20:53:39 +0200
Message-ID: <CALLzPKYdxLYXEohT=Pbm01pOhfYMh1_4X40ZVV_Zg9HWRQhxpA@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 8:35 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Dec 11, 2012 at 10:12 AM, Kasatkin, Dmitry
> <dmitry.kasatkin@intel.com> wrote:
>>
>> Actually S_PRIVATE does not work work for normal filesystems which IMA
>> might want to ignore.
>
> The reading comprehension here is abysmal.
>
> First you claim that you need the new flag for pseudo-filesystems, and
> now that I point out that we have an *old* flag for pseudo-filesystems
> you turn around 180 degrees and talk about other filesystems.
>

I have not claimed that. This is exactly what I have written:
"There are different filesystems which are not checked by IMA/EVM,
such as pseudo-filesystems"
Pseudo-filesystems was an example of possible cases.
Sorry if it was not clear enough.

> And none of that matters for my argument AT ALL.
>
> My argument has not been that we cannot add a new flag.
>
> My argument has been that we already have the logical place for such a
> flag, and that adding a totally new field seems so stupid.
>
> Seriously. The i_flags place is where we already do pretty much
> *exactly* what you ask for. The fact that it is faster and more
> flexible to boot should be a bonus.
>
> Now, there are real reasons to avoid "s_flags", notably the fact that
> we're running out of bits there (unlike i_flags), and they are exposed
> as generic fields and are generally meant for mount options etc. So I
> understand why we might want to avoid that (although the whole
> mount-option thing could also be seen as an advantage), but I really
> don't see any argument against i_flags, considering that we already
> use it for S_IMA and S_PRIVATE, both of which are related to exactly
> what you seem to want to do.

Not every inode on the filesystem might be checked by IMA.
It depends on policy. And S_IMA flag is used exactly for this purpose.

But when the entire FS is not checked, SB flag seems to be very appropriate.
Eric has given nice explanation.

>
> The one downside of i_flags may be that any update should own the
> inode semaphore. But within the context of a security model, that
> should be fine (and normally you'd update it once per lifetime of the
> inode).
>

This is exactly how IMA works at the moment.
See my response to Eric about performance.

>                   Linus
