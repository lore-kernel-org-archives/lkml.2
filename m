Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab1GENSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:18:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46025 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab1GENSU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:18:20 -0400
Subject: Re: [PATCH 2/4] perf, x86: Add Intel Nhm/Wsm/Snb load latency
 support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1309766525-14089-3-git-send-email-ming.m.lin@intel.com>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-3-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Jul 2011 15:17:48 +0200
Message-ID: <1309871868.3282.149.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 08:02 +0000, Lin Ming wrote:
> +#define INTEL_EVENT_EXTRA_REG2(event, msr, vm)    \
> +       EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT | \
> +                       ARCH_PERFMON_EVENTSEL_UMASK, vm) 

That's inconsistent wrt the normal constraints, INTEL_UEVENT_EXTRA_REG
would be the consistent name.

#define INTEL_UEVENT_EXTRA_REG(event, msr, vm)	\
	EVENT_EXTRA_REG(event, msr, INTEL_ARCH_EVENT_MASK, vm)


