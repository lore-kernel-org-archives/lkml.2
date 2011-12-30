Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1L3XcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 18:32:01 -0500
Received: from smtp4.epfl.ch ([128.178.224.218]:43528 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752080Ab1L3XcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 18:32:00 -0500
From: Philippe =?ISO-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        leiwen@marvell.com, Lei Wen <adrian.wenl@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: ftrace performance impact with different configuration
Date: Sat, 31 Dec 2011 00:31:55 +0100
Message-ID: <2631878.q7bjHk7YBM@laptop>
Organization: EPFL - STI - LSRO1
User-Agent: KMail/4.7.4 (Linux/3.1.6-1.fc16.x86_64; KDE/4.7.4; x86_64; ; )
In-Reply-To: <1325283941.24045.15.camel@gandalf.stny.rr.com>
References: <CALZhoSRVNp=Sj2u2GHiQhuHOEdrfiM58KzG+RutvJV=8CoCpTQ@mail.gmail.com> <23257775.9kkYY4quUh@laptop> <1325283941.24045.15.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 30 décembre 2011 17:25:41 Steven Rostedt a écrit :
> On Fri, 2011-12-30 at 14:07 +0100, Philippe Rétornaz wrote:
> > Sorry about being a bit naive, but why it is not possible to do it in
> > two
> > steps ?
> > call stop_machine to put the jmp which skip the call to mcount
> > Then wait until all tasks hits schedule() (synchronize_sched() ?)
> (...)
> There's no way to safely modify two instructions that depend on each
> other in a preemptible kernel, with the exception of waiting for all
> CPUs to hit idle (which may never happen on a busy system). And even
> that may be racy.
> 

Thanks for the detailed explanation, I got it now. I guess the only way would 
be to use the freezer api like freeze_processes() is doing. Looks like it does 
not worth the pain.

Thanks ! 

Philippe

