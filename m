Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1C1RZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:25:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51119 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab1C1RZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:25:11 -0400
Message-ID: <4D90C472.3090908@linux.vnet.ibm.com>
Date: Mon, 28 Mar 2011 13:25:06 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeff Layton <jlayton@poochiereds.net>
CC: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: TPM chip prevents machine from suspending
References: <20110328100846.0ba2e039@tlielax.poochiereds.net>
In-Reply-To: <20110328100846.0ba2e039@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 10:08 AM, Jeff Layton wrote:
> My wife's machine apparently has a TPM chip in it. Since I upgraded it
> to Fedora 14, it fails to suspend consistently. On the first attempt to
> suspend it, it works fine. Once it has woken back up however, it will
> not suspend again. Here's the dmesg log from such an attempt:
>
> [  202.460967] PM: Syncing filesystems ... done.
> [  202.464818] PM: Preparing system for mem sleep
> [  202.485968] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [  202.497079] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [  202.508067] PM: Entering mem sleep
> [  202.508086] Suspending console(s) (use no_console_suspend to debug)
> [  202.508451] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
> [  202.508562] sd 2:0:0:0: [sda] Synchronizing SCSI cache
> [  202.508616] sd 3:0:0:0: [sdb] Stopping disk
> [  202.511956] parport_pc 00:0b: disabled
> [  202.512127] serial 00:09: disabled
> [  202.512134] serial 00:09: wake-up capability disabled by ACPI
> [  202.536058] legacy_suspend(): pnp_bus_suspend+0x0/0x82 returns 38
> [  202.536061] PM: Device 00:02 failed to suspend: error 38
> [  202.997517] sd 2:0:0:0: [sda] Stopping disk
> [  202.997806] PM: Some devices failed to suspend
> [  202.998085] sd 2:0:0:0: [sda] Starting disk
> [  202.998144] sd 3:0:0:0: [sdb] Starting disk
> [  202.998614] serial 00:09: activated
> [  202.999158] parport_pc 00:0b: activated
> [  204.543094] PM: resume of devices complete after 1545.282 msecs
> [  204.543268] PM: Finishing wakeup.
> [  204.543270] Restarting tasks ... done.
>
> ...error 38 is ENOSYS, and the 00:02 is this:
>
> # cat /sys/bus/pnp/devices/00\:02/id
> IFX0102
> PNP0c31
Also the tpm_tis driver handles both of these. Can you confirm which 
module that laptop was using  (tpm_tis or tpm_infineon) and try whether 
one of them works better than the other one? Please do a reboot between 
trying one and then the other.

Try the following before and after a suspend/resume:

cd /sys
find . | grep caps$ | xargs cat

It should display manufacturer data.

     Stefan


