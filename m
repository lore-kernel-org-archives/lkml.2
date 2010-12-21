Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570Ab0LUE23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 23:28:29 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:61419 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461Ab0LUE22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 23:28:28 -0500
Date: Mon, 20 Dec 2010 23:28:03 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <htejun@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: acpi throttling: Use this_cpu_has and simplify code
In-reply-to: <alpine.DEB.2.00.1012161215200.21588@router.home>
Message-id: <alpine.LFD.2.00.1012202318400.4383@x980>
References: <20101214162842.542421046@linux.com>
 <20101214162855.392020353@linux.com>
 <1292345072.5934.32.camel@edumazet-laptop>
 <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com>
 <alpine.DEB.2.00.1012141109470.17229@router.home> <4D07A7CB.7010205@zytor.com>
 <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com>
 <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com>
 <4D08EF4E.8070403@kernel.org> <4D0A3AF2.50508@gmail.com>
 <alpine.DEB.2.00.1012161215200.21588@router.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a valid cleanup, and I've applied it to the acpi-test tree.

The routines named *rdmsr() and *wrmsr() run on the local CPU
by definition.  I think that after this change to get rid of pr*,
that is even more clear.

The part about checking that you are on the right processor
should really be done in the caller.  Yakui should send a patch
for the driver to check for successful return from
set_cpus_allowed_ptr() before invoking this code.

> With the this_cpu_xx we no longer need to pass an acpi
> structure to the msr management code. Simplifies code and improves
> performance.

Simplifies, yes.
Performance -- not the focus here.
If you are running routines to throttle the clock frequency,
then you have already decided that performance isn't your top priority:-)

thanks,
Len Brown, Intel Open Source Technology Center

> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  drivers/acpi/processor_throttling.c |   32 ++++++++++----------------------
>  1 file changed, 10 insertions(+), 22 deletions(-)

