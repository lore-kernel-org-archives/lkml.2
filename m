Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2EIPo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:44:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43879 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220Ab2EIPo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:44:56 -0400
Date: Wed, 9 May 2012 17:44:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ido Yariv <ido@wizery.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v4] vsmp: Fix number of CPUs when vsmp is disabled
Message-ID: <20120509154448.GD2653@gmail.com>
References: <20120509082225.GB5036@NoteStation.colubris.lan>
 <1336552121-6742-1-git-send-email-ido@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336552121-6742-1-git-send-email-ido@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ido Yariv <ido@wizery.com> wrote:

> +static void __init vsmp_cap_cpus(void)
> +{
> +	void __iomem *address;
> +	unsigned int cfg, topology, node_shift, maxcpus;
> +
> +#ifdef CONFIG_X86_VSMP
> +	/* VSMP is enabled, no need to cap cpus */
> +	return;
> +#elif defined(CONFIG_SMP)
> +	/*
> +	 * CONFIG_X86_VSMP is not configured, so limit the number CPUs to the

I suspect this will throw compiler warnings in the 
CONFIG_X86_VSMP && !CONFIG_SMP case.

Why not do something like:

static void __init vsmp_cap_cpus(void)
{
#if !defined(CONFIG_X86_VSMP) && defined(CONFIG_SMP)
   ...
#endif
}

This keeps the #ifdef complexity reasonably concentrated.

Thanks,

	Ingo
