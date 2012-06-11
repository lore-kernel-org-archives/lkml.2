Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2FKU4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:56:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44969 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751845Ab2FKU4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:56:51 -0400
Message-ID: <1339448210.19977.2.camel@joe2Laptop>
Subject: Re: [PATCH v3] watchdog: Quiet down the boot messages
From: Joe Perches <joe@perches.com>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, nzimmer@sgi.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 11 Jun 2012 13:56:50 -0700
In-Reply-To: <1339445050-29941-1-git-send-email-dzickus@redhat.com>
References: <1339445050-29941-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 16:04 -0400, Don Zickus wrote:
> A bunch of bugzillas have complained how noisy the nmi_watchdog is during
> boot-up especially with its expected failure cases (like virt and bios
> resource contention).
[]
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
[]
> @@ -390,11 +397,23 @@ static int watchdog_nmi_enable(int cpu)
[]
>  	if (!IS_ERR(event)) {
> -		pr_info("enabled, takes one hw-pmu counter.\n");
> +		/* only print for cpu0 or different than cpu0 */
> +		if (cpu == 0 || cpu0_err) {
> +			pr_info("enabled on all CPUs, permanently consumes ");
> +			pr_cont("one hw-PMU counter.\n");

Don't worry about formats exceeding 80 column please.
Don't break up pr_info into multiple bits either.

			pr_info("enabled on all cpus, permanently consumes one hw-PMU counter\n");


