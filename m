Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2LKRkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:40:31 -0500
Received: from mga12.intel.com ([143.182.124.36]:42871 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752953Ab2LKRk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:40:29 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	<CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
	<CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
	<1355234914.2356.85.camel@falcor>
	<CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
Date: Tue, 11 Dec 2012 19:40:17 +0200
Message-ID: <CALLzPKZQ3=qNOxJk-yqDGEzqkcKLoc9tPPD8o9QbJOUOB1nWuQ@mail.gmail.com>
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

On Tue, Dec 11, 2012 at 6:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Dec 11, 2012 at 6:08 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> On Tue, 2012-12-11 at 14:51 +0200, Kasatkin, Dmitry wrote:
>>> >>
>>> >> Two months ago I was asking about it on mailing lists.
>>> >> Suggestion was not to use s_flags, but e.g. s_feature_flags.
>
> Quite frankly, this seems stupid.

What exactly seems stupid here?

>
> Without really knowing the problem space, the sane thing to do would
> seem to be inode->i_flags. At which point it's
>
>  (a) faster to test (no need to dereference inode->i_sb)
>
>  (b) matches what the integrity layer does with S_IMA (well, there the
> logic is reversed: S_IMA means that it has a integrity structure
> associated with it)
>
>  (c) allows you to mark individual inodes as "no checking".
>

There are inode specific objects which IMA uses for such perpose.

> and quite frankly, (c) in particular seems to make sense to me, since
> it would seem to be rather possible to do things like "I've checked
> this inode, it had no policies associated with it, I never need to
> check it again". Clear the flag when policies change or whatever.
>
> What's the advantage of making it per-filesystem?
>

There are different filesystems which are not checked by IMA/EVM,
such as pseudo-filesystems. For this reason it is good to have a way to
ignore such filesystems without to much work in IMA code.
No reason to check policy again and again for every inode on the filesystem
when the result will always be to ignore the filesystem.

Per-filesystem flag soles this problem.

- Dmitry


>             Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
