Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2JPPlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:41:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59542 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755014Ab2JPPlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:41:18 -0400
Message-ID: <1350402077.28048.8.camel@joe-AO722>
Subject: Re: [PATCH -v2 3/6] x86, RAS: Convert mce-inject module to debugfs
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Tony Luck <tony.luck@intel.com>, X86-ML <x86@kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 16 Oct 2012 08:41:17 -0700
In-Reply-To: <1350399175-14477-4-git-send-email-bp@amd64.org>
References: <1350399175-14477-1-git-send-email-bp@amd64.org>
	 <1350399175-14477-4-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-16 at 16:52 +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
[]
> diff --git a/arch/x86/ras/amd/mce-inject.c b/arch/x86/ras/amd/mce-inject.c
[]
> +#define MCE_INJECT_GET(reg)						\
> +static int inj_##reg##_get(void *data, u64 *val)			\
>  {									\
> -	return sprintf(buf, "0x%016llx\n", i_mce.reg);			\
> +	struct mce *m = (struct mce *)data;				\

trivia: doesn't need a cast


