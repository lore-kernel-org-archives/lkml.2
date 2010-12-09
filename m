Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0LITVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:21:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:38514 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0LITVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:21:21 -0500
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1291267223.2405.314.camel@minggr.sh.intel.com>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Dec 2010 20:21:07 +0100
Message-ID: <1291922467.6803.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 13:20 +0800, Lin Ming wrote:
> +       /* Check CPUID signatures: 06_1AH, 06_1EH, 06_1FH */
> +       family = boot_cpu_data.x86;
> +       model = boot_cpu_data.x86_model;
> +       if (family != 6 || (model != 0x1A && model != 0x1E && model != 0x1F))
> +               return; 

So that's 26, 30 and 31? Curiously
arch/x86/kernel/cpu/perf_event_intel.c does have 31.

Also, could you match the style from perf_event_intel.c?
