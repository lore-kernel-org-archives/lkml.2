Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2FOMm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:42:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45750 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab2FOMm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:42:56 -0400
Message-ID: <1339764161.2559.63.camel@twins>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Date: Fri, 15 Jun 2012 14:42:41 +0200
In-Reply-To: <20120615123749.GC6083@aftab.osrc.amd.com>
References: <1339521203.31548.92.camel@twins>
	 <20120612171734.GI8404@aftab.osrc.amd.com>
	 <1339521493.31548.93.camel@twins>
	 <20120612172352.GA4802@aftab.osrc.amd.com>
	 <1339521996.31548.95.camel@twins>
	 <20120612173506.GB4802@aftab.osrc.amd.com>
	 <20120613010413.GA28174@khazad-dum.debian.net>
	 <20120613065119.GB15661@aftab.osrc.amd.com>
	 <20120613123649.GA26012@khazad-dum.debian.net>
	 <20120613161139.GA18450@aftab.osrc.amd.com>
	 <20120615123749.GC6083@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 14:37 +0200, Borislav Petkov wrote:
> This is a minimal fix which we'd like to see in stable too thus the
> more-or-less arbitrary decision to allow system-wide reloading only on
> the BSP:
> 
> $ echo 1 > /sys/devices/system/cpu/cpu0/microcode/reload
> ...
> 
> and disable the interface on the other cores:
> 
> $ echo 1 > /sys/devices/system/cpu/cpu23/microcode/reload
> -bash: echo: write error: Invalid argument 

One could allow the reload from all cpus and simply do all cpus, but I
guess the rationale for not doing that and restricting it to cpu0 is to
avoid the O(n^2) thing in case userspace issues a reload on all cpus?

If so it would be good to mention in the Changelog so people see its not
a 'random' choice.
