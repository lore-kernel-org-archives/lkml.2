Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3AGPxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:53:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38113 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab3AGPxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:53:43 -0500
Date: Mon, 7 Jan 2013 16:53:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH v7u1 05/31] x86, 64bit: copy zero-page early
Message-ID: <20130107155339.GA29449@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org,
	Alexander Duyck <alexander.h.duyck@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357260531-11115-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:25PM -0800, Yinghai Lu wrote:
> real_mode_data aka zero-page could be above 4g.

I think this could be more informative if it said 'struct boot_params'
instead of real_mode_data because real_mode_data is the argument name
passed to the respective function and grepping for struct boot_params
actually gives you the struct definition with the helpful comments and
offsets in arch/x86/include/uapi/asm/bootparam.h.

> We will have #PF handler to set page table for not accessible ram
> early, but could limit it before x86_64_start_reservations to limit
> the change to native path.
> 
> Also we will need to ramdisk info in zero-page to access microcode
		   s/to/the/				  ^
							the

> blob in ramdisk in x86_64_start_kernel, so copy zero-page early make
								  makes
> it accessing ramdisk info simple.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Alexander Duyck <alexander.h.duyck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>

-- 
Regards/Gruss,
Boris.
