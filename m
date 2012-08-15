Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab2HOTJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:09:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65370 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab2HOTJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:09:11 -0400
Date: Wed, 15 Aug 2012 21:09:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] cputime: Generalize CONFIG_VIRT_CPU_ACCOUNTING
Message-ID: <20120815190901.GD19716@somewhere>
References: <1344953810-20564-1-git-send-email-fweisbec@gmail.com>
 <1344953810-20564-2-git-send-email-fweisbec@gmail.com>
 <20120815170347.323507b1@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815170347.323507b1@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 05:03:47PM +0200, Martin Schwidefsky wrote:
> On Tue, 14 Aug 2012 16:16:47 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > S390, ia64 and powerpc all define their own version
> > of CONFIG_VIRT_CPU_ACCOUNTING. Generalize the config
> > and its description to a single place to avoid
> > duplication.
> 
> For S390 CONFIG_VIRT_CPU_ACCOUNTING is not configurable, it is always
> enabled. With this patch we'd get a config option in the menu, no?

Indeed it now appears in the menu but in the case of s390, it's impossible
to turn it off due to:

	config S390
		select VIRT_CPU_ACCOUNTING

This creates a strict dependency that the user can't override. The option
is untoggable.
