Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2GUVv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 17:51:59 -0400
Received: from shutemov.name ([176.9.204.213]:44172 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab2GUVv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 17:51:57 -0400
Date: Sun, 22 Jul 2012 00:52:43 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: fix pwr_btn_event_pending build error
Message-ID: <20120721215243.GA15362@shutemov.name>
References: <20120721214156.GA2515@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120721214156.GA2515@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2012 at 02:41:56PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> A recent build for KVM on x86 resulted in the following build error:
> 
> drivers/acpi/sleep.c:60:13: warning: ‘pwr_btn_event_pending’ defined but not
> +used [-Wunused-variable]
> 
> This patch silences this error.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index 8856102..18347aa 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -57,7 +57,9 @@ MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
>  MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
>  
>  static u8 sleep_states[ACPI_S_STATE_COUNT];
> +#ifdef CONFIG_ACPI_SLEEP
>  static bool pwr_btn_event_pending;
> +#endif /* #ifdef CONFIG_ACPI_SLEEP */

__maybe_unused ?

-- 
 Kirill A. Shutemov
