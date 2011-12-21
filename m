Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab1LURxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:53:38 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:51702
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598Ab1LURxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:53:36 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LWKF14-01-J1H-02
X-M-MSG: 
Date: Wed, 21 Dec 2011 18:53:26 +0100
From: Robert Richter <robert.richter@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: oprofile patch broke s390 build in tip/perf/core
Message-ID: <20111221175326.GM16765@erda.amd.com>
References: <1324488646.5916.107.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1324488646.5916.107.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.12.11 12:30:46, Steven Rostedt wrote:
> In doing my tests last night before sending out my patch series this
> morning, I found that s390 build didn't work, but it wasn't due to my
> patches. I removed all my patches and built with latest mainline (which
> builds fine), and then merged the current tip/perf/core. The result
> didn't build.
> 
> I kicked off a ktest git bisect with last night's Linus tree as good,
> and with the merged in tip/perf/core as bad. It ended up with this patch
> that broke the build (which looks like a likely suspect).
> 
> 
> The break is this:
> 
>   LD      .tmp_vmlinux1
> arch/s390/oprofile/built-in.o: In function `oprofile_arch_exit':
> (.text+0x3f52): undefined reference to `oprofile_timer_exit'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2

A fix is already in tip/perf/core:

 f8c8520 oprofile: Fix oprofile_timer_exit() breakage

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

