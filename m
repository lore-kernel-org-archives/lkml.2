Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab3ADDvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 22:51:07 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51268 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754187Ab3ADDvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 22:51:06 -0500
Message-ID: <1357271464.5452.31.camel@joe-AO722>
Subject: Re: [PATCH v5 3/3] PM: Introduce Intel PowerClamp Driver
From: Joe Perches <joe@perches.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Date: Thu, 03 Jan 2013 19:51:04 -0800
In-Reply-To: <1357225804-27191-4-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1357225804-27191-1-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1357225804-27191-4-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 07:10 -0800, Jacob Pan wrote:
> Intel PowerClamp driver performs synchronized idle injection across
> all online CPUs. The goal is to maintain a given package level C-state
> ratio.

[]

> +static int window_size_set(const char *arg, const struct kernel_param *kp)
> +{
> +	int ret = 0;
> +	unsigned long new_window_size;
> +
> +	ret = kstrtoul(arg, 10, &new_window_size);
> +	if (ret)
> +		goto exit_win;
> +	if (new_window_size > 10 || new_window_size < 2) {
> +		pr_err("Invalid window size %lu, between 2-10\n",
> +			new_window_size);
> +		ret = -EINVAL;
> +	}
> +
> +	window_size = new_window_size;

Possible assignment of known invalid windows size?
Maybe you should add
	goto exit;
after
	ret = -EINVAL;

or add
	new_window_size = clamp(new_window_size, 2ul, 10ul);


