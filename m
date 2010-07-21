Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab0GUQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 12:16:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58394 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab0GUQQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 12:16:25 -0400
Message-ID: <4C471D37.4010208@zytor.com>
Date: Wed, 21 Jul 2010 09:15:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] x86, xsave: make xsave_cntxt_init() static
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com> <1279651857-24639-6-git-send-email-robert.richter@amd.com> <1279664424.2899.47.camel@sbs-t61.sc.intel.com> <20100721134809.GQ26154@erda.amd.com>
In-Reply-To: <20100721134809.GQ26154@erda.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2010 06:48 AM, Robert Richter wrote:
> On 20.07.10 18:20:24, Suresh Siddha wrote:
> 
>> Perhaps we can fold this patch into 
>> [PATCH 06/10] x86, xsave: do not initialize xsave in fpu_init()
>>
>> and probably do  fpu_init() first followed by xsave_init() so that
>> fpu_init() will set xstate_size based on fpu features and xsave_init()
>> can later overwrite xstate_size based on xstate features.
> 
> Yes, I will do this instead.
> 
> Lookin at this, I found that xsave is broken for (!HAVE_HWFP). This
> should be the case if config MATH_EMULATION and 'no387' kernel
> parameter are set and xsave exists. xsave will not work because
> x86/math-emu and xsave share the same memory. But this case can be
> treated as corner case. Maybe we should simply disable xsave then.
> 

Yes, I think we should.  It is *extremely* unlikely that any such real
hardware will ever be created at this point, and if so we can burn that
bridge when we get to it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

