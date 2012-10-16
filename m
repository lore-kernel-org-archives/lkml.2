Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab2JPR7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:59:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52985 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755016Ab2JPR7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:59:05 -0400
Message-ID: <1350410343.3072.12.camel@joe-AO722>
Subject: Re: [PATCH -v2 4/6] x86, RAS: Add function enabling direct writes
 to MCE MSRs
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Tony Luck <tony.luck@intel.com>, X86-ML <x86@kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 16 Oct 2012 10:59:03 -0700
In-Reply-To: <1350399175-14477-5-git-send-email-bp@amd64.org>
References: <1350399175-14477-1-git-send-email-bp@amd64.org>
	 <1350399175-14477-5-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-16 at 16:52 +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Normally, writing to MCE MSRs causes a #GP. Add a function to enable
> direct accesses to those MSRs.
[]
> diff --git a/arch/x86/ras/amd/mce-inject.c b/arch/x86/ras/amd/mce-inject.c

> @@ -55,6 +55,30 @@ DEFINE_SIMPLE_ATTRIBUTE(misc_fops, inj_misc_get, inj_misc_set, "%llx\n");
[]
> +static int toggle_hw_mce_inject(unsigned int cpu, bool enable)
[]
> +	enable ? (l |= BIT(18)) : (l &= ~BIT(18));

This is very unusual style.
I found just one like it in the kernel tree.
(unnecessary parens here too btw)

This style is much more common:
	if (enable)
		l |= BIT(18);
	else
		l &= ~BIT(18);



