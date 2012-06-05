Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2FEQ5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:57:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50061 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2FEQ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:56:59 -0400
Message-ID: <4FCE3A56.9060400@gmail.com>
Date: Tue, 05 Jun 2012 10:56:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Roland Dreier <roland@purestorage.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: git bisect and perf
References: <4FCE25C6.2080601@gmail.com> <CAL1RGDWjA8uh3924s4+F=zD3EJpUXk6auJpi=zPWJRE4sY8FCw@mail.gmail.com>
In-Reply-To: <CAL1RGDWjA8uh3924s4+F=zD3EJpUXk6auJpi=zPWJRE4sY8FCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/12 9:51 AM, Roland Dreier wrote:
> On Tue, Jun 5, 2012 at 8:29 AM, David Ahern<dsahern@gmail.com>  wrote:
>> # git bisect good v2.6.38
>> Some good revs are not ancestor of the bad rev.
>> git bisect cannot work properly in this case.
>> Maybe you mistake good and bad revs?
>
> git bisect is telling you what is wrong -- as the man page says:
>
>      This command uses git rev-list --bisect to help drive the binary
>      search process to find which change introduced a bug, given an old
>      "good" commit object name and a later "bad" commit object name.
>
> so it assumes the good commit is older than the bad commit.
>
> You can actually use git bisect in your case, although it gets very confusing
> unless you write yourself a little wrapper alias: just swap the meaning of
> good and bad, ie do
>
> # git bisect start arch/x86/kernel/cpu/perf_event*
> # git bisect good v2.6.35
> # git bisect bad v2.6.38
>
> and try somehow to remember that when you do a test, "bad" means
> PEBS works and "good" means PEBS doesn't work.
>
>   - R.

Thanks, Roland. I'll reverse the logic.

David
