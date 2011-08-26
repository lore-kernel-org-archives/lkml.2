Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1HZTlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 15:41:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098Ab1HZTlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 15:41:16 -0400
Date: Fri, 26 Aug 2011 12:40:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] proc: fix races against execve() of
 /proc/PID/{fd/,fdinfo/,fdinfo/*}
Message-Id: <20110826124021.15f8e20c.akpm@linux-foundation.org>
In-Reply-To: <20110826132909.GA8266@albatros>
References: <20110804162009.GA2469@albatros>
	<20110823144430.75315ce8.akpm@linux-foundation.org>
	<20110826132909.GA8266@albatros>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 17:29:09 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> fd* files are restricted to the task's owner, and other users may not
> get direct access to them.  But one may open any of these files and run
> any setuid program, keeping opened file descriptors.  As there are
> permission checks on open(), but not on readdir() and read(), operations
> on the kept file descriptors will not be checked.  It makes it possible
> to violate procfs permission model.
> 
> Reading fdinfo/* may disclosure current fds' position and flags, reading
> directory contents of fdinfo/ and fd/ may disclosure the number of opened
> files by the target task.  This information is not sensible per se, but
> it can reveal some private information (like length of a password stored in
> a file) under certain conditions.
> 
> Used existing (un)lock_trace functions to deal with the issue by calling
> ptrace_may_access() permission checks.

This doesn't apply to current mainline.  Please redo, retest, resend?
