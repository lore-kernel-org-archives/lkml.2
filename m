Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0EGCs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 22:48:29 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:56328 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab0EGCs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 22:48:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=g2bg0gNHIx4z6jDekc92Qb4NiuBS5FPVazj8LOLcjW95lf8/gkVWSp/mLaWnTTGIYg
         5J8cMvxzo/qIJgI5IYEnGtlU0TkkImmua1JJbcHECuTHcClq7mvwbOJqnbFsrdgA7bcr
         nqxJ2/uIk0xchyZYunE7dUhvkPfxk6DAMkNBA=
MIME-Version: 1.0
In-Reply-To: <1273171863.1642.258.camel@laptop>
References: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com> 
	<alpine.DEB.2.00.1005061140100.2642@makko.or.mcafeemobile.com> 
	<1273171863.1642.258.camel@laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 7 May 2010 10:48:05 +0800
Message-ID: <o2l412e6f7f1005061948u1ca0fe54of0b453846c678c85@mail.gmail.com>
Subject: Re: [PATCH] epoll: use wrapper functions
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Takashi Iwai <tiwai@suse.de>, David Howells <dhowells@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 2:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-05-06 at 11:47 -0700, Davide Libenzi wrote:
>> Since we already have __add_wait_queue(), __add_wait_queue_tail() and
>> __remove_wait_queue() (which all means "locked"), and while I agree in
>> having the exclusive-add wrapped into a function, I much better prefer a:
>>
>> static inline void __add_wait_queue_excl(wait_queue_head_t *head,
>>                                          wait_queue_t *new)
>> {
>>         new->flags |= WQ_FLAG_EXCLUSIVE;
>>         __add_wait_queue(head, new);
>> }
>>
>> The patch you posted introduces a different naming, which leaves all the
>> other __*() untouched, and wraps the already one-liner __remove_wait_queue()
>> with yet another one-liner.
>
> I concur, I always get confused by the _locked postfix (and its more
> typing). Also, it goes against the lock data not code paradigm.
>
>

I greped all the code, and found that
add_wait_queue_head_exclusive_locked() and remove_wait_queue_locked()
aren't used. It seems that no users like these APIs. So I will remove
these two APIs, and add __add_wait_queue_excl() instead. Thanks.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
