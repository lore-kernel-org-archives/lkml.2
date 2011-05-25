Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab1EYAjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 20:39:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:37100 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628Ab1EYAjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 20:39:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,264,1304319600"; 
   d="scan'208";a="1008291"
Date: Tue, 24 May 2011 17:39:42 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525003941.GA30997@linux-os.sc.intel.com>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org> <1306278210-18285-3-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306278210-18285-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>@@ -300,6 +295,7 @@ static int apply_microcode(int cpu)
>       struct ucode_cpu_info *uci;
>      unsigned int val[2];
>       int cpu_num;
>+       struct cpuinfo_x86 *c = &cpu_data(cpu_num);

This is wrong. cpu_num is not initialized yet at this point. You need to assign c after cpu_num is initialized in the next statement.

>
>       cpu_num = raw_smp_processor_id();
>       uci = ucode_cpu_info + cpu;

Thanks.

-Fenghua
