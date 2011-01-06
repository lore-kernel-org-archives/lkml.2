Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1AFUTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:19:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763Ab1AFUTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:19:22 -0500
Date: Thu, 6 Jan 2011 12:18:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Pratyush Anand <pratyush.anand@st.com>
Subject: Re: [PATCH V2] ST SPEAr: PCIE gadget suppport
Message-Id: <20110106121853.016fb990.akpm@linux-foundation.org>
In-Reply-To: <137dfad4a093ea0ac80396f5eb7fbf0c382be698.1294314772.git.viresh.kumar@st.com>
References: <137dfad4a093ea0ac80396f5eb7fbf0c382be698.1294314772.git.viresh.kumar@st.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011 17:29:10 +0530
Viresh Kumar <viresh.kumar@st.com> wrote:

> From: Pratyush Anand <pratyush.anand@st.com>
> 
> This is a configurable gadget. can be configured by sysfs interface. Any
> IP available at PCIE bus can be programmed to be used by host
> controller.It supoorts both INTX and MSI.
> By default, gadget is configured for INTX and SYSRAM1 is mapped to BAR0
> with size 0x1000
> 
> ...
>
> --- /dev/null
> +++ b/Documentation/misc-devices/spear-pcie-gadget.txt

Please recheck this documentation file - it contains a number of simple
typos.

>
> ...
>
> +	if (strict_strtoul(buf, 0, &config->requested_msi))
> +		return -EINVAL;

It doesn't matter much, but the code really should propagate the
strict_strtoul() return error code back to the caller, rather than
overwriting it with -EINVAL.

