Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab1CaP7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:59:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758510Ab1CaP7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:59:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110331154941.GA32045@redhat.com>
References: <20110329040939.GA32764@redhat.com> <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com> <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
 <20110331035511.GA1255@redhat.com> <AANLkTikP5edK=YSRx7zuNqyfwez8qEHpFumYun6GOPxu@mail.gmail.com>
 <20110331145850.GA10163@redhat.com> <20110331150344.GB10163@redhat.com>
 <AANLkTimAGbzYe7PNG1xhjsA12zErpRasTso711cq8UHq@mail.gmail.com> <20110331154941.GA32045@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 Mar 2011 08:58:14 -0700
Message-ID: <AANLkTik=WBy7CRQSENiiRfi2BFtwL5iT9d3RBK4uZz1d@mail.gmail.com>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 8:49 AM, Dave Jones <davej@redhat.com> wrote:
>
> That's a recent change though, and I first saw this back in November.

So your November report said that you could see "thousands" of these a
second. But maybe it didn't use up all CPU until recently?

Especially if you have a high CONFIG_HZ value, you'd still see a
thousand flushes a second even with the old "delay a bit". So it would
use a fair amount of CPU, and certainly waste a lot of power. But it
wouldn't pin the CPU entirely.

With that commit f23eb2b2b285, the buggy case would become basically
totally CPU-bound.

I dunno. Right now 'trinity' just ends up printing out a lot of system
call errors for me. I assume that's its normal behavior?

                               Linus
