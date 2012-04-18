Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2DRDQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 23:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab2DRDQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 23:16:06 -0400
Date: Tue, 17 Apr 2012 23:15:57 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
Message-ID: <20120418031557.GA29828@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120417172142.GA30237@redhat.com>
 <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
 <20120417203223.GA31699@redhat.com>
 <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
 <20120418022705.GA23877@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418022705.GA23877@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 10:27:05PM -0400, Steven Rostedt wrote:

 > Note we have something that checks the stack, even on leaf functions.
 > 
 > Enable CONFIG_STACK_TRACER
 > 
 > and then enable it with the following:
 > 
 > # echo 1 > /proc/sys/kernel/stack_tracer_enabled
 > # cat /sys/kernel/debug/tracing/stack_trace
 >         Depth    Size   Location    (40 entries)
 >         -----    ----   --------
 >   0)     3056     208   select_task_rq_fair+0x30b/0x8b2
 >   1)     2848      96   try_to_wake_up+0xc7/0x30e

That looks handy. Doesn't seem to work for me though on my test box.
(config option is enabled.)

# echo 1 > /proc/sys/kernel/stack_tracer_enabled
# cat /sys/kernel/debug/tracing/stack_trace
        Depth    Size   Location    (-1 entries)
        -----    ----   --------

That's all she wrote.

	Dave
