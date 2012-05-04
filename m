Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab2EDBMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 21:12:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62712 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab2EDBMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 21:12:42 -0400
MIME-Version: 1.0
In-Reply-To: <4FA2EA4A.6040703@redhat.com>
References: <1336066477-3964-1-git-send-email-rajman.mekaco@gmail.com>
	<4FA2C946.60006@redhat.com>
	<4FA2EA4A.6040703@redhat.com>
Date: Fri, 4 May 2012 06:42:41 +0530
Message-ID: <CAMYGaxosaVXmpQQqpq+bGV9F7-i8APTpDq=ErWdhw2EHGEzmKg@mail.gmail.com>
Subject: Re: [PATCH 1/1] mlock: split the shmlock_user_lock spinlock into per
 user_struct spinlock
From: rajman mekaco <rajman.mekaco@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@gentwo.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you all for replying back.

>
> Hold this ... while the patch is correct, Peter raised
> a valid concern about its usefulness, which should be
> sorted out first.
>

Can't the shmctl(SHM_LOCK) system call be called for a huge number of
usermode processes ?

Other place from where usr_shm_lock() is called is for hugetlb from
shmget(SHM_HUGETLB)
system call via ipc_get().

As far as users are concerned, I think that if even 2 user_structs
encounter this on 2 different CPUs,
why should the processors waste any time at all at looping even once
if they belong to different
user_structs ?

I totally agree with you that maybe if we look at the entire workloads
it probably wouldn't matter much
because of low number of users, but why should the CPUs compete and
spin for different users at all
when nothing global is affected ?
