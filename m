Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab2LOR2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 12:28:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33579 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab2LOR2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 12:28:09 -0500
Date: Sat, 15 Dec 2012 18:28:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v6 04/27] x86, boot: Move lldt/ltr out of 64bit code
 section
Message-ID: <20121215172805.GA20393@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>,
	Matt Fleming <matt.fleming@intel.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <1355436141-8668-5-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355436141-8668-5-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 02:01:58PM -0800, Yinghai Lu wrote:
> commit 08da5a2ca
> 
>     x86_64: Early segment setup for VT
> 
> add lldt/ltr to clean more segments.
> 
> Those code are put in code64, and it is using gdt that is only
> loaded from code32 path.
> 
> That breaks booting with 64bit bootloader that does not go through
> code32 path. It get at startup_64 directly,  and it has different
> gdt.
> 
> Move those lines into code32 after their gdt is loaded.

Let me rewrite that commit message for ya, you tell me whether I got it
right:

"08da5a2ca479 ("x86_64: Early segment setup for VT") sets up LDT and TR
into a valid state in order to speed up boot decompression under VT. The
code which loads the GDT is executed in the 32-bit startup code while
the above change in the 64-bit part.

However, this breaks 64-bit bootloaders which jump straight to the
64-bit startup entry point and thus skip LDR and TR setup because they
use a different GDT.

Fix this by moving the LDT and TR setup to the 32-bit section."

Is that correct?

If so, why not take the time and try to write your commits more
understandably so that bystanders like me don't have to look at the code
first and scramble to understand what you mean?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
