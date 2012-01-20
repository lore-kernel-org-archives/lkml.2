Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2ATLB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 06:01:29 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:48110 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2ATLBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 06:01:22 -0500
MIME-Version: 1.0
Date: Fri, 20 Jan 2012 12:01:21 +0100
X-Google-Sender-Auth: kf9oOQjEQz-kIwE-J2Dk0t5u5XY
Message-ID: <CAONaPpE7bkG4+wAQ58a+9MpMGvrWtqeQEyn0drSN6mBkCp0zoQ@mail.gmail.com>
Subject: Re: Planet CCRMA rt kernel errors (Real-time kernel)
From: John Kacur <jkacur@redhat.com>
To: "William M. Quarles" <walrus@bellsouth.net>
Cc: linux-rt-users@vger.kernel.org,
        Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
        planetccrma <planetccrma@ccrma.stanford.edu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 9:35 PM, William M. Quarles
<walrus@bellsouth.net> wrote:
> Hello linux-rt-users list,
>
> Fernando at CCRMA asked me to forward these bugs on to you. I hope that you can
> find the information useful.
>
> https://bugzilla.redhat.com/show_bug.cgi?id=773169
> https://bugzilla.redhat.com/show_bug.cgi?id=773170

Note, the above bugs were closed because they shouldn't have been
reported there in the first place, so it would have been nice if you
had taken the time to write two emails with the text of your problems
instead of pointing us there. You are more likely to get a response
that way. You also need to report the exact kernel versions.
Never-the-less:

I'll ignore the first bug for now, but ask you to retest when the
newest v3.0.14-rt32 is available. (Assuming this is the kernel version
you're working with, v3.0-rt, else let us know)

As for the second "bug", with MAX_STACK_TRACE_ENTRIES, this is a known
problem. If you don't care about lockdep, then you can ignore the
message, it won't harm anything it's just reporting that lockdep is
being disabled, but if you don't care about lockdep, you can also
disable it at config time.

You can also try to find this variable and up the number of trace
entries that are allowed, in fact I do this quite often. However, it
can be a game of whack-a-mole, because you up that value, and then
reach the max of another value, and then you have to up that too. It
is also possible to up everything so high that you will no-longer get
good rt performance.

Thanks
John
