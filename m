Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab2DDSIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 14:08:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47951 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab2DDSIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 14:08:18 -0400
Message-ID: <4F7C8E16.2070706@gmail.com>
Date: Wed, 04 Apr 2012 11:08:22 -0700
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com> <4F7A3CC2.1040200@zytor.com> <CAOPLpQebqKED5G1nti6i=JLZ+A6df2UdA86RVEv1Er7hw7KFpQ@mail.gmail.com> <4F7C7907.3090808@gmail.com> <CAOPLpQfowVbAfY5utOa4pYDkA+AtLGU0zMLC5Eq5oH=zVrVC6Q@mail.gmail.com> <4F7C7FCE.3090105@gmail.com> <CAOPLpQdZc9m5ZpGgJtPBEvJUqeaqRneUkQx5NgXiXhvtXctDrg@mail.gmail.com>
In-Reply-To: <CAOPLpQdZc9m5ZpGgJtPBEvJUqeaqRneUkQx5NgXiXhvtXctDrg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/4/12 10:49 AM), Ulrich Drepper wrote:
> On Wed, Apr 4, 2012 at 13:07, KOSAKI Motohiro<kosaki.motohiro@gmail.com>  wrote:
>> Umm... I'm sorry. I haven't catch why OOM is related topic. Could you please
>> elaborate more?
>
> With fork you always have some copy-on-write (and worse for
> overcommit) just to then execute exec.  With a real spawn
> implementation you wouldn't have that.  A big problem if you, for
> instance, have to spawn a small helper from a gigantic process.

Ah, ok. I agree posix_spawn() has a chance to aim more momemory efficiency
than fork-exec. But in this purpose, vfork may be enough useful and be widely
accepted from userland folks.

Example, some daemon has a following patten,
  1. fork
  2. change /proc/<pid>/oom_adj
  3. exec

That's said, when adding linux specific knob, we need to add new posix_spawn flags
if we really need (or want) to replaces all userland. this seems very hard and doubtful
worth to me.

Ahh, note. I'm not against to implement posix_spawn() into the kernel. I only argue spawn()
can solve closefrom issue.
