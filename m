Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1FNSAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:00:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab1FNSAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:00:34 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTim_bHKdZnykedzW4re6GMCg+1Ed2g@mail.gmail.com>
References: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com> <BANLkTim_bHKdZnykedzW4re6GMCg+1Ed2g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Jun 2011 10:59:41 -0700
Message-ID: <BANLkTi=MvvdTZAHG3N=HHTQd9v6uPNHfzw@mail.gmail.com>
Subject: Re: Linux 3.0-rc3
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 5:15 AM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
>
> I've got a patch for my project to fix parsing of kernel version which
> has only two numbers. Basically,
>
> - scanf(ver, "%u.%u.%u", &a, &b, &c)
> + sscanf(ver, "%u.%u", &a, &b)

Please just fix it.

The projects that care about kernel version are buggy in so many ways
that it's not funny.

It's not just the "two versus three digits" bug either. The *bigger*
bug is usually that the tests are done the wrong way entirely, namely
to fail when you cannot parse the version. And that's just f*%!ing
stupid!

If you cannot parse the version, then rather than fail, a project
should have gone "uh, it's some future version that I don't recognize
or some other OS entirely, so I'll just do whatever the most modern
thing is". Having an "assert()" or returning an error is just the mark
of incompetence.

So please just fix things. Preferably by removing the version check
entirely, but if you really feel that you cannot do that, then AT
LEAST realize that the reason you're looking at the version is to
support *old* versions, not new ones, and make the logic work that way
(so that next time around, when we change the version numbers to be
sanscrit characters and you fail parsing them *again*, you don't
actually fail, you just go "oh, this is modern" and go on with your
life).

In other words: don't be stupid.

Ok?

                      Linus
