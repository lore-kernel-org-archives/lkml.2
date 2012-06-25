Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2FYF0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 01:26:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48548 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab2FYF0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 01:26:04 -0400
References: <20120625150130.5fd1716cabf02aed85918c20@canb.auug.org.au>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120625150130.5fd1716cabf02aed85918c20@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: linux-next: manual merge of the tip tree with the jdelvare-hwmon tree
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 24 Jun 2012 22:25:06 -0700
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, Jean Delvare <khali@linux-fr.org>
Message-ID: <f145453b-37d5-4116-bf75-001ea408b461@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I know... a mistake on my part.

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

>Hi all,
>
>Today's linux-next merge of the tip tree got a conflict in
>drivers/hwmon/coretemp.c between commit 3c1aae21b09d ("hwmon: struct
>x86_cpu_id arrays can be __initconst") from the jdelvare-hwmon tree and
>commit 3bac8715443f ("x86, cpufeature: Rename X86_FEATURE_DTS to
>X86_FEATURE_DTHERM") from the tip tree.
>
>Just context changes.  I fixed it up (see below) and can carry the fix
>as
>necessary.
>
>P.S. that tip tree commit has no Signed-off-by line at all :-(
>-- 
>Cheers,
>Stephen Rothwell                    sfr@canb.auug.org.au
>
>diff --cc drivers/hwmon/coretemp.c
>index b405781,637c51c..0000000
>--- a/drivers/hwmon/coretemp.c
>+++ b/drivers/hwmon/coretemp.c
>@@@ -793,8 -793,8 +793,8 @@@ static struct notifier_block coretemp_c
>  	.notifier_call = coretemp_cpu_callback,
>  };
>  
> -static const struct x86_cpu_id coretemp_ids[] = {
> +static const struct x86_cpu_id __initconst coretemp_ids[] = {
>- 	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, X86_FEATURE_DTS
>},
>+ 	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY,
>X86_FEATURE_DTHERM },
>  	{}
>  };
>  MODULE_DEVICE_TABLE(x86cpu, coretemp_ids);

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
