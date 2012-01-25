Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab2AYKft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 05:35:49 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:48053 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab2AYKfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 05:35:48 -0500
Message-ID: <4F1FDAF9.90008@st.com>
Date: Wed, 25 Jan 2012 16:05:37 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christopher BLAIR <chris.blair@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] gpio/stmpe: support no-irq mode
References: <1327485189-15522-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1327485189-15522-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/2012 3:23 PM, Linus WALLEIJ wrote:
> +	if (!stmpe->pdata->no_irq) {
> +		irq = platform_get_irq(pdev, 0);
> +		if (irq < 0)
> +			return irq;
> +	}

I already acked it once, but there is another idea that i have :)
Why not allow passing no irqs in resource fields directly.

i.e. platform_get_irq() < 0 will automatically mean irqs are not supported
on platform and then we can do what we are doing in your patch. This will
remove need of another pdata field. :)

-- 
viresh
