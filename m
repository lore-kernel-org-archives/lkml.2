Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1GVXIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 19:08:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669Ab1GVXIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 19:08:34 -0400
Date: Fri, 22 Jul 2011 16:08:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: morten@winkler.dk
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>
Subject: Re: Possible bug in inotify api
Message-Id: <20110722160832.ee535e0c.akpm@linux-foundation.org>
In-Reply-To: <c2b2191a22eab7f6127d5ea1d519bee1.squirrel@webmail01.one.com>
References: <c2b2191a22eab7f6127d5ea1d519bee1.squirrel@webmail01.one.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 08:47:44 +0200
Morten Winkler J__rgensen <morten@winkler.dk> wrote:

> To whom it might concern
> 
> I'd like to report a possible malfunction of the inotify api and check if
> this issue has been reported.
> If this is not the proper place to do so, please let me know. I have
> searched the archives and the web and found similar reportings but none
> the same.
> 
> The observed behavior is when calling inotify_remove_watch. Now and then
> it returns error 22, INVALID_ARGUMENT, even though the watchdesriptor
> ought to be valid. I've seen that people complain about this behavior on
> the dovecot mailing list but nobody seems to have suggested a fix.
> 
> I've attached a small program that I use to reproduce the behavior.
> The program watches /tmp and whenever it's notified about a directory
> created in /tmp, my program adds a watch for that directory as well.
> 
> The program is a C++ program (as I will need the inotify functionality in
> a C++ program, but the behavior is the same in a pure C implementation)
> and to reproduce I do the following:
> 
> * g++ main.cpp
> * ./a.out
> 
> In a shell I go to /tmp and run
> * for i in `seq 1 5000`; do mkdir D-$i; done; for i in `seq 1 5000`; do
> rmdir D-$i; done
> 
> This makes my testprogram output the wd's created and and the wd's my
> program tries to remove. I've never seen the program successfully remove
> all 5000 watch descriptors and I've seen inotify_rm_watch fail after 0
> removes and after approx 2000 removes and anything in between.
> 
> I'm running kernel 2.6.23-5 from the Debian repositories.
> 
> If what I've written is totally nonsense, if it is expected behavior or if
> I've done anything wrong, please let me know. Also, if I can do anything
> further to investigate the misbehavior also, please let me know.
> 
> Best and thanks in advance,
>    Morten
> 
> Attached: C++ program used to reproduce the behavior.

I ran it a couple of times on my 2.6.32-based 2-CPU desktop here and it
ran to completion without any complaints.

So perhaps we fixed whatever-it-was in a later kernel.  2.6.23 is
pretty old!
