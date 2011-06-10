Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1FJLut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 07:50:49 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45217 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab1FJLus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 07:50:48 -0400
X-AuditID: b753bd60-a1ec5ba000003bac-bf-4df205147ef6
X-AuditID: b753bd60-a1ec5ba000003bac-bf-4df205147ef6
Message-ID: <4DF20511.8000206@hitachi.com>
Date: Fri, 10 Jun 2011 20:50:41 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH v4 3.0-rc2-tip 20/22] 20: perf: perf interface for uprobes
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6> <20110607130216.28590.5724.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110607130216.28590.5724.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/07 22:02), Srikar Dronamraju wrote:
> Enhances perf probe to user space executables and libraries.
> Provides very basic support for uprobes.
> 
> [ Probing a function in the executable using function name  ]
> -------------------------------------------------------------
> [root@localhost ~]# perf probe -u zfree@/bin/zsh

Hmm, here, I have concern about the interface inconsistency
of the probe point syntax.

Since perf probe already supports debuginfo analysis,
it accepts following syntax;

[EVENT=]FUNC[@SRC][:RLN|+OFFS|%return|;PTN] [ARG ...]

Thus, The "@" should take a source file path, not binary path.

I think -u option should have a path of the target binary, as below

# perf probe -u /bin/zsh -a zfree

This will allow perf-probe to support user-space debuginfo
analysis. With it, we can do as below;

# perf probe -u /bin/zsh -a zfree@foo/bar.c:10

Please try to update tools/perf/Documentation/perf-probe.txt too,
then you'll see how the new syntax is different from current one :)

Thanks,



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
