Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149Ab2EJPjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:39:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58508 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334Ab2EJPjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:39:06 -0400
MIME-Version: 1.0
In-Reply-To: <4FABD6BE.1060401@redhat.com>
References: <1336066477-3964-1-git-send-email-rajman.mekaco@gmail.com>
	<4FA2C946.60006@redhat.com>
	<4FA2EA4A.6040703@redhat.com>
	<CAMYGaxosaVXmpQQqpq+bGV9F7-i8APTpDq=ErWdhw2EHGEzmKg@mail.gmail.com>
	<CAMYGaxruZbhvtZg76_zo6-BjChObpCAE8-MTA=xbBOavct+XNw@mail.gmail.com>
	<4FABD6BE.1060401@redhat.com>
Date: Thu, 10 May 2012 21:09:05 +0530
Message-ID: <CAMYGaxqxb=XR8R26h4e2URA2hG2M3j9V4u0DLJ9ifmkZKJa+eg@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 8:24 PM, Rik van Riel <riel@redhat.com> wrote:
> On 05/10/2012 09:34 AM, rajman mekaco wrote:
>
>> Any updates on this ?
>
>
> There is still no usecase to demonstrate a problem, so no real
> justification to merge the patch.  Coming up with such a usecase
> is up to the submitter of the patch.

Maybe you didn't read my last email:
If 2 different user-mode processes executing on 2 CPUs under 2 different
users want to access the same shared memory through the
shmctl(SHM_LOCK) / shmget(SHM_HUGETLB) / usr_shm_lock
primitives, they could compete/spin even though their user_structs
are different.

Can you please correct me if I am missing some crucial point of understanding ?

Or did you mean that I should update the ChangeLog with this kind of
description ?

>
> --
> All rights reversed
