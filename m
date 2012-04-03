Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab2DCFK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:10:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45148 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2DCFKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:10:24 -0400
Message-ID: <4F7A863C.5020407@openvz.org>
Date: Tue, 03 Apr 2012 09:10:20 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Oleg Nesterov <oleg@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 6/7] mm: kill vma flag VM_EXECUTABLE
References: <20120331091049.19373.28994.stgit@zurg> <20120331092929.19920.54540.stgit@zurg> <20120331201324.GA17565@redhat.com> <20120402230423.GB32299@count0.beaverton.ibm.com>
In-Reply-To: <20120402230423.GB32299@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley wrote:
> On Sat, Mar 31, 2012 at 10:13:24PM +0200, Oleg Nesterov wrote:
>> On 03/31, Konstantin Khlebnikov wrote:
>>>
>>> comment from v2.6.25-6245-g925d1c4 ("procfs task exe symlink"),
>>> where all this stuff was introduced:
>>>
>>>> ...
>>>> This avoids pinning the mounted filesystem.
>>>
>>> So, this logic is hooked into every file mmap/unmmap and vma split/merge just to
>>> fix some hypothetical pinning fs from umounting by mm which already unmapped all
>>> its executable files, but still alive. Does anyone know any real world example?
>>
>> This is the question to Matt.
>
> This is where I got the scenario:
>
> https://lkml.org/lkml/2007/7/12/398

Cyrill Gogcunov's patch "c/r: prctl: add ability to set new mm_struct::exe_file"
gives userspace ability to unpin vfsmount explicitly.

https://lkml.org/lkml/2012/3/16/449

>
> Cheers,
> 	-Matt Helsley
>
> PS: I seem to keep coming back to this so I hope folks don't mind if I leave
> some more references to make (re)searching this topic easier:
>
> Thread with Cyrill Gorcunov discussing c/r of symlink:
> https://lkml.org/lkml/2012/3/16/448
>
> Thread with Oleg Nesterov re: cleanups:
> https://lkml.org/lkml/2012/3/5/240
>
> Thread with Alexey Dobriyan re: cleanups:
> https://lkml.org/lkml/2009/6/4/625
>
> mainline commit 925d1c401fa6cfd0df5d2e37da8981494ccdec07
> Date:   Tue Apr 29 01:01:36 2008 -0700
>
> 	procfs task exe symlink
>

