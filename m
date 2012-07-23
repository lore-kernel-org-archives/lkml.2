Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2GWT3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:29:24 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38061 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab2GWT3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:29:22 -0400
Date: Mon, 23 Jul 2012 12:29:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lenb@kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [Resend][PATCH] ACPI / PM: Fix build warning in sleep.c for
 CONFIG_ACPI_SLEEP unset
Message-ID: <20120723192910.GD2491@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120721214156.GA2515@linux.vnet.ibm.com>
 <201207221940.51764.rjw@sisk.pl>
 <20120722202843.GQ2435@linux.vnet.ibm.com>
 <201207232101.02472.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207232101.02472.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072319-4242-0000-0000-000002686FC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 09:01:02PM +0200, Rafael J. Wysocki wrote:
> 
> If CONFIG_ACPI_SLEEP is unset, the compiler complains that
> pwr_btn_event_pending is defined but not used.  To silence the
> warning, move the definition of pwr_btn_event_pending under an
> appropriate #ifdef.
> 
> Reported-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Tested-by: Paul E. McKenney <paul.mckenney@linaro.org>

> ---
>  drivers/acpi/sleep.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/acpi/sleep.c
> ===================================================================
> --- linux.orig/drivers/acpi/sleep.c
> +++ linux/drivers/acpi/sleep.c
> @@ -57,7 +57,6 @@ MODULE_PARM_DESC(gts, "Enable evaluation
>  MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
> 
>  static u8 sleep_states[ACPI_S_STATE_COUNT];
> -static bool pwr_btn_event_pending;
> 
>  static void acpi_sleep_tts_switch(u32 acpi_state)
>  {
> @@ -110,6 +109,7 @@ static int acpi_sleep_prepare(u32 acpi_s
> 
>  #ifdef CONFIG_ACPI_SLEEP
>  static u32 acpi_target_sleep_state = ACPI_STATE_S0;
> +static bool pwr_btn_event_pending;
> 
>  /*
>   * The ACPI specification wants us to save NVS memory regions during hibernation
> 

