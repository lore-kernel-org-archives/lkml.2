Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070Ab0JLVXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 17:23:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:49829 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab0JLVXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 17:23:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,322,1283756400"; 
   d="scan'208";a="616062924"
Date: Tue, 12 Oct 2010 14:20:00 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, jacob.jun.pan@linux.intel.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] x86: Sanitize apb timer interrupt handling
Message-ID: <20101012142000.00001358@unknown>
In-Reply-To: <tip-a5ef2e70405c8a9ee380b5ff33a008c75454791f@git.kernel.org>
References: <tip-a5ef2e70405c8a9ee380b5ff33a008c75454791f@git.kernel.org>
Organization: Intel OTC
X-Mailer: Claws Mail 3.7.4cvs1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>x86: Sanitize apb timer interrupt handling
>
>Disable the interrupt in CPU_DEAD where it belongs.
My main concern is the performance cost. The power management code for
Moorestown system make use of the cpu hotplug code (disable_nonboot_cpus)
but much more frequently. The system low power states are call S0 idle
state (s0ix).

Leaving the irq enabled at the chip and desc level between S0ix states
might give some performance benefit. That was my original thought.
Will it cause problems?

Thanks,

Jacob

