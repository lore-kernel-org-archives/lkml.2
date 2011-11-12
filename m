Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1KLDlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 22:41:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55019 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1KLDlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 22:41:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [bisected][bug] commit e978aa7d7d57d04eb5f88 breaks suspend on laptop.
Date: Sat, 12 Nov 2011 03:41:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111120341.12473.arnd@arndb.de>
X-Provags-ID: V02:K0:cIpfWppL03Saxd57dGb9fXhc0F0xX9j4vquO6PfGTYv
 XdHxPdvxVl5MG9a192YZO0p3evd3yFnwTDwugKHFfWvqEva4Y3
 LyWmQEHv0e0yZ1myVrwZueJm+fZdnE8Ex2bB3C2t5JuZN+BpHt
 SAK/ReC5ySI6H59fCAZ1YbB2cLjQ+n8FTYLO0r4PygGhMHk2jH
 BMKniq6rpVBgyx2IEJSJ6dUs/IiaZRMgRSXGvEe+c/i5axKZ9+
 YVs83EvJb8kfWjvRdwi08w0rn7Af+jNMsPcMKmpKOOGXRCVSOV
 Ht6yPhr4qgKzW8yYON0UbAcLkuCzr3RfwGUn7Q9AZKvtoZ/4dW
 l9nUWJ2L8RTYUydGhWWg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 12, 2011, Rafael J. Wysocki wrote:
> If that's "acpi_idle", the appended patch should help (it works for
> me at least).

Hi Rafael,

I currently have limited email connectivity but I happened to bisect the
same bug and your patch fixes it for me. I am certainly on acpi_idle
with my thinkpad w500.

Sorry for breaking the email threading and dropping people from Cc.

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: ACPI / cpuidle: Remove acpi_idle_suspend (to fix suspend regression)
> After commit e978aa7d7d57d04eb5f88a7507c4fb98577def77 (cpuidle: Move
> dev->last_residency update to driver enter routine; remove
> dev->last_state) setting acpi_idle_suspend to 1 by
> acpi_processor_suspend() causes the ACPI cpuidle routines to return
> error codes continuously, which in turn causes cpuidle to lock up
> (hard).  However, acpi_idle_suspend doesn't appear to be useful for
> any purpose (it's racy and doesn't really provide any real
> protection), so it can be removed, which makes the problem go away.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Tested-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
