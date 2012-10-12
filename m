Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab2JLFQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 01:16:36 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:32964 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab2JLFQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 01:16:33 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <87d30o7iy6.fsf@rustcorp.com.au>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
 <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
 <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
 <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 12 Oct 2012 07:16:12 +0200
Message-ID: <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
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

Rusty,

On Fri, Oct 12, 2012 at 12:16 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>
>> On 10/10/2012 06:03 AM, Michael Kerrisk (man-pages) wrote:
>>> Good point. A "whole hog" openat()-style interface is worth thinking about too.
>>
>> *Although* you could argue that you can always simply open the module
>> file first, and that finit_module() is really what we should have had in
>> the first place.  Then you don't need the flags since those would come
>> from openat().
>
> There's no fundamental reason that modules have to be in a file.  I'm
> thinking of compressed modules, or an initrd which simply includes all
> the modules it wants to load in one linear file.
>
> Also, --force options manipulate the module before loading (as did the
> now-obsolete module rename option).

Sure. But my point that started this subthread was: should we take the
opportunity now to add a 'flags' argument to the new finit_module()
system call, so as to allow flexibility in extending the behavior in
future? There have been so many cases of revised system calls in the
past few years that replaced calls without a 'flags' argument that it
seems worth at least some thought before the API is cast in stone.

Thanks,

Michael
