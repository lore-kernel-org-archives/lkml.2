Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab2EEFw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 01:52:56 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34611 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2EEFwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 01:52:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120505143629.57126695eba8787d1033ac7b@canb.auug.org.au>
References: <1336067860-19953-1-git-send-email-jim.cromie@gmail.com>
 <1336067860-19953-3-git-send-email-jim.cromie@gmail.com> <20120505143629.57126695eba8787d1033ac7b@canb.auug.org.au>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 4 May 2012 23:52:24 -0600
Message-ID: <CAJfuBxzy224rg9No5L281gkp369ZfTjqADpeoxysvL5oNDk-Ng@mail.gmail.com>
Subject: Re: [PATCH 3/3] dynamic_debug: remove unneeded includes
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        jbaron@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, May 4, 2012 at 10:36 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Jim,
>
> On Thu,  3 May 2012 11:57:39 -0600 Jim Cromie <jim.cromie@gmail.com> wrote:
>>
>> These arent currently needed, so drop them.  Some will probably get
>> re-added when static-branches are added, but include loops prevent
>> that at present.
>
> How sure are you that these are not needed?  Has this been done by
> inspection, or by compile testing?  How widely have you compile tested?
>

compiled on Core, and boot tested on i586
also recently compiled on x86_64

IIRC (its been a while) I just commented them all out,
and uncommented the ones needed to compile ok.

That doesnt mean theyre not being included indirectly,
so youre right to be paranoid.

> I took a brief look ...
>
>>
>> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>> ---
>>  lib/dynamic_debug.c |   10 ----------
>>  1 files changed, 0 insertions(+), 10 deletions(-)
>>
>> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
>> index 7ca29a0..fc5d270 100644
>> --- a/lib/dynamic_debug.c
>> +++ b/lib/dynamic_debug.c
>> @@ -14,24 +14,14 @@
>>
>>  #include <linux/kernel.h>
>>  #include <linux/module.h>
>> -#include <linux/moduleparam.h>
>
> There is a use of module_param() in this file ...
>
>> -#include <linux/kallsyms.h>
>> -#include <linux/types.h>
>>  #include <linux/mutex.h>
>> -#include <linux/proc_fs.h>
>>  #include <linux/seq_file.h>
>> -#include <linux/list.h>
>
> List_for_each_entry is used ...
>
>> -#include <linux/sysctl.h>
>>  #include <linux/ctype.h>
>> -#include <linux/string.h>
>
> strlen() is used ...
>
>> -#include <linux/uaccess.h>
>
> copy_from_user() is used ...


>
>>  #include <linux/dynamic_debug.h>
>>  #include <linux/debugfs.h>
>>  #include <linux/slab.h>
>> -#include <linux/jump_label.h>
>>  #include <linux/hardirq.h>
>>  #include <linux/sched.h>
>> -#include <linux/device.h>
>
> struct device is referenced ...
>
> I am a bit more paranoid about these things than most.

I guess I better make lib/dynamic_debug.i
inspect the file, and possibly revert parts of this patch.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/


thanks for taking that look.
Jim


BTW, how were you carrying that merge conflict resolution ?
git rerere ?
