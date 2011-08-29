Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1H2XFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:05:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab1H2XFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:05:48 -0400
Date: Mon, 29 Aug 2011 16:02:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH v3] proc: fix races against execve() of /proc/PID/fd**
Message-Id: <20110829160210.f0f2ce99.akpm@linux-foundation.org>
In-Reply-To: <20110829180011.GA8839@albatros>
References: <20110804162009.GA2469@albatros>
	<20110823144430.75315ce8.akpm@linux-foundation.org>
	<20110826132909.GA8266@albatros>
	<20110826124021.15f8e20c.akpm@linux-foundation.org>
	<20110827190147.GA3015@albatros>
	<20110828092520.GA8537@sun>
	<20110828093156.GA6291@albatros>
	<20110829180011.GA8839@albatros>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 22:00:11 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> Used existing (un)lock_trace functions to check for ptrace_may_access(),
> but instead of using EPERM return code from it use EACCES to be
> consistent with existing proc_pid_follow_link()/proc_pid_readlink()
> return code.  If they differ, attacker can guess what fds exist by
> analyzing stat() return code.

doh, I missed that bit.  Fair enough.
