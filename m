Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3ADVTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:19:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49801 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023Ab3ADVTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:19:02 -0500
Date: Fri, 4 Jan 2013 22:19:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 04/31] x86, 64bit, mm: add generic kernel/ident
 mapping helper
Message-ID: <20130104211913.GC24228@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-5-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357260531-11115-5-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:24PM -0800, Yinghai Lu wrote:
> +int kernel_mapping_init(pgd_t *pgd_page, unsigned long addr, unsigned long end)
> +{
> +	struct x86_mapping_info info = {
> +		.alloc_pgt_page	= alloc_pgt_page,
> +		.pmd_flag	= __PAGE_KERNEL_LARGE,
> +		.kernel_mapping	= true,
> +	};
> +
> +	return kernel_ident_mapping_init(&info, pgd_page, addr, end);

This patch looks good so far except this:
kernel_ident_mapping_init says it initializes ident mapping but
this is wrong and the type of mapping is actually controlled by
info.kernel_mapping.

So this function which gets &info, etc should be called
kernel_mapping_init, AFAICT. And wrt the one wrapping
kernel_ident_mapping_init, I can't seem to find where it is called.
What's up?

Thanks.

-- 
Regards/Gruss,
Boris.
