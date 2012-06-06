Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2FFJDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:03:52 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40803 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2FFJDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:03:51 -0400
Date: Wed, 6 Jun 2012 11:04:15 +0200
From: Borislav Petkov <bp@amd64.org>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel machines
Message-ID: <20120606090415.GA602@aftab.osrc.amd.com>
References: <20120524174943.989990966@linutronix.de>
 <20120524175056.478167482@linutronix.de>
 <4FCC1F7C.5000008@linux.intel.com>
 <alpine.LFD.2.02.1206042158200.3086@ionos>
 <4FCDF1C8.9020007@linux.intel.com>
 <20120605125758.GD13495@aftab.osrc.amd.com>
 <4FCEB434.9040006@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCEB434.9040006@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 09:36:52AM +0800, Chen Gong wrote:
> Yes, I am just afraid similar situation happening when injecting MCEs
> or poll timer running too fast, which is like a pseduo CMCI storm.
> Maybe similar logic behind CMCI_STORM can be used there.

Poll timer on !Intel fires once every 5 minutes and halves the interval
when it detects a valid MCE.

I still don't think this is an issue if you poll only on single CPUs -
I think you need the throttling because, as Tony explained earlier, the
CMCI interrupt runs on _all_ CPUs and I can see how that can be hurting
performance.

CMCI on AMD (or, rather, our version of it) runs only on the CPU which
sees the error so I don't think we need throttling there, unless real
life proves me otherwise.

So, the whole CMCI deal should be Intel-only (for now, at least) and it
shouldn't be touching generic MCE code.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
