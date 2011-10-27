Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1J0Czf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 22:55:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42297 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1J0Cze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 22:55:34 -0400
Date: Thu, 27 Oct 2011 10:55:24 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [3.1] lockdep scheduling while atomic on boot
Message-ID: <20111027025524.GA7819@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20111027000609.GE2742@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111027000609.GE2742@hostway.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 05:06:09PM -0700, Simon Kirby wrote:
> We were messing with initrd stuff to get root on MD to work with newer
> than original MD superblock versions (grumble), and threw a lockdep
> kernel on, which spat out the following during boot:
> 
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.1.0-hw-lockdep+ (root@packages01-dev) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #54 SMP Wed Oct 26 14:25:58 CDT 2011
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.1.0-hw-lockdep+ root=UUID=5c132cc5-ec54-4155-aa8d-ab1834b58eee ro quiet
> ...
> [    0.004146] Mount-cache hash table entries: 256
> [    0.004999] Initializing cgroup subsys blkio
> [    0.005087] CPU: Physical Processor ID: 0
> [    0.005090] CPU: Processor Core ID: 0
> [    0.005092] mce: CPU supports 6 MCE banks
> [    0.005099] CPU0: Thermal monitoring enabled (TM1)
> [    0.005104] using mwait in idle threads.
> [    0.009021] ACPI: Core revision 20110623
> [    0.009157] BUG: scheduling while atomic: swapper/0/0x10000002
> [    0.009217] no locks held by swapper/0.
> [    0.009219] Modules linked in:
> [    0.009223] Pid: 0, comm: swapper Not tainted 3.1.0-hw-lockdep+ #54
> [    0.009225] Call Trace:
> [    0.009234]  [<ffffffff81051475>] __schedule_bug+0x85/0x90
> [    0.009240]  [<ffffffff816f5305>] __schedule+0x795/0xa20
> [    0.009245]  [<ffffffff81096c3d>] ? trace_hardirqs_on_caller+0x13d/0x1c0
> [    0.009250]  [<ffffffff81126a89>] ? kmem_cache_free+0x159/0x190
> [    0.009254]  [<ffffffff813da692>] ? acpi_os_release_object+0x9/0xd
> [    0.009258]  [<ffffffff81096c3d>] ? trace_hardirqs_on_caller+0x13d/0x1c0
> [    0.009261]  [<ffffffff81096ccd>] ? trace_hardirqs_on+0xd/0x10
> [    0.009265]  [<ffffffff813da692>] ? acpi_os_release_object+0x9/0xd
> [    0.009269]  [<ffffffff813f8340>] ? acpi_ps_free_op+0x22/0x24
> [    0.009273]  [<ffffffff81059335>] __cond_resched+0x25/0x40
> [    0.009277]  [<ffffffff816f561d>] _cond_resched+0x2d/0x40
> [    0.009280]  [<ffffffff813f75e8>] acpi_ps_complete_op+0x258/0x26e

IIRC, Frederic has patch for it, Frederic?
