Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab0GUNsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:48:21 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:4087 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab0GUNsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:48:19 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dN936eMzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L5WUC7-02-JEC-02
X-M-MSG: 
Date: Wed, 21 Jul 2010 15:48:09 +0200
From: Robert Richter <robert.richter@amd.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] x86, xsave: make xsave_cntxt_init() static
Message-ID: <20100721134809.GQ26154@erda.amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
 <1279651857-24639-6-git-send-email-robert.richter@amd.com>
 <1279664424.2899.47.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1279664424.2899.47.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.07.10 18:20:24, Suresh Siddha wrote:

> Perhaps we can fold this patch into 
> [PATCH 06/10] x86, xsave: do not initialize xsave in fpu_init()
> 
> and probably do  fpu_init() first followed by xsave_init() so that
> fpu_init() will set xstate_size based on fpu features and xsave_init()
> can later overwrite xstate_size based on xstate features.

Yes, I will do this instead.

Lookin at this, I found that xsave is broken for (!HAVE_HWFP). This
should be the case if config MATH_EMULATION and 'no387' kernel
parameter are set and xsave exists. xsave will not work because
x86/math-emu and xsave share the same memory. But this case can be
treated as corner case. Maybe we should simply disable xsave then.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

