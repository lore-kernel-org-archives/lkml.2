Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab2KDVH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 16:07:26 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36012 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2KDVHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 16:07:25 -0500
Message-ID: <5096D90A.401@gmail.com>
Date: Sun, 04 Nov 2012 22:07:22 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Luming Yu <luming.yu@intel.com>
Subject: Re: [PATCH 01/13] HW-latency: hardware latency test 0.10
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com> <1352080784-30839-2-git-send-email-luming.yu@gmail.com>
In-Reply-To: <1352080784-30839-2-git-send-email-luming.yu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 05-11-12 02:59, Luming Yu schreef:
> This patch is the first step to test some basic hardware functions like
> TSC to help people understand if there is any hardware latency as well
> as throughput problem exposed on bare metal or left behind by BIOS or
> interfered by SMI. Currently the patch tests TSC, CPU Frequency and
> RDRAND which is a new CPU instruction to get random number introduced in
> new CPU like Intel Ivy Bridge in stop_machine context,which is choosen to
> make sure testers fully control their system under test to rule out some
> level of unwanted noise.
>
> Signed-off-by: Luming Yu <luming.yu@intel.com>
> ---
>  drivers/misc/Kconfig           |   7 +
>  drivers/misc/Makefile          |   1 +
>  drivers/misc/hw_latency_test.c | 833 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 841 insertions(+)
>  create mode 100644 drivers/misc/hw_latency_test.c
>
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index b151b7c..5ed440b 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -114,6 +114,13 @@ config IBM_ASM
>  	  for information on the specific driver level and support statement
>  	  for your IBM server.
>  
> +config HW_LATENCY_TEST
> +	tristate "Testing module to detect hardware lattency and throughput"
> +	depends on DEBUG_FS
> +	depends on RING_BUFFER
> +	depends on X86
> +	default m
Is there any reason this tester couldn't easily be made to work for !x86?

Also I think it would make more sense to squash all fixes, and submit fixes for the things like
'[PATCH 07/13] HW-latency: delete too many "Fast TSC calibration using PIT" in cpufreq sampling'
before the actual patch. It seems this is not necessarily a hw-latency specific patch to me.

~Maarten
