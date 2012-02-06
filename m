Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2BFQNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:13:52 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:40955 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754852Ab2BFQNu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:13:50 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzxxtEfiEhzqrrMK-YA4xznkZJJE=A6rTDs-2a0Eodacg@mail.gmail.com>
References: <1327788715-24076-1-git-send-email-wad@chromium.org>
	<20120202152900.GA4583@sergelap>
	<CABqD9hY0O+QU_0yD8C1GFkqo-i1fmJEwKHWwUrCBoUERxHzLqA@mail.gmail.com>
	<CA+55aFzxxtEfiEhzqrrMK-YA4xznkZJJE=A6rTDs-2a0Eodacg@mail.gmail.com>
Date: Mon, 6 Feb 2012 10:13:48 -0600
Message-ID: <CABqD9hY9j5RtQBM_7CKgsKO2eN+h6QE_Qgi++FJxCsZDuktXCA@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] seccomp: kill the seccomp_t typedef
From: Will Drewry <wad@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk, indan@nul.nu, mcgrathr@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 7:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Feb 3, 2012 at 3:16 PM, Will Drewry <wad@chromium.org> wrote:
>>
>> task_struct {
>>  ...
>>  struct seccomp seccomp;
>> }
>>
>> was as ideal.  I've noticed that almost all of the duplicate names in
>> the task struct use redundancy to differentiate the naming, but I'm
>> happy enough to rename if appropriate.
>
> The redundant "struct xyz_struct" naming is traditional, but we try to
> avoid it these days. The reason for it is that I long long ago was a
> bit confused about the C namespace rules, so for the longest time I
> made struct names unique for no really good reason. The struct/union
> namespace is separate from the other namespaces, so trying to make
> things unique really has no good reason.
>
> And obviously "struct task_struct" is one of those very old things,
> and then the "struct xyz_struct" naming kind of spread from there.
>
> I think "struct seccomp" is fine, and even if "struct x x" looks a bit
> odd, it's at least _less_ repetition than "struct x_struct x" which is
> just really repetitive.
>
> That said, just to make "grep" easier, please do the whole "struct
> xyz" always together, and always with just a single space in between
> them, so that
>
>   git grep "struct xyz"
>
> does the right thing. And for the same reason, when declaring a
> struct, people should always use "struct xyz {", with that exact
> spacing. The exact details of spacing obviously has no semantic
> meaning, but making it easy to grep for use and for definition is
> really convenient.

Thanks for the background and explanation!
will
