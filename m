Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0KJCF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:05:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56499 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab0KJCF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:05:27 -0500
Message-ID: <4CD9FE2D.2070108@cn.fujitsu.com>
Date: Wed, 10 Nov 2010 10:06:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/7] cgroups: Shrink struct cgroup_subsys
References: <4CC146A4.9090505@cn.fujitsu.com> <4CC146BA.7080009@cn.fujitsu.com> <AANLkTikf-1kLStxqi5UjP=vn3pqVBHy0OA7ibeWTkJ5z@mail.gmail.com> <4CD78946.5060405@cn.fujitsu.com> <AANLkTim6d1fQLZbkmZST3PTN0RMSs3m=oossF81pYBn9@mail.gmail.com> <4CD9ECD2.3030805@cn.fujitsu.com> <AANLkTinMr7VE4Os7rXWjiHWOVysv=oE0vHKduLWCN0bC@mail.gmail.com>
In-Reply-To: <AANLkTinMr7VE4Os7rXWjiHWOVysv=oE0vHKduLWCN0bC@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-10 10:05:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-10 10:05:52,
	Serialize complete at 2010-11-10 10:05:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Nov 9, 2010 at 4:52 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>> bool active:1;
>>> bool disabled:1;
>>>
>> It won't compile, but unsigned char active:1 will do. ;)
> 
> Are you sure? I don't have a buildable kernel tree at the moment, but
> the following fragment compiled fine for me (with gcc 4.4.3):
> 
> struct foo {
>   _Bool b1:1;
>   _Bool b2:1;
> };
> 
> and was sized at one byte. And "bool" is just a typedef of _Bool in
> the kernel headers.
> 

Oops, I just used bool outside kernel tree..

>> Every thing that reduces code size (without sacrifice readability
>> and maintain maintainability) should be worth.
> 
> Agreed, within reason. But this patch doesn't reduce code size - it

I meant binary size.

> makes the code fractionally more complicated and reduces the *binary*
> size by a few bytes.
> 

It's a commonly used skill in kernel code, so I can't say it makes
code more complicated.

That said, I'll happily drop this patch. It just came to me when I
started to add new bool values to the structure. Or if you prefer
bool xxx:1 or just bool xxx, I can do that.

>> This is one of the reasons we accept patches that replacing
>> kmalloc+memset with kzalloc, which just saves 8 bytes in my box.
>>
> 
> Replacing two function calls with one function call is a code
> simplification and hence (generally) a good thing - the minuscule
> reduction in binary size reduction that comes with it is just noise.
> 
