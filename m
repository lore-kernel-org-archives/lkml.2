Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2FDAQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 20:16:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35904 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab2FDAQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 20:16:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120604000059.GA14144@redhat.com>
References: <20120603223617.GB7707@redhat.com> <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120604000059.GA14144@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 3 Jun 2012 17:16:30 -0700
X-Google-Sender-Auth: 5rpLQSpnyN9KoQl3zAHZDyiQ41k
Message-ID: <CA+55aFwJO40594yLH0gS_7YurDGAojVYfgBQXLNawraV_jdNsQ@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 5:00 PM, Dave Jones <davej@redhat.com> wrote:
>
> sysrq-d: http://fpaste.org/ow9O/

Ugh. I'm adding PeterZ to the cc, just to see if he can make more sense of it.

Peter, is there no way to make the lock thing print not just the lock
class name, but also the pointer to the actual *instance* of the lock
held?

Also, it's a bit unclear to me, but I *think* that most of those users
don't actually "hold" the lock - they are waiting for it. Yes/no? Does
the lockdep information have the capability to distinguish between
"waiting for" vs "actually successfully owns the lock"?

              Linus
