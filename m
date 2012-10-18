Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2JRIFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:05:42 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41178 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2JRIFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:05:38 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <507F848F.50707@zytor.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
 <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
 <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
 <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au> <507F848F.50707@zytor.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 18 Oct 2012 10:05:17 +0200
Message-ID: <CAKgNAki+KV=Nh8D3La50uXpWv7PA5T-oPYJwK-PkOv5vMg0AqA@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 6:24 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/11/2012 03:16 PM, Rusty Russell wrote:
>> "H. Peter Anvin" <hpa@zytor.com> writes:
>>
>>> On 10/10/2012 06:03 AM, Michael Kerrisk (man-pages) wrote:
>>>> Good point. A "whole hog" openat()-style interface is worth thinking about too.
>>>
>>> *Although* you could argue that you can always simply open the module
>>> file first, and that finit_module() is really what we should have had in
>>> the first place.  Then you don't need the flags since those would come
>>> from openat().
>>
>> There's no fundamental reason that modules have to be in a file.  I'm
>> thinking of compressed modules, or an initrd which simply includes all
>> the modules it wants to load in one linear file.
>>
>> Also, --force options manipulate the module before loading (as did the
>> now-obsolete module rename option).
>>
>
> So perhaps what we *should* have is something that points to the module
> to a (buffer, length) in userspace, and the equivalent of the current
> init_module() would be open() + mmap() + minit_module() + close()?

So, I don't get it. What are the args you propose for of minit_module()?


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
