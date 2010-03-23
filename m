Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0CWUxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:53:34 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36368 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab0CWUxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:53:33 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] proc: task->signal can't be NULL
References: <20100322184127.GA3952@redhat.com>
	<m1ocifvkzl.fsf@fess.ebiederm.org> <20100323183116.GA22516@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 23 Mar 2010 13:53:26 -0700
In-Reply-To: <20100323183116.GA22516@redhat.com> (Oleg Nesterov's message of "Tue\, 23 Mar 2010 19\:31\:16 +0100")
Message-ID: <m1sk7qu5dl.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: oleg@redhat.com, linux-kernel@vger.kernel.org, roland@redhat.com, adobriyan@gmail.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 03/22, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>
> If a bad user passes the large f_pos > nr_threads then this check
> eliminates the unneeded while_each_thread() loop, yes. But it can use
> f_pos == nr_threads and provoke the same loop?
>
> Or. just do rewinddir() + readdir(big_count). Now we walk through the
> list and call proc_task_fill_cache() for each entry.
>
> IOW, I don't understand how this check can help from the DOS pov.

It can't.   I just want it to be able to ;)

>> However:
>> proc_task_getattr uses get_nr_threads to get it's nlink count correct.
>
> Yes. But we don't need the exactly precise number here if we are
> racing with fork/exit ?
>
>> Not walking the thread list to get the number of threads seems like an
>> important cpu time saving measure.
>
> Not sure I understand... Also, first_tid() could use sig->sigcnt (the
> reference counter) instead of sig->count. This is not the same, but I
> think in practice this is fine.

We need a value that can be computed in constant time, and is not correct
except when the number of threads is actively changing.

> OK. Let's keep this counter as "int nr_thread".
>
> Besides, when I tried to re-implement get_nr_threads() using signal->live
> I got the really ugly result ;)

Sounds good.

Eric
