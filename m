Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab2AKWlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 17:41:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52369 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2AKWlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 17:41:09 -0500
MIME-Version: 1.0
In-Reply-To: <20120111135847.d28425c6.akpm@linux-foundation.org>
References: <1326307625-11561-1-git-send-email-xtfeng@gmail.com>
	<20120111204330.GT2618@outflux.net>
	<20120111135847.d28425c6.akpm@linux-foundation.org>
Date: Wed, 11 Jan 2012 14:41:09 -0800
X-Google-Sender-Auth: 1n6xKuYiuvitme3RMXEn7dd_ohE
Message-ID: <CAGXu5jKNWMYnTdh-t2C9gG2PL+frRSOY=O5hyuHmN2uyQ3YFbg@mail.gmail.com>
Subject: Re: [PATCH] proc: fix null pointer deref in proc_pid_permission()
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Xiaotian Feng <xtfeng@gmail.com>, linux-kernel@vger.kernel.org,
        Xiaotian Feng <dannyfeng@tencent.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 1:58 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 11 Jan 2012 12:43:30 -0800
> Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Jan 11, 2012 at 01:47:05PM -0500, Xiaotian Feng wrote:
>> > get_proc_task() can fail to search the task and return NULL, put_task_struct()
>> > will then bomb the kernel with following oops:
>> >
>> > [ 1870.574045] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
>> > [ 1870.574065] IP: [<ffffffff81217d34>] proc_pid_permission+0x64/0xe0
>> > [ 1870.574088] PGD 112075067 PUD 112814067 PMD 0
>> > [ 1870.574106] Oops: 0002 [#1] PREEMPT SMP
>> >
>> > This is a regression introduced by commit 0499680a, kernel should
>> > return -ESRCH if get_proc_task() failed.
>>
>> Nice catch!
>>
>> However since this error is returned to userspace, shouldn't this be
>> -ENOENT instead?
>
> Failed get_proc_task() frequently results in -ESRCH.  And less
> frequently results in -ENOENT.
>
> It seems odd that inode_operations.permission() would ever return
> anything other than zero or -EPERM.

Right, but won't this show up at ESRCH from open(2)? If this is used
as-is, we just need to have the manpages updated.

-Kees

-- 
Kees Cook
ChromeOS Security
