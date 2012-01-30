Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab2A3Jfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 04:35:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:59352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2A3Jfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 04:35:52 -0500
Message-ID: <1327916138.2446.187.camel@twins>
Subject: Re: [PATCH -tip v5 2/5] perf: set correct value to
 perf_event_header.misc for BTS
From: Peter Zijlstra <peterz@infradead.org>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Date: Mon, 30 Jan 2012 10:35:38 +0100
In-Reply-To: <20120130044303.2384.63515.stgit@linux3>
References: <20120130044242.2384.23076.stgit@linux3>
	 <20120130044303.2384.63515.stgit@linux3>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 13:43 +0900, Akihiro Nagai wrote:
> @@ -330,6 +342,14 @@ int intel_pmu_drain_bts_buffer(void)
>                 return 1;
>  
>         for (; at < top; at++) {
> +               /*
> +                * To resolve user space symbols and DSOs correctly, set
> +                * PERF_RECORD_MISC_USER if from_addr or to_addr is user space.
> +                */
> +               if (!kernel_ip(data.ip) || !kernel_ip(data.addr)) {
> +                       header.misc &= ~PERF_RECORD_MISC_CPUMODE_MASK;
> +                       header.misc |= PERF_RECORD_MISC_USER;
> +               }
>                 data.ip         = at->from;
>                 data.addr       = at->to; 

Why not key off of the from? If its a jump from userspace its a user
event, its a jump from kernel space its a kernel event?
