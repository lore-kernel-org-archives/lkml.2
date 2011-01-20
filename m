Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab1ATObR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:31:17 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33810 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab1ATObP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:31:15 -0500
X-AuditID: b753bd60-a21fbba000007012-e5-4d3847305d65
Message-ID: <4D38472D.100@hitachi.com>
Date: Thu, 20 Jan 2011 23:31:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -perf/perf/core v2 1/3] perf: Add strfilter for general
 purpose string filter
References: <20110120141530.25915.12673.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110120141530.25915.12673.stgit@ltc236.sdl.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/20 23:15), Masami Hiramatsu wrote:
> Add strfilter for general purpose string filter.
> Every filter rules are descrived by glob matching pattern
> and '!' prefix which means Logical NOT.
> A strfilter consists of those filter rules connected
> with '&' and '|'. A set of rules can be folded by using
> '(' and ')'. It also accepts spaces around rules and those
> operators.
> 
> Format:
> <rule> ::= <glob-exp> | "!" <rule> | <rule> <op> <rule> | "(" <rule> ")"
> <op> ::= "&" | "|"
> 
> e.g.
>  "(add* | del*) & *timer" filter rules pass strings which
>  start with add or del and end with timer.
> 
> This will be used by perf probe --filter.
> 
> Changes in V2:
>  - Fix to check result of strdup() and strfilter__alloc().
>  - Encapsulate and simplify interfaces as like as regex(3).

Hi Arnaldo,
Finally, I decided not to support partial node deletion, because
it's hard to modify a part of rule tree. Instead, I encapsulated
each node and simplified interfaces.

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
