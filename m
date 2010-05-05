Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab0EEHSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:18:47 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:50933 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab0EEHSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sYp9QUUOgF2Jvihe/mwoa4IrsvVtKZR2dVqb1h+b6G7y0+owSF0xjmMqkUO/zVTznH
         Oqyj3HLGlsatbH8nTiB+tIUYauXbFpUm2Hl5gn52HXP0TfmNvj1tQJnxIuqtwS8yir+x
         eXtxZ4+fu/Ctuwx2UV2ISmzZNBGrgmjvcXutM=
Message-ID: <4BE11BD0.8040703@suse.cz>
Date: Wed, 05 May 2010 09:18:40 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.5pre) Gecko/20100430 SUSE/3.1b2-7.1 Thunderbird/3.1b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Changli Gao <xiaosuo@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       eric.dumazet@gmail.com
Subject: Re: [PATCH v2] fs: use kmalloc() to allocate fdmem if possible
References: <1272826920-8899-1-git-send-email-xiaosuo@gmail.com> <20100504152713.0c72a087.akpm@linux-foundation.org>
In-Reply-To: <20100504152713.0c72a087.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 12:27 AM, Andrew Morton wrote:
> On Mon,  3 May 2010 03:02:00 +0800
> Changli Gao <xiaosuo@gmail.com> wrote:
> 
>> use kmalloc() to allocate fdmem if possible.
>>
>> vmalloc() is used as a fallback solution for fdmem allocation. A new helper
>> function __free_fdtable() is introduced to reduce the lines of code.
>>
>> A potential bug, vfree() a memory allocated by kmalloc(), is fixed.
>>
> 
> Seems a reasonable thing to do.

Hi,

So didn't we converge to something like this:
http://lkml.org/lkml/2010/5/3/53
instead of this patch?

This

>  It might also be reasonable to make
> vmalloc() try kmalloc() first, but that's a separate exercise.

and this

> This most definitely should have __GFP_NOWARN.

is discussed there too btw.

thanks,
-- 
js
suse labs
