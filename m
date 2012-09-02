Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2IBUUk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 16:20:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59548 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2IBUUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 16:20:39 -0400
MIME-Version: 1.0
In-Reply-To: <503E424E.6080606@gmail.com>
References: <CANg8OWLpEOgWyqdzki-VensP0aKqAgYmJ68qUzZQrsX4tiFT1Q@mail.gmail.com>
 <503E424E.6080606@gmail.com>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Sun, 2 Sep 2012 23:20:18 +0300
Message-ID: <CANg8OWLAaJD54-5c+3B42MNy8h6n=mZnHcmSp0Q3Y2Jft-ezAA@mail.gmail.com>
Subject: Re: [PATCH 05/13] perf tools: fix ALIGN redefinition in system headers
To: David Ahern <dsahern@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Simpler to undef ALIGN in util/include/linux/kernel.h right before the perf
> version is declared.

This was actually my initial approach as well. The problem is that
just to undef ALIGN before it is defined in perf is not enough.
Somehow the bionic version overrides the perf definition even if I use
undef. A solution would be to move the entire block of #undef and
#define ALIGN at the beginning of util/include/linux/kernel.h, before
the header's #ifndef PERF_LINUX_KERNEL_H_ define. I thought that
renaming the ALIGN in perf is cleaner than having defines outside the
include guards.

Irina
