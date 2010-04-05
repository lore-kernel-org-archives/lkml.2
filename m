Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0DEPyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:54:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49499 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab0DEPya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y+H5v9GkyelVTbNCQ1jr93sfaa4zz9itnZQc6osktlU2oPvijAHE8hSb5OOabrD37I
         gdpgpyYgrWNhb38OIf+CVYLcPfVPTyI07B1nK3kUtVeMX62RNcYyKakqZ7Jmk1tF3LXC
         YzZu+RUXNS2ImiR1L0G/50HmxmuYs4Kwms8pw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004050824400.21313@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
	 <20100402175937.GA19690@liondog.tnic>
	 <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
	 <20100402112428.f46ddc44.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1004021135530.3634@i5.linux-foundation.org>
	 <4BB66941.1060809@redhat.com>
	 <1270397575.1814.106.camel@barrios-desktop>
	 <20100404190925.5daac2f3@annuminas.surriel.com>
	 <alpine.LFD.2.00.1004050824400.21313@i5.linux-foundation.org>
Date: Tue, 6 Apr 2010 00:48:35 +0900
Message-ID: <r2y28c262361004050848v75fc5397j7c5aafa9c0c6206e@mail.gmail.com>
Subject: Re: [PATCH] rmap: fix anon_vma_fork() memory leak
From: Minchan Kim <minchan.kim@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 12:37 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sun, 4 Apr 2010, Rik van Riel wrote:
>>
>> Fix a memory leak in anon_vma_fork(), where we fail to tear down the
>> anon_vmas attached to the new VMA in case setting up the new anon_vma
>> fails.
>>
>> Reported-by: Minchan Kim <minchan.kim@gmail.com>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index fcd593c..fb7ce99 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -231,6 +231,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
>>
>>   out_error_free_anon_vma:
>>       anon_vma_free(anon_vma);
>> +     unlink_anon_vmas(vma);
>>   out_error:
>>       return -ENOMEM;
>>  }
>
> This looks _very_ wrong to me.
>
> Shouldn't the unlink_anon_vmas() be in the "out_error" case? IOW, we
> should do it even if the "anon_vma_alloc()" failed, nbot just if the
> "anon_vma_chain_alloc()" failed?
>
> No?
>
> What am I missing?

Indeed. You're right.
I should have been reviewed more carefully.



-- 
Kind regards,
Minchan Kim
