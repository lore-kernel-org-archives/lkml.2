Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1C2W6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:58:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197Ab1C2W6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:58:09 -0400
Date: Tue, 29 Mar 2011 15:57:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH v2 typo-fixed] initcall: add config option for compiling
 initcall_debug
Message-Id: <20110329155751.e7ba346a.akpm@linux-foundation.org>
In-Reply-To: <20110328075131.25063.93957.stgit@localhost6>
References: <20110327115506.14008.17733.stgit@localhost6>
	<20110328075131.25063.93957.stgit@localhost6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 11:51:31 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> This patch adds bool config option CONFIG_INITCALL_DEBUG for
> compiling initcalls debuging, it on by default to keep current behaviour.
> 
> With CONFIG_INITCALL_DEBUG=n bloat-o-meter shows:
> 
> add/remove: 0/7 grow/shrink: 3/10 up/down: 88/-1448 (-1360)
> function                                     old     new   delta
> device_resume                                350     404     +54
> __device_suspend                             331     363     +32
> device_resume_noirq                          230     232      +2
> kernel_init                                  355     354      -1
> initcall_debug                                 4       -      -4
> __param_str_initcall_debug                    15       -     -15
> dpm_suspend                                  431     415     -16
> syscore_suspend                              280     250     -30
> syscore_shutdown                             123      93     -30
> __param_initcall_debug                        32       -     -32
> syscore_resume                               215     173     -42
> static.initcall_debug_start                   71       -     -71
> static.initcall_debug_report                 102       -    -102
> legacy_resume                                129       -    -129
> async_synchronize_cookie_domain              286     152    -134
> legacy_suspend                               135       -    -135
> async_run_entry_fn                           348     188    -160
> do_one_initcall                              364     197    -167
> pm_op                                        536     366    -170
> pm_noirq_op                                  576     366    -210

Well.  One hopes that most things which use initcall_debug are
marked __init or __initdata.

I see that async and pm have borrowed inticall_debug for reasonably
appropriate reasons, but I wonder if all that is permanent code, or if
it will later get removed.  Because if it gets removed, this patch
becomes rather pointless.

And the async code didn't try very hard anyway - it has a bunch of code
wired into .text which is only used at boot time.

