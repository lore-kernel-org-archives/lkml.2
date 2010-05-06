Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0EFB0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 21:26:01 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40356 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab0EFBZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 21:25:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ar9hZ15ua1M5tFKnFtsS9aOjWEHTZyMJKXJcZAbLAqmIuT3+m29OTrkRJFM9vxx5J8
         bHt10flF25HqtJw+5VI0vi/OTho9ywAwBFvdE3iKY5U4iAY60GhJjOfg9fuJ6thiG8T7
         vS4fDmt9HLHyryO2iF8FS5c7/pSUQi3EmJchs=
MIME-Version: 1.0
In-Reply-To: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
References: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Thu, 6 May 2010 09:25:38 +0800
Message-ID: <y2p412e6f7f1005051825g84b801bcx44e26ca58d0239c4@mail.gmail.com>
Subject: Re: [RFC] mm: generic adaptive large memory allocation APIs
To: akpm@linux-foundation.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
       Changli Gao <xiaosuo@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 6, 2010 at 8:30 AM, Changli Gao <xiaosuo@gmail.com> wrote:
> kvmalloc() will try to allocate physically contiguous memory first, and try
> vmalloc to allocate virtually contiguous memory when the former allocation
> fails.
>
> kvfree() is used to free the memory allocated by kvmalloc(). It can't be used
> in atomic context. If the callers are in atomic contex, they can use
> kvfree_inatomic() instead.
>
> There is much duplicate code to do such things in kernel, so I generate the
> above APIs.
>
> Thank Eric Dumazet for the "kv" prefix. :)
>
> #include <linux/kernel.h>
> #include <linux/module.h>
> #include <linux/mm.h>
> #include <linux/init.h>
> #include <linux/slab.h>
> #include <linux/vmalloc.h>
> #include <linux/interrupt.h>
>
> void *kvmalloc(size_t size)
> {
>        void *ptr;
>
>        if (size < PAGE_SIZE)
>                return kmalloc(PAGE_SIZE, GFP_KERNEL);

typo mistake, should be kmalloc(size, GFP_KERNEL), thank Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp>.



-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
