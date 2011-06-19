Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1FSTM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 15:12:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab1FSTM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 15:12:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 12/19] OpenRISC: Scheduling/Process management
Date: Sun, 19 Jun 2011 21:12:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <1308483825-6023-13-git-send-email-jonas@southpole.se>
In-Reply-To: <1308483825-6023-13-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106192112.25581.arnd@arndb.de>
X-Provags-ID: V02:K0:I26UTV1W72/bn2SzWwIrzxRsFGTW3R98tieJeXDs/a/
 EZYAhnq8Jntb+Ck6lmWQl9TaKkegsu95WXtVkOBifAmfw7yZtk
 nOVw/EbJwACaqfD099S0+MO8LsA6ZlF21rrlGYv5+FOKpGVpLh
 UdETwqIsIVAlQ42fE3Ef4bYHesitUjv7g3rk1RWghhOLqA+0sb
 DBeh0LqOToJ4HNxmBXUwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 13:43:38 Jonas Bonn wrote:

> +#if 0
> +
> +/*
> + * The hlt_counter, disable_hlt and enable_hlt is just here as a hook if
> + * there would ever be a halt sequence (for power save when idle) with
> + * some largish delay when halting or resuming *and* a driver that can't
> + * afford that delay.  The hlt_counter would then be checked before
> + * executing the halt sequence, and the driver marks the unhaltable
> + * region by enable_hlt/disable_hlt.
> + */
> +
> +static int hlt_counter=0;

This can certainly be removed, it's only used by the floppy driver.

> +void machine_restart(void)
> +{
> +	printk("*** MACHINE RESTART ***\n");
> +	__asm__("l.nop 1");
> +}
> +
> +EXPORT_SYMBOL(machine_restart);
> +
> +/*
> + * Similar to machine_power_off, but don't shut off power.  Add code
> + * here to freeze the system for e.g. post-mortem debug purpose when
> + * possible.  This halt has nothing to do with the idle halt.
> + */
> +
> +void machine_halt(void)
> +{
> +	printk("*** MACHINE HALT ***\n");
> +	__asm__("l.nop 1");
> +}
> +
> +EXPORT_SYMBOL(machine_halt);
> +
> +/* If or when software power-off is implemented, add code here.  */
> +
> +void machine_power_off(void)
> +{
> +	printk("*** MACHINE POWER OFF ***\n");
> +	__asm__("l.nop 1");
> +}
> +
> +EXPORT_SYMBOL(machine_power_off);
> +
> +void (*pm_power_off)(void) = machine_power_off;
> +EXPORT_SYMBOL(pm_power_off);

I don't think any of these should be exported.

	Arnd
