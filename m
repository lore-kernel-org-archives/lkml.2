Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1E1R4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:56:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659Ab1E1R4T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:56:19 -0400
MIME-Version: 1.0
In-Reply-To: <m1lixr4kz8.fsf@fess.ebiederm.org>
References: <m1lixr4kz8.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 28 May 2011 10:55:55 -0700
Message-ID: <BANLkTi=-DHpvAm_9J9y+rOxB25e=4kCjYA@mail.gmail.com>
Subject: Re: [PATCH] ns: Wire up the setns system call for 2.6.40-rc1 or whatever
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Daniel Lezcano <dlezcano@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 7:28 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> 32bit and 64bit on x86 are tested and working.  The rest I have looked
> at closely and I can't find any problems.

So I really don't think this was even worth it. I applied the patch,
but I think that you should just have done the architecture you
tested, and left it to arch maintainers to add it as they will.

That's how we tend to do this, and it works. It also avoids surprises
when people then invariably end up having clashes due to system calls
being added. Even in just the 15 hours since you sent the email, I had
merged more code from ARM, and the patch no longer applied to my tree.
It's trivial to fix up, so that's not the problem, but the problem is
with different people adding system calls resulting in re-numbering.

In other words, it's simply better to strive to have *one* entity in
charge of picking the system call number, rather than do it like this.
Ergo: leave it to architecture maintainers to minimize the issue of
system call renumbering.

                        Linus
