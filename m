Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2H2QTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:19:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39764 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2H2QTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:19:46 -0400
Message-ID: <503E411D.2040406@gmail.com>
Date: Wed, 29 Aug 2012 10:19:41 -0600
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
Subject: Re: [PATCH 03/13] perf tools: drop asm/byteorder.h wrapper
References: <CANg8OWJTKWnk=qx+rud3ypdbNFr=-B2Tp_j5_Ud-Z6S4vd_rwg@mail.gmail.com>
In-Reply-To: <CANg8OWJTKWnk=qx+rud3ypdbNFr=-B2Tp_j5_Ud-Z6S4vd_rwg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/12 3:59 PM, Irina Tirdea wrote:
> Wrapping asm/byteorder.h will also replace the glibc header,
> not only the kernel one. asm/byteorder.h further includes
> architecture dependent headers that define endianess.
>
> Some systems (e.g. Android) need constant definitions that
> depend on endianess (e.g. __constant_htonl).
>
> In file included from bionic/libc/include/netinet/tcp.h:32:0,
>                   from kernel/intel/tools/perf/util/util.h:74,
>                   from kernel/intel/tools/perf/util/cache.h:5,
>                   from kernel/intel/tools/perf/util/abspath.c:1:
> bionic/libc/kernel/common/linux/tcp.h:61:2:
> error: enumerator value for 'TCP_FLAG_CWR' is not an integer constant
> bionic/libc/kernel/common/linux/tcp.h:62:2:
> error: enumerator value for 'TCP_FLAG_ECE' is not an integer constant
> bionic/libc/kernel/common/linux/tcp.h:63:2:
> error: enumerator value for 'TCP_FLAG_URG' is not an integer constant
> bionic/libc/kernel/common/linux/tcp.h:64:2:
> error: enumerator value for 'TCP_FLAG_ACK' is not an integer constant
> bionic/libc/kernel/common/linux/tcp.h:65:2:
> error: enumerator value for 'TCP_FLAG_PSH' is not an integer constant
> bionic/libc/kernel/common/linux/tcp.h:66:2:
> error: enumerator value for 'TCP_FLAG_RST' is not an integer constant
> bionic/libc/kernel/common/linux/tcp.h:67:2:
> error: enumerator value for 'TCP_FLAG_SYN' is not an integer constant
> bionic/libc/kernel/common/linux/tcp.h:68:2:
> error: enumerator value for 'TCP_FLAG_FIN' is not an integer constant
> bionic/libc/kernel/common/linux/tcp.h:69:2:
> error: enumerator value for 'TCP_RESERVED_BITS' is not an integer constant
> bionic/libc/kernel/common/linux/tcp.h:71:1:
> error: enumerator value for 'TCP_DATA_OFFSET' is not an integer constant


This https://lkml.org/lkml/2012/8/29/150 should fix the netinet/tcp.h 
build problem.

David

