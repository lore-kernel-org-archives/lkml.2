Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2IGSr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:47:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33563 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab2IGSr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:47:56 -0400
Message-ID: <504A414E.40507@zytor.com>
Date: Fri, 07 Sep 2012 11:47:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@kernel.org, torvalds@linux-foundation.org, andreas.herrmann3@amd.com,
        bp@amd64.org, robert.richter@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86, fpu: decouple non-lazy/eager fpu restore from
 xsave
References: <1347042703-11128-1-git-send-email-suresh.b.siddha@intel.com>
In-Reply-To: <1347042703-11128-1-git-send-email-suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 11:31 AM, Suresh Siddha wrote:
>
> +static inline void fx_finit(struct i387_fxsave_struct *fx)
> +{
> +	memset(fx, 0, xstate_size);
> +	fx->cwd = 0x37f;
> +	if (cpu_has_xmm)
> +		fx->mxcsr = MXCSR_DEFAULT;
> +}
> +

Incidentally, Al Viro asked a very good question the other day, which is 
why can't we just set mxcsr unconditionally here?  I don't think any 
CPUs with FXSAVE and no MXCSR (Pentium II from Intel, 
Crusoe/TM-3xxx/5xxx from Transmeta, and presumably some of the K6 
generation from AMD) ever looked at this field.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

