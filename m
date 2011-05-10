Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173Ab1EJR1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 13:27:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39651 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab1EJR07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 13:26:59 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTik8DBNKrFE_hZi5FtxUY7Hw_BBR2Q@mail.gmail.com>
References: <BANLkTik8DBNKrFE_hZi5FtxUY7Hw_BBR2Q@mail.gmail.com>
Date: Tue, 10 May 2011 13:26:58 -0400
Message-ID: <BANLkTi=Y1TOqU+Pzx0cJ=c0oMxhMptR7=Q@mail.gmail.com>
Subject: Re: selinux troubleshooting
From: Eric Paris <eparis@parisplace.org>
To: Mark Leeds <markleeds2@gmail.com>
Cc: linux-kernel@vger.kernel.org, selinux@lists.fedoraproject.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 11:18 AM, Mark Leeds <markleeds2@gmail.com> wrote:
> Hello all: I'm a total newbie with the kernel and I've never used this
> list before so excuse me if this is not the correct place to ask this
> question. or if I don't follow the positing directions correctly.
>
> I am running fedora 14.0 and when I do uname - a, I get
>
> Linux localhost.local 2.6.35.10-74.fc14.i686 #1 SMP Thu Dec 23
> 16:17:40 UTC 2010 i686 i686 i386 GNU/Linux
> :/home/markleeds/rpmbuild#
>
> But today I've been trying to run an R  job ( see www.r-project.org
> for details about R )  in the background and
> it just dies without any error messages. well, it does in the sense
> that the operating system hangs and I need to
> shut down the computer by pulling the plug out and putting it back in.
> There's no other way as far as
> I can tell because the computer just freezes essentially.

I'd say you have 2 separate problems.  The first is this problem.  If
your box really is locking up hard like this it's almost certainly
unrelated to the later SELinux denial.  Can we try to see if the
kernel is outputting any kind of traceback or error information?
There are a couple of ways to do this.  Boot into runlevel 3,
reproduce your problem, see if any kernel messages are printed on the
screen.  Set up a remote serial console and capture the console that
way.  Set up netconsole and capture the console that way.  I'd like to
know why the box locked up hard and if it's a kernel problem it
usually gives some indication on the console.

> Then I was poking around to see if I could find any info I went into
> the selinux troubleshooter.
>
> there is a red dot and two yellow dots below it. each says something.
>
> next to the red dot:  "if you do not think /usr/lib/R/bin/exec/R
> should need to map low
> memory in the kernel"

I'm betting this is an unrelated problem and likely something the R
code is doing which is generally seen as a bad idea.  I've cc'd the
fedora selinux list to help with this issue (might I suggest people
responding to this part of the issue drop lkml and people responding
to the hard lockup drop the fedora-selinux-list?)  Might you be
willing to include the output of ausearch -m AVC in a message to the
fedora selinux list?

You can make sure that SELinux is not the cause of your hard lockup by
running (as root) "setenforce 0" before you reproduce the issue.  If
you are still able to make the box lock up this is definitely not
related to SELinux.

Hope we can help!
-Eric
