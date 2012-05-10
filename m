Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab2EJHui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:50:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36451 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab2EJHug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:50:36 -0400
Date: Thu, 10 May 2012 09:50:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, joerg.roedel@amd.com,
        paul.gortmaker@windriver.com, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 2/2] irq: use config_enabled(SMP) checks to cleanup
 irq_set_affinity() for UP
Message-ID: <20120510075031.GC28395@gmail.com>
References: <20120509093001.GD8585@gmail.com>
 <1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
 <1336589196-14498-2-git-send-email-suresh.b.siddha@intel.com>
 <1336593505.4634.11.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336593505.4634.11.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Wed, 2012-05-09 at 11:46 -0700, Suresh Siddha wrote:
> > Use config_enabled(SMP) checks for cleaning up the ifdef CONFIG_SMP around
> > irq_set_affinity routines in io_apic and irq_remapping subsystems.
> > 
> 
> Switched to IS_BUILTIN() instead. Thanks.

Hm, what was wrong with config_enabled(CONFIG_SMP)?

The IS_BUILTIN() macro is 1) shouting loud, needlessly 2) 
somewhat confusing for the CONFIG_SMP case: of course SMP is 
'built in', not modular - and the fact that 'built in' also 
implies 'enabled' is lost in that naming variant.

So I think IS_BUILTIN() makes more sense for genuine tri-state 
config knobs, and bools like CONFIG_SMP should se 
config_enabled()..

Thanks,

	Ingo
