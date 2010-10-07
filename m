Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab0JGAcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 20:32:06 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40779 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573Ab0JGAcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 20:32:04 -0400
Date: Thu, 7 Oct 2010 09:27:41 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] HWPOISON: Copy si_addr_lsb to user
Message-ID: <20101007002741.GA9891@spritzera.linux.bs1.fc.nec.co.jp>
References: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
 <1286398141-13749-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <1286398141-13749-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just nitpicking...

> @@ -2215,6 +2215,14 @@ int copy_siginfo_to_user(siginfo_t __user *to, siginfo_t *from)
>  #ifdef __ARCH_SI_TRAPNO
>  		err |= __put_user(from->si_trapno, &to->si_trapno);
>  #endif
> +#ifdef BUS_MCEERR_AO
> +		/* 
                  ^
                  trailing white space
> +		 * Other callers might not initialize the si_lsb field,
> +	 	 * so check explicitely for the right codes here.
        ^                   ^^^^^^^^^^^
        white space         explicitly

> +		 */
> +		if (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO)
> +			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
> +#endif
>  		break;
>  	case __SI_CHLD:
>  		err |= __put_user(from->si_pid, &to->si_pid);

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks,
Naoya Horiguchi
