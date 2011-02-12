Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1BLOrZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 09:47:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57960 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1BLOrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 09:47:21 -0500
Date: Sat, 12 Feb 2011 14:46:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        catalin.marinas@arm.com, will.deacon@arm.com,
        Jamie Iles <jamie.iles@picochip.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] ARM: Add cpu power management notifiers
Message-ID: <20110212144617.GJ15616@n2100.arm.linux.org.uk>
References: <1297373487-23902-1-git-send-email-ccross@android.com> <1297373487-23902-2-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297373487-23902-2-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 01:31:25PM -0800, Colin Cross wrote:
> +int cpu_pm_enter(void)
> +{
> +	int nr_calls;
> +	int ret;
> +
> +	spin_lock(&idle_notifier_lock);
> +	ret = __idle_notify(CPU_PM_ENTER, -1, &nr_calls);
> +	if (ret) {
> +		__idle_notify(CPU_PM_ENTER_FAILED, nr_calls - 1, NULL);
> +		spin_unlock(&idle_notifier_lock);
> +		return ret;
> +	}
> +	spin_unlock(&idle_notifier_lock);
> +
> +	return 0;

Wouldn't:

	spin_lock(&idle_notifier_lock);
	ret = __idle_notify(CPU_PM_ENTER, -1, &nr_calls);
	if (ret)
		__idle_notify(CPU_PM_ENTER_FAILED, nr_calls - 1, NULL);
	spin_unlock(&idle_notifier_lock);

	return ret;

be easier reading?
