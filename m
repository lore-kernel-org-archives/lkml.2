Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab1DOVua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:50:30 -0400
Received: from legolas.restena.lu ([158.64.1.34]:33082 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab1DOVu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:50:28 -0400
Date: Fri, 15 Apr 2011 23:50:15 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: wzab@ise.pw.edu.pl
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: i915 drm GPU hung errors with kernel 2.6.38.2 on  82865G
 chipset
Message-ID: <20110415235015.1e315688@neptune.home>
In-Reply-To: <4DA8B3A7.3010807@ise.pw.edu.pl>
References: <4DA8B3A7.3010807@ise.pw.edu.pl>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wojtek,

Your best chance to see the bugs fixed is to report a bug following
guidelines at http://intellinuxgraphics.org/how_to_report_bug.html

For GPU hangs, collecting the error state (while GPU is hung) under
debugfs is very helpful.
Report contents of (as well as details on your software stack and
if know what kind of action triggered the hung):
  /sys/kernel/debug/dri/0/i915_error_state

Also you should CC intel-gfx@lists.freedesktop.org and Chris Wilson
<chris@chris-wilson.co.uk> for all issues regarding intel GPUs as
thats the place it has better chance of being seen by someone who
can help out. (intel-gfx is subscribers-only but at least part of the
thread would reach it)

Regards,
Bruno


On Fri, 15 April 2011 wzab <wzab@ise.pw.edu.pl> wrote:
> Today I have experienced two "GPU hungs" on machine with 82865G chipset 
> working with 2.6.38.2 kernel
> In the /var/log/syslog I have found the following errors:
> 
> Apr 15 22:50:51 wzab kernel: [drm:i915_hangcheck_elapsed] *ERROR* 
> Hangcheck timer elapsed... GPU hung
> Apr 15 22:50:51 wzab kernel: [drm:i915_do_wait_request] *ERROR* 
> i915_do_wait_request returns -11 (awaiting 1352947 at 1352942, next 1352948)
> Apr 15 22:50:51 wzab kernel: [drm:init_ring_common] *ERROR* failed to 
> set render ring head to zero ctl 00000000 head 3280a54c tail 00000000 
> start 00000000
> Apr 15 22:50:51 wzab kernel: [drm:init_ring_common] *ERROR* render ring 
> initialization failed ctl 0001f003 head 3280a54c tail 00000000 start 
> 00000000
> Apr 15 22:50:52 wzab kernel: [drm:i915_hangcheck_elapsed] *ERROR* 
> Hangcheck timer elapsed... GPU hung
> Apr 15 22:50:52 wzab kernel: [drm:i915_do_wait_request] *ERROR* 
> i915_do_wait_request returns -11 (awaiting 1353049 at 1352942, next 1353050)
> 
> After reboot:
> 
> Apr 15 22:56:41 wzab kernel: [drm:i915_hangcheck_elapsed] *ERROR* 
> Hangcheck timer elapsed... GPU hung
> Apr 15 22:56:41 wzab kernel: [drm:i915_do_wait_request] *ERROR* 
> i915_do_wait_request returns -11 (awaiting 29134 at 29129, next 29135)
> 
