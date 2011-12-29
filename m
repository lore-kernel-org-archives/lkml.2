Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1L2PnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 10:43:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51983 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1L2PnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 10:43:12 -0500
MIME-Version: 1.0
In-Reply-To: <CALZhoSRVNp=Sj2u2GHiQhuHOEdrfiM58KzG+RutvJV=8CoCpTQ@mail.gmail.com>
References: <CALZhoSRVNp=Sj2u2GHiQhuHOEdrfiM58KzG+RutvJV=8CoCpTQ@mail.gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Thu, 29 Dec 2011 21:12:28 +0530
X-Google-Sender-Auth: SpoPDQ6mWf1dPGMu2oAQKiAYJdA
Message-ID: <CAH+eYFDb4r235jAGjr7j5R5C+9YK9WeXXjVZGWQUB=330sOi0Q@mail.gmail.com>
Subject: Re: ftrace performance impact with different configuration
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, leiwen@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 14:08, Lei Wen <adrian.wenl@gmail.com> wrote:
> 2. Seem dynamic ftrace also could involve some penalty for the running
> system, although it patching the running kernel with nop stub...
>
> For the second item, is there anyone done some research before that
> could zero the cost for the running system when the tracing is not
> enabled yet?

One thing that needs to be fixed (for ARM) is that for the new-style
mcounts, the nop that's currently being done is not really a nop -- it
removes the function call, but there is still an unnecessary push/pop
sequence.  This should be modified to have the push {lr} removed too.
(Two instructions replaced instead of one.)
