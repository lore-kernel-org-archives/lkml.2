Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab2AFNEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 08:04:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52181 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2AFND7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 08:03:59 -0500
Message-ID: <1325854981.2442.25.camel@twins>
Subject: Re: [RFC PATCH 0/9] Remove useless on_each_cpu return value
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 06 Jan 2012 14:03:01 +0100
In-Reply-To: <1325600353-10895-1-git-send-email-gilad@benyossef.com>
References: <1325600353-10895-1-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 16:19 +0200, Gilad Ben-Yossef wrote:
> on_each_cpu() returns as its own return value the return value of 
> smp_call_function(). smp_call_function() in turn returns a hard 
> coded value of zero.
> 
> Some callers to on_each_cpu() waste cycles and bloat code space
> by checking the return value to on_each_cpu(), probably for 
> historical reasons.

hysterical raisins,, yumm! :-)

> This patch set refactors callers to not test on_each_cpu()
> (fixed) return value and then refactors on_each_cpu to
> return void to avoid confusing future users.
> 

Seems sane enough, fwiw:

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
