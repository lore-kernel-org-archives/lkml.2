Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2GQPlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:41:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36315 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2GQPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:41:09 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207170925250.13599@router.home>
References: <1342528415-2291-1-git-send-email-js1304@gmail.com>
	<1342528415-2291-2-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1207170925250.13599@router.home>
Date: Wed, 18 Jul 2012 00:41:08 +0900
Message-ID: <CAAmzW4OaNNPATQ_Jm6vfXJ1pkLMZ7HFFbhA8rXQkiXs2KeiPjQ@mail.gmail.com>
Subject: Re: [PATCH 2/4 v2] mm: fix possible incorrect return value of
 migrate_pages() syscall
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/17 Christoph Lameter <cl@linux.com>:
> On Tue, 17 Jul 2012, Joonsoo Kim wrote:
>
>> @@ -1382,6 +1382,8 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
>>
>>       err = do_migrate_pages(mm, old, new,
>>               capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
>> +     if (err > 0)
>> +             err = -EBUSY;
>>
>>       mmput(mm);
>>  out:
>
> Why not have do_migrate_pages() return EBUSY if we do not need the number
> of failed/retried pages?

There is no serious reason.
do_migrate_pages() have two callsites, although another one doesn't
use return value.
do_migrate_pages() is commented "Return the number of page ...".
And my focus is fixing possible error in migrate_pages() syscall.
So, I keep to return the number of failed/retired pages.

If we really think the number of failed/retired pages is useless, in that time,
instead that do_migrate_pages() return EBUSY, we can make migrate_pages()
return EBUSY. I think it is better to fix all the related codes at one go.
