Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab2CHUDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:03:14 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49678 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187Ab2CHUDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:03:10 -0500
MIME-Version: 1.0
In-Reply-To: <20120308194008.GJ21812@moon>
References: <20120308165112.GF21812@moon> <CAGXu5j+4RRGjzVxLSyz0CZCNMj4dPOxJp3pYGSN_sXFsiMhUaQ@mail.gmail.com>
 <20120308194008.GJ21812@moon>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 8 Mar 2012 12:02:50 -0800
Message-ID: <CALCETrXpQOpAN64gfG-=iyXXy4Tid=9FyKVrT2grQxRgNPC-fg@mail.gmail.com>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 11:40 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On Thu, Mar 08, 2012 at 11:31:58AM -0800, Kees Cook wrote:
> ...
>> > +       err = -EACCES;
>> > +       if (!S_ISREG(dentry->d_inode->i_mode)   ||
>> > +           exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
>> > +               goto exit;
>>
>> I'm starting to notice that this pattern (testing ISREG and
>> MNT_NOEXEC) is getting repeated a few times in the kernel, and at
>> least the no-new-privs patch (not yet in -mm but hopefully soon given
>> the seccomp_filter work) updates this pattern everywhere. Perhaps this
>> should be extracted into a helper first, and then this patch can call
>> that helper here? (And then nnp can just update the single helper.)
>>
>
> I can do that if Andrew agree.

I'm a bit lost.  nnp updates the MNT_NOSUID checks, not the MNT_NOEXEC
checks.  (And the effects of the two flags is different in selinux for
historical reasons.)  I'm sure I'm missing something.

--Andy

>
>        Cyrill
