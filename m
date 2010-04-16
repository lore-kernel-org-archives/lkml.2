Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab0DPAdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 20:33:11 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:42185 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758185Ab0DPAdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 20:33:09 -0400
Date: Thu, 15 Apr 2010 19:27:42 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: useless node/has_cpu sysfs attribute
In-Reply-To: <20100415061200.GC21517@alberich.amd.com>
Message-ID: <alpine.DEB.2.00.1004151917420.17800@router.home>
References: <20100415061200.GC21517@alberich.amd.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010, Andreas Herrmann wrote:

> commit 99dcc3e5a94ed491fbef402831d8c0bbb267f995 (this_cpu: Page
> allocator conversion) removed the call
>
>     node_set_state(node, N_CPU);    /* this node has a cpu */

This was moved to vmstat_cpuup_callback. See mm/vmstat.c. Maybe it needs
to be  added to setup_vmstat() as well.

> Thus the sysfs attribute /sys/devices/system/node/has_cpu doesn't
> show anything anymore.

Thats strange. Why is the cpuup notifier not executing?

> This attribute never reflected any changes triggered by CPU hotplug.

Duh some breakage in the cpuup notifier handling?

This needs to be fixed.
