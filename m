Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab2JRPhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:37:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46008 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755Ab2JRPhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:37:17 -0400
Message-ID: <50802093.2000301@zytor.com>
Date: Thu, 18 Oct 2012 08:30:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: mtk.manpages@gmail.com, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com> <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au> <507F848F.50707@zytor.com> <CAKgNAki+KV=Nh8D3La50uXpWv7PA5T-oPYJwK-PkOv5vMg0AqA@mail.gmail.com> <508011AD.5080307@zytor.com> <CAGXu5jJSz8aQiyNk9q3B05SRVm_YE=krg+Y91BU7550AOSRTSw@mail.gmail.com>
In-Reply-To: <CAGXu5jJSz8aQiyNk9q3B05SRVm_YE=krg+Y91BU7550AOSRTSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 08:28 AM, Kees Cook wrote:
>
> The goal for finit_module is to make sure we're getting what's on the
> filesystem, not an arbitrary blob, so we can reason about it for
> security policy.
>

Yes, I get that... although I'm starting to think that that might 
actually be a really bad idea.

>> was confused about the functioning of the *current* init_module() system
>> call.
>>
>> Given that, I have to say I now seriously question the value of
>> finit_module().  The kernel can trivially discover if the pointed-to memory
>> area is a MAP_SHARED mmap() of a file descriptor and if so which file
>> descriptor... why can't we handle this behind the scenes?
>
> This makes me very nervous. I worry that it adds needless complexity
> (it'd be many more checks besides "is it MAP_SHARED?", like "does the
> memory region show the whole file?" "is the offset zero?" etc). Also
> are we sure the memory area would be truly be unmodifiable in the case
> where the filesystem is read-only?

You may need to check for PROT_READONLY as well.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

