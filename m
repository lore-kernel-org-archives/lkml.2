Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab2JRP2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:28:06 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63422 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab2JRP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:28:03 -0400
MIME-Version: 1.0
In-Reply-To: <508011AD.5080307@zytor.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
	<CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
	<50749DE8.7010703@zytor.com>
	<CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
	<5074A0AB.8040207@zytor.com>
	<87d30o7iy6.fsf@rustcorp.com.au>
	<507F848F.50707@zytor.com>
	<CAKgNAki+KV=Nh8D3La50uXpWv7PA5T-oPYJwK-PkOv5vMg0AqA@mail.gmail.com>
	<508011AD.5080307@zytor.com>
Date: Thu, 18 Oct 2012 08:28:02 -0700
X-Google-Sender-Auth: 1mfIHUQF6zrZQ0BQ4VKrACPmmVo
Message-ID: <CAGXu5jJSz8aQiyNk9q3B05SRVm_YE=krg+Y91BU7550AOSRTSw@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mtk.manpages@gmail.com, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 7:26 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/18/2012 01:05 AM, Michael Kerrisk (man-pages) wrote:
>>>
>>>
>>> So perhaps what we *should* have is something that points to the module
>>> to a (buffer, length) in userspace, and the equivalent of the current
>>> init_module() would be open() + mmap() + minit_module() + close()?
>>
>>
>> So, I don't get it. What are the args you propose for of minit_module()?
>>
>
> Nevermind, this is what the current init_module() already takes.
>
> So it sounds like Rusty is objecting to the very notion of tying a module to
> a file descriptor the way the proposed finit_module() system call does -- I

The goal for finit_module is to make sure we're getting what's on the
filesystem, not an arbitrary blob, so we can reason about it for
security policy.

> was confused about the functioning of the *current* init_module() system
> call.
>
> Given that, I have to say I now seriously question the value of
> finit_module().  The kernel can trivially discover if the pointed-to memory
> area is a MAP_SHARED mmap() of a file descriptor and if so which file
> descriptor... why can't we handle this behind the scenes?

This makes me very nervous. I worry that it adds needless complexity
(it'd be many more checks besides "is it MAP_SHARED?", like "does the
memory region show the whole file?" "is the offset zero?" etc). Also
are we sure the memory area would be truly be unmodifiable in the case
where the filesystem is read-only?

-Kees

-- 
Kees Cook
Chrome OS Security
