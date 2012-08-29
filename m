Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2H2QSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:18:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40972 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2H2QSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:18:13 -0400
Message-ID: <503E40BF.8090905@gmail.com>
Date: Wed, 29 Aug 2012 10:18:07 -0600
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
Subject: Re: [PATCH 02/13] perf tools: update types definitions for Android
References: <CANg8OWJnDvd28KTZffojhxLds4znjTTq294=H-_frbX6dStaWw@mail.gmail.com>
In-Reply-To: <CANg8OWJnDvd28KTZffojhxLds4znjTTq294=H-_frbX6dStaWw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/12 4:33 PM, Irina Tirdea wrote:
> Some systems (e.g. Android) define in their libc types.h
> __le16, __be16, etc. Since perf is wrapping
> <linux/types.h> with a local version, we need to define this
> constants in the local version too.
>
> Errors in Android:
> In file included from bionic/libc/include/netinet/in.h:34:0,
>                   from util/util.h:73,
>                   from util/cache.h:5,
>                   from util/abspath.c:1:
> bionic/libc/kernel/common/linux/in6.h:20:2: error: unknown type name '__be16'
> bionic/libc/kernel/common/linux/in6.h:21:2: error: unknown type name '__be32'
> bionic/libc/kernel/common/linux/in6.h:30:2: error: unknown type name '__be16'
> bionic/libc/kernel/common/linux/in6.h:31:2: error: unknown type name '__be32'
> bionic/libc/kernel/common/linux/in6.h:47:2: error: unknown type name '__be32'

This https://lkml.org/lkml/2012/8/29/150 should fix the netinet/in.h 
build problem.

David
