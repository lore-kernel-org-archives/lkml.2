Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0LCNAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:00:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:53031 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab0LCNAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:00:44 -0500
Subject: Re: [PATCH -tip  6/7] perf bts trace: print function+offset
From: Peter Zijlstra <peterz@infradead.org>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <20101203040015.7827.38870.stgit@localhost6.localdomain6>
References: <20101203035832.7827.16528.stgit@localhost6.localdomain6>
	 <20101203040015.7827.38870.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Dec 2010 14:00:58 +0100
Message-ID: <1291381258.32004.2083.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 13:00 +0900, Akihiro Nagai wrote:
> Provide the function to print function+offset.
> And, set it as the default behavior of 'perf bts trace'.
> To use this function, users can also specify the option '-s' or '--symbol'.
> 
> Example: 'perf bts -as trace'
> This command prints address and function+offset.
> 
> Output sample:
> address            function+offset
> 0xffffffff8146fe0e irq_return+0x0         => 0x00007fd4038e3b20 _start+0x0
> ...
> 0x000000380661ee79 __libc_start_main+0xf9 => 0x00000000004035c3 main+0x0
> 0xffffffff8146ef4e irq_return+0x0         => 0x00000000004035c3 main+0x0
> 0x00000000004035e8 main+0x25              => 0x000000000040bca0 set_program_name+0x0
> 0xffffffff8146ef4e irq_return+0x0         => 0x000000000040bca0 set_program_name+0x0
> 0x000000000040bcae set_program_name+0xe   => 0x00000000004023d0 strrchr@plt+0x0
> 0x00000000004023d0 strrchr@plt+0x0        => 0x00000000004023d6 strrchr@plt+0x6
> ...
> 0x0000000000403e0c main+0x849             => 0x00000000004021f0 exit@plt+0x0
> 0x00000000004021f0 exit@plt+0x0           => 0x00000000004021f6 exit@plt+0x6
> 0x00000000004021fb exit@plt+0xb           => 0x00000000004020d0 _init+0x18
> 0x00000000004020d6 _init+0x1e             => 0x00000038062149d0 _dl_runtime_resolve+0x0


What would be very nice output is something like a source-code browser
(tig might have something worth borrowing) and annotating the output
using the bts output.

You could for example darken the code that didn't get any coverage, and
print a percentage for each conditional statement.

That way you can easily see how your code is traversed.
