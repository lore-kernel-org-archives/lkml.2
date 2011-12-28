Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1L1VHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 16:07:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab1L1VHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 16:07:41 -0500
Message-ID: <4EFB850C.4030801@redhat.com>
Date: Wed, 28 Dec 2011 22:07:24 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?xYF1a2FzeiBNaWNoYWxpaw==?= <lmi@ift.uni.wroc.pl>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: Possible bug introduced in commit 9b84cca
References: <201112281955.55200.vda.linux@googlemail.com>
In-Reply-To: <201112281955.55200.vda.linux@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2011 07:55 PM, Denys Vlasenko wrote:
> Hi Tejun, Oleg,
>
> Apologies if you are already informed about this bug
> by people who originally discovered it.
>
> Looks like after commit 9b84cca, waitpid under strace
> sometimes returns bogus ECHILD while child does exist.
>
> I did not yet confirm that the bug appeared exactly
> at this commit - Łukasz says that.
>
> I confirmed that bug exists on kernels 3.1.6 (in Fedora)
> and 3.1.0-rc4 (vanilla).

I tested it under a few more Fedora kernels.
On kernel-PAE-2.6.39-1.fc16.i686 bug does not trigger.
On next Fedora kernel, kernel-PAE-3.0-0.rc1.git0.2.fc16.i686,
it triggers.

And indeed, these kernels differ in kernel/exit.c::wait_consider_task()
only by commit 9b84cca.

Oleg, if you need to test it, I have the setup on my machine.

On Thu, Nov 17, 2011 at 10:25:26AM +0100, Łukasz Michalik wrote:
 > The bug only happens on recent linux.  I've bisected the kernel and
 > found that it was introduced by 9b84cca2564b9 [2] in linux.git, so
 > pretty much everything since 3.0-rc2 is affected.

Łukasz, looks like 3.0-rc1 is affected too.

-- 
vda
