Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2KELbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:31:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64106 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636Ab2KELbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:31:33 -0500
Date: Mon, 5 Nov 2012 11:31:03 +0000
From: Will Deacon <will.deacon@arm.com>
To: "jgq516@gmail.com" <jgq516@gmail.com>
Cc: "robert.richter@amd.com" <robert.richter@amd.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: oprofile: add A5/A7/A15 entries in op_perf_name
Message-ID: <20121105113102.GF3351@mudshark.cambridge.arm.com>
References: <1351853016-4476-1-git-send-email-jgq516@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351853016-4476-1-git-send-email-jgq516@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 10:43:36AM +0000, jgq516@gmail.com wrote:
> From: Xiao Jiang <jgq516@gmail.com>
> 
> Add related name for A5/A7/A15 which are consistent with the OProfile
> user ABI.
> 
> Signed-off-by: Xiao Jiang <jgq516@gmail.com>
> ---
>  arch/arm/oprofile/common.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> index 99c63d4b..ec10db1 100644
> --- a/arch/arm/oprofile/common.c
> +++ b/arch/arm/oprofile/common.c
> @@ -37,8 +37,11 @@ static struct op_perf_name {
>  	{ "xscale1",		"arm/xscale2"	},
>  	{ "v6",			"arm/armv6"	},
>  	{ "v6mpcore",		"arm/mpcore"	},
> +	{ "ARMv7 Cortex-A5",	"arm/armv7-ca5"	},
> +	{ "ARMv7 Cortex-A7",	"arm/armv7-ca7"	},
>  	{ "ARMv7 Cortex-A8",	"arm/armv7"	},
>  	{ "ARMv7 Cortex-A9",	"arm/armv7-ca9"	},
> +	{ "ARMv7 Cortex-A15",	"arm/armv7-ca15" },
>  };
>  
>  char *op_name_from_perf_id(void)

I'd rather not go down this route now that we have the operf tool as part of
oprofile, which can use the perf syscall directly and doesn't need this
string translation.

Will
