Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1K1W4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:56:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49099 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1K1W4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:56:12 -0500
Date: Mon, 28 Nov 2011 14:56:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] prctl: Add PR_ codes to restore vDSO and tune up
 mm_struct entires
Message-ID: <20111128225606.GD3858@google.com>
References: <20111124120051.GV1820@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124120051.GV1820@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Cyrill.

On Thu, Nov 24, 2011 at 04:00:51PM +0400, Cyrill Gorcunov wrote:
> +		case PR_SETUP_VDSO_AT:
> +			if (arg3 | arg4 | arg5)
> +				return -EINVAL;
> +
> +			if (!capable(CAP_SYS_ADMIN))
> +				return -EPERM;
> +
> +#ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
> +			error = arch_setup_additional_pages_at((void *)arg2);
> +#else
> +			error = -ENOSYS;
> +#endif
> +			break;

Hmmm... I'm not sure this is the best approach.  vdso is supposed to
be able to be dependent on binprm too, so the proposed solution could
work but I'm not sure whether it's a good one.  For now, can't we just
copy the vdso and unmap it at the orignal address?

Thanks.

-- 
tejun
