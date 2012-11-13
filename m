Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab2KMGdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:33:36 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47382 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750779Ab2KMGdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:33:35 -0500
Message-ID: <1352788416.24230.6.camel@joe-AO722>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
From: Joe Perches <joe@perches.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Date: Mon, 12 Nov 2012 22:33:36 -0800
In-Reply-To: <1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-12 at 14:03 -0800, Jacob Pan wrote:
> Intel PowerClamp driver performs synchronized idle injection across
> all online CPUs. The goal is to maintain a given package level C-state
> ratio.

style trivia:

[]

> diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
[]
> +
> +/* #define DEBUG */
> +

Adding this #define before any #include

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

> +#include <linux/module.h>
> +#include <linux/kernel.h>

[]

> +static int window_size_set(const char *arg, const struct kernel_param *kp)
> +{
[]
> +	if (new_window_size >= 10 || new_window_size < 2) {
> +		pr_err("PowerClamp: invalid window size %lu, between 2-10\n",
> +			new_window_size);

Means there's no need for "PowerClamp: " prefixes with pr_fmt

		pr_err("invalid window size %lu...

and all the other pr_<level> uses get prefixed too.

> +static u64 pkg_state_counter(void)
> +{
> +	u64 val;
> +	u64 count = 0;
> +
> +	static int skip_c2;
> +	static int skip_c3;
> +	static int skip_c6;
> +	static int skip_c7;

bool?


