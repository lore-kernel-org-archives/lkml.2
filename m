Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab2LSRWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:22:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50792 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab2LSRWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:22:09 -0500
Date: Wed, 19 Dec 2012 18:22:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 26/27] x86: add Crash kernel low reservation
Message-ID: <20121219172207.GF24895@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
 <1355814959-10573-27-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355814959-10573-27-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:15:58PM -0800, Yinghai Lu wrote:
> +static u64 __init get_mem_size(unsigned long limit_pfn)
> +{
> +	int i;
> +	u64 pages = 0;
> +	unsigned long start_pfn, end_pfn;
> +
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
> +		start_pfn = min_t(unsigned long, start_pfn, limit_pfn);
> +		end_pfn = min_t(unsigned long, end_pfn, limit_pfn);
> +		pages += end_pfn - start_pfn;
> +	}
> +
> +	return pages << PAGE_SHIFT;
> +}

This needs an empty function prototype for the .config variant where both

# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_KEXEC is not set

otherwise:

arch/x86/kernel/setup.c:295:19: warning: ‘get_mem_size’ defined but not used [-Wunused-function]

At a second glance though, a better fix might be if that whole
if-deffery in setup.c could be cleaned up a bit.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
