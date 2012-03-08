Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab2CHUGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:06:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57767 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187Ab2CHUGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:06:17 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXpQOpAN64gfG-=iyXXy4Tid=9FyKVrT2grQxRgNPC-fg@mail.gmail.com>
References: <20120308165112.GF21812@moon>
	<CAGXu5j+4RRGjzVxLSyz0CZCNMj4dPOxJp3pYGSN_sXFsiMhUaQ@mail.gmail.com>
	<20120308194008.GJ21812@moon>
	<CALCETrXpQOpAN64gfG-=iyXXy4Tid=9FyKVrT2grQxRgNPC-fg@mail.gmail.com>
Date: Thu, 8 Mar 2012 12:06:17 -0800
X-Google-Sender-Auth: WGDgIIdGWXH9NmTxLxZW8AwDe7o
Message-ID: <CAGXu5jJ4yd9=SUWq4haNnDM4FYkkCnXv2vq-fuWtH-VVLT=yLg@mail.gmail.com>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 12:02 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Mar 8, 2012 at 11:40 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>> On Thu, Mar 08, 2012 at 11:31:58AM -0800, Kees Cook wrote:
>> ...
>>> > +       err = -EACCES;
>>> > +       if (!S_ISREG(dentry->d_inode->i_mode)   ||
>>> > +           exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
>>> > +               goto exit;
>>>
>>> I'm starting to notice that this pattern (testing ISREG and
>>> MNT_NOEXEC) is getting repeated a few times in the kernel, and at
>>> least the no-new-privs patch (not yet in -mm but hopefully soon given
>>> the seccomp_filter work) updates this pattern everywhere. Perhaps this
>>> should be extracted into a helper first, and then this patch can call
>>> that helper here? (And then nnp can just update the single helper.)
>>>
>>
>> I can do that if Andrew agree.
>
> I'm a bit lost.  nnp updates the MNT_NOSUID checks, not the MNT_NOEXEC
> checks.  (And the effects of the two flags is different in selinux for
> historical reasons.)  I'm sure I'm missing something.

Oops, you're right. Regardless, we might want helpers anyway. Better
to have single places to do these tests.

-Kees

-- 
Kees Cook
ChromeOS Security
