Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab2JZJad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:30:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43193 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab2JZJab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:30:31 -0400
Date: Fri, 26 Oct 2012 11:30:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Florian Fainelli <ffainelli@freebox.fr>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, rui.zhang@intel.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: ce4100: implement pm_poweroff
Message-ID: <20121026093026.GA1106@gmail.com>
References: <1351242325-23724-1-git-send-email-ffainelli@freebox.fr>
 <1351242325-23724-2-git-send-email-ffainelli@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351242325-23724-2-git-send-email-ffainelli@freebox.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Florian Fainelli <ffainelli@freebox.fr> wrote:

> The CE4100 platform is currently missing a proper pm_poweroff implementation
> leading to poweroff making the CPU spin forever and the CE4100 platform does
> not enter a low-power mode where the external Power Management Unit can
> properly power off the system. Power off on this platform is implemented pretty
> much like reboot, by writing to the SoC built-in 8051 microcontroller mapped at
> I/O port 0xcf9, the value 0x4.
> 
> Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
> ---
>  arch/x86/platform/ce4100/ce4100.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
> index 4c61b52..74f8774 100644
> --- a/arch/x86/platform/ce4100/ce4100.c
> +++ b/arch/x86/platform/ce4100/ce4100.c
> @@ -27,6 +27,11 @@ static int ce4100_i8042_detect(void)
>  	return 0;
>  }
>  
> +static void ce4100_power_off(void)
> +{
> +	outb(0x4, 0xcf9);

Would be nice to precede this function with something like:

/*
 * Power off on this platform is implemented pretty
 * much like reboot, by writing to the SoC built-in
 * 8051 microcontroller mapped at I/O port 0xcf9,
 * the magic value 0x4:
 */
static void ce4100_power_off(void)
{
	outb(0x4, 0xcf9);
...

As arguably such comments are even more useful in the code than 
in a changelog.

Thanks,

	Ingo
