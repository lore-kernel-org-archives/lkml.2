Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2H2QYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:24:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37301 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab2H2QYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:24:50 -0400
Message-ID: <503E424E.6080606@gmail.com>
Date: Wed, 29 Aug 2012 10:24:46 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 05/13] perf tools: fix ALIGN redefinition in system headers
References: <CANg8OWLpEOgWyqdzki-VensP0aKqAgYmJ68qUzZQrsX4tiFT1Q@mail.gmail.com>
In-Reply-To: <CANg8OWLpEOgWyqdzki-VensP0aKqAgYmJ68qUzZQrsX4tiFT1Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/12 4:02 PM, Irina Tirdea wrote:
> On some systems (e.g. Android), ALIGN is defined in
> system headers as ALIGN(p). The definition of ALIGN used
> in perf takes 2 parameters: ALIGN(x,a). This leads to
> redefinition conflicts.
>
> Redefinition error on Android:
> In file included from util/include/linux/list.h:1:0,
> from util/callchain.h:5,
> from util/hist.h:6,
> from util/session.h:4,
> from util/build-id.h:4,
> from util/annotate.c:11:
> util/include/linux/kernel.h:11:0: error: "ALIGN" redefined [-Werror]
> bionic/libc/include/sys/param.h:38:0: note: this is the location of
> the previous definition
>

Simpler to undef ALIGN in util/include/linux/kernel.h right before the 
perf version is declared.

David

