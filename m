Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1ATHh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 02:37:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab1ATHh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 02:37:26 -0500
Message-ID: <4D37E617.3000201@redhat.com>
Date: Thu, 20 Jan 2011 15:36:55 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [Patch] printk: move some loglevel setup functions to kernel/printk.c
References: <1295422165-22269-1-git-send-email-amwang@redhat.com> <20110119121855.c529f84f.akpm@linux-foundation.org>
In-Reply-To: <20110119121855.c529f84f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年01月20日 04:18, Andrew Morton 写道:
>> Cc: WANG Cong<amwang@redhat.com>, Ingo Molnar<mingo@elte.hu>  (commit_signer:8/43=19%,commit_signer:4/26=15%), Andrew Morton<akpm@linux-foundation.org>  (commit_signer:7/43=16%,commit_signer:9/26=35%), Peter Zijlstra<a.p.zijlstra@chello.nl>  (commit_signer:5/43=12%), Tejun Heo<tj@kernel.org>  (commit_signer:4/43=9%), Arnd Bergmann<arnd@arndb.de>  (commit_signer:3/43=7%), James Morris<jmorris@namei.org>  (commit_signer:6/26=23%), Kees Cook<kees.cook@canonical.com>  (commit_signer:4/26=15%), Namhyung Kim<namhyung@gmail.com>  (commit_signer:3/26=12%)
>
> Pease don't do that.
>

Sorry for this, I used get_maintainers.pl in my script,
and now I fixed my script. :-/

> On Wed, 19 Jan 2011 15:29:24 +0800
> Amerigo Wang<amwang@redhat.com>  wrote:
>
>> These parameter setup functions should go to kernel/printk.c,
>
> That makes sense.
>
>> and should also be under CONFIG_PRINTK.
>
> Not so sure about that.  console_loglevel pertains to the console
> system more than to printk.  And the console layer is present even when
> CONFIG_PRINTK=n.


Such as?

>
> Now, it may be that console_loglevel never does anything useful when
> CONFIG_PRINTK=n.  In which case one wonders why the console code exists
> when CONFIG_PRINTK=n.
>
> Anyway.  I didn't look at all this terribly hard.  Please demonstrate
> to us that you did do so :)
>

With CONFIG_PRINTK=n we still have consoles and can still register
other consoles, but there will be no messages printed from kernel
to console. So, I think "quiet" is only meaningful to CONFIG_PRINTK=y.

Thanks.
