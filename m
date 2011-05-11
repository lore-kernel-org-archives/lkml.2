Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab1EKWgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:36:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:15461 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab1EKWgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:36:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,354,1301900400"; 
   d="scan'208";a="641471759"
From: Andi Kleen <andi@firstfloor.org>
To: "Fenghua Yu" <fenghua.yu@intel.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86, cpu: Enable/disable SMEP
References: <1305141480-843-1-git-send-email-fenghua.yu@intel.com>
	<1305141480-843-4-git-send-email-fenghua.yu@intel.com>
Date: Wed, 11 May 2011 15:36:30 -0700
In-Reply-To: <1305141480-843-4-git-send-email-fenghua.yu@intel.com> (Fenghua
	Yu's message of "Wed, 11 May 2011 12:18:00 -0700")
Message-ID: <m2k4dwj24x.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Fenghua Yu" <fenghua.yu@intel.com> writes:
  
> +static int disable_smep;

If you add a __initdata here the whole thing will completely disappear
after boot.

> @@ -867,6 +886,8 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
>  	/* Init Machine Check Exception if available. */
>  	mcheck_cpu_init(c);
>  
> +	setup_smep(c);

My feeling is you're setting this too late. In theory there could be
early overflows. Better use a early_param and set it as early
as possible, directly after the cpuid flags are set up in early
initialization.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
