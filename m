Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1CEMcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 07:32:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62249 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab1CEMcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 07:32:21 -0500
Message-ID: <4D722D02.5090504@ru.mvista.com>
Date: Sat, 05 Mar 2011 15:30:58 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.14) Gecko/20110221 Thunderbird/3.1.8
MIME-Version: 1.0
To: Michael Spang <mspang@csclub.uwaterloo.ca>
CC: Nicolas Pitre <nico@fluxnic.net>, Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: Enable TS-78XX features in unknown revisions
References: <1299299957-13018-1-git-send-email-mspang@csclub.uwaterloo.ca> <1299299957-13018-2-git-send-email-mspang@csclub.uwaterloo.ca>
In-Reply-To: <1299299957-13018-2-git-send-email-mspang@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-03-2011 7:39, Michael Spang wrote:

> When the manufacturer increases the revision number the platform
> devices for the RTC, NAND, and RNG disappear. We should assume
> new revisions have these devices instead of assuming they do not.

> Signed-off-by: Michael Spang<mspang@csclub.uwaterloo.ca>
> ---
>   arch/arm/mach-orion5x/ts78xx-setup.c |    8 +++++---
>   1 files changed, 5 insertions(+), 3 deletions(-)

> diff --git a/arch/arm/mach-orion5x/ts78xx-setup.c b/arch/arm/mach-orion5x/ts78xx-setup.c
> index 7bed418..13d1fc5 100644
> --- a/arch/arm/mach-orion5x/ts78xx-setup.c
> +++ b/arch/arm/mach-orion5x/ts78xx-setup.c
> @@ -343,9 +343,11 @@ static void ts78xx_fpga_supports(void)
>   		ts78xx_fpga.supports.ts_rng.present = 1;
>   		break;
>   	default:
> -		ts78xx_fpga.supports.ts_rtc.present = 0;
> -		ts78xx_fpga.supports.ts_nand.present = 0;
> -		ts78xx_fpga.supports.ts_rng.present = 0;
> +		printk(KERN_WARN "Unrecognized TS-78XX FPGA ID 0x%02x",

    Use pr_warning() or pr_warn().

WBR, Sergei
