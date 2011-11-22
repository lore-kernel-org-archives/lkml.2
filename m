Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab1KVFjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 00:39:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab1KVFjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 00:39:47 -0500
Message-ID: <4ECB3587.3020909@redhat.com>
Date: Tue, 22 Nov 2011 13:39:19 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org
Subject: Re: [V2 PATCH] tmpfs: add fallocate support
References: <1321612791-4764-1-git-send-email-amwang@redhat.com> <alpine.LSU.2.00.1111201300340.1264@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1111201300340.1264@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月21日 05:22, Hugh Dickins 写道:
> On Fri, 18 Nov 2011, Cong Wang wrote:
>
>> It seems that systemd needs tmpfs to support fallocate,
>> see http://lkml.org/lkml/2011/10/20/275. This patch adds
>> fallocate support to tmpfs.
>>
>> As we already have shmem_truncate_range(), it is also easy
>> to add FALLOC_FL_PUNCH_HOLE support too.
>
> Thank you, this version looks much much nicer.
>
> I wouldn't call it bug-free (don't you need a page_cache_release
> after the unlock_page?), and I won't be reviewing it and testing it
> for a week or two - there's a lot about the semantics of fallocate
> and punch-hole that's not obvious, and I'll have to study the mail
> threads discussing them before checking your patch.

Yeah, sorry, I missed unlock_page()...

>
> First question that springs to mind (to which I shall easily find
> an answer): is it actually acceptable for fallocate() to return
> -ENOSPC when it has already completed a part of the work?

Ah, good point, I will fix this as what Christoph suggested.

>
> But so long as the details don't end up complicating this
> significantly, since we anyway want to regularize the punch-hole
> situation by giving tmpfs the same interface to it as other filesystems,
> I now think it would be a bit perverse to disallow the original
> fallocate functionality that you implement here in-kernel.
>

Ok, I think you mean you are fine to accept it now?

Anyway, thanks a lot for your comments!
