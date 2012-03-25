Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2CYSFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 14:05:42 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48906 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab2CYSFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 14:05:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAAHN_R3mFzmtCey_0JEHp=EAGh1sb87szpsKD_JkFwwYLCnKug@mail.gmail.com>
References: <4F57A3EC.7070101@gmail.com>
	<1331660076-32766-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<20120313131616.f66dbdad.akpm@linux-foundation.org>
	<CAAHN_R3mFzmtCey_0JEHp=EAGh1sb87szpsKD_JkFwwYLCnKug@mail.gmail.com>
Date: Sun, 25 Mar 2012 14:05:37 -0400
X-Google-Sender-Auth: ZSa7pcJIou4fAbOwR0PY0oNxzac
Message-ID: <CAP=VYLpUzuom-HUS-LYSuQmMZSRvC_Qjgyy9hnKqBowh-95YPQ@mail.gmail.com>
Subject: Re: [PATCH] -mm/linux-next: procfs: Mark thread stack correctly in proc/<pid>/maps
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-next <linux-next@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Jamie Lokier <jamie@shareable.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Matt Mackall <mpm@selenic.com>, Mike Frysinger <vapier@gentoo.org>,
        Oleg Nesterov <oleg@redhat.com>, Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 9:38 AM, Siddhesh Poyarekar
<siddhesh.poyarekar@gmail.com> wrote:
> On Wed, Mar 14, 2012 at 1:46 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Tue, 13 Mar 2012 23:04:36 +0530
>> Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com> wrote:
>>
>>> Following is the updated patch with requested changes incorporated.
>>
>> Boy, that's a lot of changes (below).  What does it all do?
>>
>
> Hi,
>
> Since this patch was included in the -mm tree on March 14th, I assumed
> that linux-next would get the patch in today's merge, but it hasn't.
> Is there something I am missing? Does the patch need additional
> review/acks that I need to request for?

Hi Siddhesh,

It looks like this still fails.   The original failure was:

super.c:(.text+0x3ffd8): undefined reference to `vm_is_stack'

Now it is:

mm/nommu.o: In function `vm_is_stack':
nommu.c:(.text+0x2178): multiple definition of `vm_is_stack'
mm/util.o:util.c:(.text+0x2bc): first defined here
make[2]: *** [mm/built-in.o] Error 1

http://kisskb.ellerman.id.au/kisskb/buildresult/5941188/

Can you include in your testing for v3, the ARM at91x40_defconfig please?

Thanks,
Paul.

>
> Thanks,
> Siddhesh
>
> Thanks,
> Siddhesh
>
>
> --
> Siddhesh Poyarekar
> http://siddhesh.in
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
