Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab2EHDIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 23:08:18 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58793 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017Ab2EHDIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 23:08:17 -0400
X-AuditID: b753bd60-a2688ba000000655-40-4fa88e1ec79c
X-AuditID: b753bd60-a2688ba000000655-40-4fa88e1ec79c
Message-ID: <4FA88E1B.1020708@hitachi.com>
Date: Tue, 08 May 2012 12:08:11 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: Re: [PATCH 6/9][RFC] kprobes: Allow probe on ftrace reserved
 text (but move it)
References: <20120502192418.024103772@goodmis.org>   <20120502193237.321234712@goodmis.org> <y0mhavyl3kg.fsf@fche.csb>  <1336002032.14207.52.camel@gandalf.stny.rr.com>  <4FA7B410.1000804@hitachi.com> <1336394603.14207.117.camel@gandalf.stny.rr.com>
In-Reply-To: <1336394603.14207.117.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/07 21:43), Steven Rostedt wrote:
> On Mon, 2012-05-07 at 20:37 +0900, Masami Hiramatsu wrote:
> 
>> By the way, there is another way to do that transparently which
>> we add a "real_addr" member to struct kprobes and put the real
>> probed address to the member (without changing kp->addr). This
>> will keep API compatibility.
> 
> I like this a lot. Perhaps we don't need a flag at all, and just use
> these two addrs instead?

Yes, just replacing all "*p->addr" and "kp.addr" with real_addr
and copying addr to real_addr when registering. That's the basic
idea.

I just concern about the cost balance... this is feasible, but
we need to change many arch-dependent parts. Do we really need to
pay that cost just for the backward compatibility?

I mean, the kprobes itself can be changed because we don't ensure
the stability of kernel APIs. If so, it looks enough to change the
behavior of kprobes and give an upgrade hint for users (current patch),
isn't it?

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
