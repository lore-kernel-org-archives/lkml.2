Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030189Ab2JSCz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:55:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51199 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757830Ab2JSCzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:55:23 -0400
Message-ID: <5080C100.2090703@zytor.com>
Date: Thu, 18 Oct 2012 19:54:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: mtk.manpages@gmail.com, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com> <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au> <507F848F.50707@zytor.com> <CAKgNAki+KV=Nh8D3La50uXpWv7PA5T-oPYJwK-PkOv5vMg0AqA@mail.gmail.com> <508011AD.5080307@zytor.com> <87a9vjp5d9.fsf@rustcorp.com.au>
In-Reply-To: <87a9vjp5d9.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 07:23 PM, Rusty Russell wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>> Given that, I have to say I now seriously question the value of
>> finit_module().  The kernel can trivially discover if the pointed-to
>> memory area is a MAP_SHARED mmap() of a file descriptor and if so which
>> file descriptor... why can't we handle this behind the scenes?
>
> It is a bit more indirect, but also in practice it's a bit trickier than
> that.  We need to ensure the memory doesn't change underneath us and
> stays attached to that fd.  I can easily see that code slipping and
> ending in an exploit.
>
> But that may be my irrational fear of the mm :)

You have to do the same thing with a file/file descriptor, I would think.

However, I keep wondering about the use case for this, as opposed to 
signatures.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

