Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313Ab1CaP0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:26:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758261Ab1CaP0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:26:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110331150344.GB10163@redhat.com>
References: <20110329040939.GA32764@redhat.com> <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com> <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
 <20110331035511.GA1255@redhat.com> <AANLkTikP5edK=YSRx7zuNqyfwez8qEHpFumYun6GOPxu@mail.gmail.com>
 <20110331145850.GA10163@redhat.com> <20110331150344.GB10163@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 Mar 2011 08:25:36 -0700
Message-ID: <AANLkTimAGbzYe7PNG1xhjsA12zErpRasTso711cq8UHq@mail.gmail.com>
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

On Thu, Mar 31, 2011 at 8:03 AM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Mar 31, 2011 at 10:58:50AM -0400, Dave Jones wrote:
>
> bah I missed a level. which seems to be the smoking gun.
> something in the tty layer seems to have gone nuts.

Ahhah. That is indeed the smoking gun.

I bet it's an old problem where something causes some stupid tty
ping-pong behaviour, and now it has become a high-CPU thing triggered
by commit f23eb2b2b285 ("tty: stop using "delayed_work" in the tty
layer").

Before that commit, if the tty layer got somehow confused, it would
always delay for a timer tick in between doing nothing. Now it will go
pretty much full blast. Which explains your CPU being hot.

                        Linus
