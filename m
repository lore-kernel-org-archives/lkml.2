Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2FEPv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:51:56 -0400
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:40213 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753649Ab2FEPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:51:53 -0400
MIME-Version: 1.0
In-Reply-To: <4FCE25C6.2080601@gmail.com>
References: <4FCE25C6.2080601@gmail.com>
From: Roland Dreier <roland@purestorage.com>
Date: Tue, 5 Jun 2012 08:51:31 -0700
Message-ID: <CAL1RGDWjA8uh3924s4+F=zD3EJpUXk6auJpi=zPWJRE4sY8FCw@mail.gmail.com>
Subject: Re: git bisect and perf
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 8:29 AM, David Ahern <dsahern@gmail.com> wrote:
> # git bisect good v2.6.38
> Some good revs are not ancestor of the bad rev.
> git bisect cannot work properly in this case.
> Maybe you mistake good and bad revs?

git bisect is telling you what is wrong -- as the man page says:

    This command uses git rev-list --bisect to help drive the binary
    search process to find which change introduced a bug, given an old
    "good" commit object name and a later "bad" commit object name.

so it assumes the good commit is older than the bad commit.

You can actually use git bisect in your case, although it gets very confusing
unless you write yourself a little wrapper alias: just swap the meaning of
good and bad, ie do

# git bisect start arch/x86/kernel/cpu/perf_event*
# git bisect good v2.6.35
# git bisect bad v2.6.38

and try somehow to remember that when you do a test, "bad" means
PEBS works and "good" means PEBS doesn't work.

 - R.
