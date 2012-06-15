Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab2FODCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:02:51 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43568 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2FODCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:02:50 -0400
X-AuditID: b753bd60-9a0f2ba000000f6c-f2-4fdaa5d77bfc
X-AuditID: b753bd60-9a0f2ba000000f6c-f2-4fdaa5d77bfc
Message-ID: <4FDAA5D5.7080606@hitachi.com>
Date: Fri, 15 Jun 2012 12:02:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 02/13 v2] ftrace: Consolidate arch dependent functions
 with list function
References: <20120612224327.426900129@goodmis.org> <20120612225424.495625483@goodmis.org>
In-Reply-To: <20120612225424.495625483@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 7:43), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> As the function tracer starts to get more features, the support for
> theses features will spread out throughout the different architectures
> over time. These features boil down to what each arch does in the
> mcount trampoline (the ftrace_caller).
> 
> Currently there's two features that are not the same throughout the
> archs.
> 
>  1) Support to stop function tracing before the callback
>  2) passing of the ftrace ops
> 
> Both of these require placing an indirect function to support the
> features if the mcount trampoline does not.
> 
> On a side note, for all architectures, when more than one callback
> is registered to the function tracer, an intermediate 'list' function
> is called by the mcount trampoline to iterate through the callbacks
> that are registered.
> 
> Instead of making a separate function for each of these features,
> and requiring several indirect calls, just use the single 'list' function
> as the intermediate, to handle all cases. If an arch does not support
> the 'stop function tracing' or the passing of ftrace ops, just force
> it to use the list function that will handle the features required.

Ah, I see. so even if the arch doesn't support passing ftrace_ops in
mcount trampoline, this ensures that the correct ftrace_ops should
be passed to the handlers.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
