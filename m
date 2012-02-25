Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab2BYENQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 23:13:16 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39774 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2BYENP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 23:13:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bsingharora@gmail.com designates 10.229.78.206 as permitted sender) smtp.mail=bsingharora@gmail.com; dkim=pass header.i=bsingharora@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F47E0D0.9030409@fb.com>
References: <1326912662-18805-1-git-send-email-asharma@fb.com>
	<CAKTCnzn-reG4bLmyWNYPELYs-9M3ZShEYeOix_OcnPow-w8PNg@mail.gmail.com>
	<4F468888.9090702@fb.com>
	<20120224114748.720ee79a.kamezawa.hiroyu@jp.fujitsu.com>
	<CAKTCnzk7TgDeYRZK0rCugopq0tO7BtM8jM9U0RJUTqNtz42ZKw@mail.gmail.com>
	<4F47E0D0.9030409@fb.com>
Date: Sat, 25 Feb 2012 09:43:14 +0530
Message-ID: <CAKTCnznyZGLiZPNS151GzsUMApN_SYu3n6xX9E0ceMpq9JNq7w@mail.gmail.com>
Subject: Re: [PATCH] mm: Enable MAP_UNINITIALIZED for archs with mmu
From: Balbir Singh <bsingharora@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 12:41 AM, Arun Sharma <asharma@fb.com> wrote:
> On 2/24/12 6:51 AM, Balbir Singh wrote:
>>
>> On Fri, Feb 24, 2012 at 8:17 AM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com>  wrote:
>>>>
>>>> They don't have access to each other's VMAs, but if "accidentally" one
>>>> of them comes across an uninitialized page with data from another task,
>>>> it's not a violation of the security model.
>>
>>
>> Can you expand more on the single address space model?
>
>
> I haven't thought this through yet. But I know that just adding
>
> && (cgroup_task_count() == 1)
>
> to page_needs_clearing() is not going to do it. We'll have to design a new
> mechanism (cgroup_mm_count_all()?) and make sure that it doesn't race with
> fork() and inadvertently expose pages from the new address space to the
> existing one.
>
> A uid based approach such as the one implemented by Davide Libenzi
>
> http://thread.gmane.org/gmane.linux.kernel/548928
> http://thread.gmane.org/gmane.linux.kernel/548926
>
> would probably apply the optimization to more use cases - but conceptually a
> bit more complex. If we go with this more relaxed approach, we'll have to
> design a race-free cgroup_uid_count() based mechanism.

Are you suggesting all processes with the same UID should have access
to each others memory contents?

Balbir
