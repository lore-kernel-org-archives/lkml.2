Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab1CaPuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:50:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758059Ab1CaPuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:50:22 -0400
Date: Thu, 31 Mar 2011 11:49:42 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
Message-ID: <20110331154941.GA32045@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>
References: <20110329040939.GA32764@redhat.com>
 <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com>
 <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
 <20110331035511.GA1255@redhat.com>
 <AANLkTikP5edK=YSRx7zuNqyfwez8qEHpFumYun6GOPxu@mail.gmail.com>
 <20110331145850.GA10163@redhat.com>
 <20110331150344.GB10163@redhat.com>
 <AANLkTimAGbzYe7PNG1xhjsA12zErpRasTso711cq8UHq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimAGbzYe7PNG1xhjsA12zErpRasTso711cq8UHq@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 08:25:36AM -0700, Linus Torvalds wrote:
 > On Thu, Mar 31, 2011 at 8:03 AM, Dave Jones <davej@redhat.com> wrote:
 > > On Thu, Mar 31, 2011 at 10:58:50AM -0400, Dave Jones wrote:
 > >
 > > bah I missed a level. which seems to be the smoking gun.
 > > something in the tty layer seems to have gone nuts.
 > 
 > Ahhah. That is indeed the smoking gun.
 > 
 > I bet it's an old problem where something causes some stupid tty
 > ping-pong behaviour, and now it has become a high-CPU thing triggered
 > by commit f23eb2b2b285 ("tty: stop using "delayed_work" in the tty
 > layer").
 > 
 > Before that commit, if the tty layer got somehow confused, it would
 > always delay for a timer tick in between doing nothing. Now it will go
 > pretty much full blast. Which explains your CPU being hot.

That's a recent change though, and I first saw this back in November.

	Dave

