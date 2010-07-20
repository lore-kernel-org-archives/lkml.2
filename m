Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab0GTVqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 17:46:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:18582 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab0GTVqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 17:46:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,234,1278313200"; 
   d="scan'208";a="819965859"
Subject: Re: [PATCH 01/10] x86, xsave: do not include asm/i387.h in
 asm/xsave.h
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1279651857-24639-2-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
	 <1279651857-24639-2-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Tue, 20 Jul 2010 14:46:10 -0700
Message-Id: <1279662370.2899.13.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 11:50 -0700, Robert Richter wrote:
> There are no dependencies to asm/i387.h. Instead, if including only
> xsave.h the following error occurs:
> 
>  .../arch/x86/include/asm/i387.h:110: error: ‘XSTATE_FP’ undeclared (first use in this function)
>  .../arch/x86/include/asm/i387.h:110: error: (Each undeclared identifier is reported only once
>  .../arch/x86/include/asm/i387.h:110: error: for each function it appears in.)
> 
> This patch fixes this.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/include/asm/xsave.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
> index ec86c5f..94d5f84 100644
> --- a/arch/x86/include/asm/xsave.h
> +++ b/arch/x86/include/asm/xsave.h
> @@ -3,7 +3,6 @@
>  
>  #include <linux/types.h>
>  #include <asm/processor.h>
> -#include <asm/i387.h>
>  
>  #define XSTATE_FP	0x1
>  #define XSTATE_SSE	0x2

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

