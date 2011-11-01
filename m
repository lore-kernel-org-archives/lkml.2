Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1KAP2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 11:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab1KAP2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 11:28:24 -0400
Date: Tue, 1 Nov 2011 16:23:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: trisha yad <trisha1march@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <htejun@gmail.com>
Subject: Re: Issue with core dump
Message-ID: <20111101152320.GA30466@redhat.com>
References: <CAGr+u+zkPiZpGefstcbJv_cj929icWKXbqFy1uR22Hns1hzFeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGr+u+zkPiZpGefstcbJv_cj929icWKXbqFy1uR22Hns1hzFeQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01, trisha yad wrote:
>
> Dear all,
>
> I am running a multithreaded  application. So consider a global
> variable x which is used by a, b and c thread.
>
> In thread 'a' do abnormal operation(invalid memory access) and kernel
> send signal kill to it. In the mean time Thread 'b' and Thread 'c'
> got schedule and update
> the variable x. when I got the core file, variable x  got updated, and
> I am not  getting actual value that is present at time of crash of
> thread a.
> But In core file I got updated value of x. I want In core file exact
> the same memory status as it at time of abnormal operation(invalid
> memory access)

Yes, this is possible.

> Is there any solution for such problem. ?
>
> I want in core dump the same status  of memory as at time of abnormal
> operation(invalid memory access).

I don't think we can "fix" this.

We can probably change complete_signal() to notify other threads
"immediately", but this is not simple and obviously can not close
the window completely.

Whatever we do, we can't "stop" other threads at the time when
thread 'a' traps. All we can do is to try to shrink the window.

Oleg.

