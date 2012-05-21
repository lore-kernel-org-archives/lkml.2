Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab2EUPXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:23:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34689 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2EUPXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:23:53 -0400
Date: Mon, 21 May 2012 17:23:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vlad Zolotarov <vlad@scalemp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, Shai@scalemp.com,
        ido@wizery.com
Subject: Re: [PATCH v4 0/2] Move x86_cpu_to_apicid to the __read_mostly
 section
Message-ID: <20120521152345.GC7068@gmail.com>
References: <1744141.b5asW8k6jC@vlad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1744141.b5asW8k6jC@vlad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vlad Zolotarov <vlad@scalemp.com> wrote:

> Pls., consider applying this patch series.
> It contains the following changes:
>  - Adds two new macros DEFINE_EARLY_PER_CPU_READ_MOSTLY() and
>    DECLARE_EARLY_PER_CPU_READ_MOSTLY().
>  - Adds "read-mostly" qualifier to the following variables in smp.h:
>   - cpu_sibling_map
>   - cpu_core_map
>   - cpu_llc_shared_map
>   - cpu_llc_id
>   - cpu_number
>   - x86_cpu_to_apicid
>   - x86_bios_cpu_apicid
>   - x86_cpu_to_logical_apicid
> 
> As long as all the variables above are only written during the 
> initialization, this change is meant to prevent the false 
> sharing and improve the performance on large multiprocessor 
> systems.

Why have you resent this? The feedback I gave has not been 
addressed:

> Well, a quick tally of percpu variables on a 'make defconfig' 
> kernel would tell us one way or another?
> 
> Here there's almost 200 percpu variables active in the 64-bit 
> x86 defconfig, and a quick random sample suggests that most 
> are read-mostly.
>
> I have no fundamental prefer to either approach, but the 
> direction taken should be justified explicitly, with numbers, 
> arguments, etc. - also a short blurb somewhere in the headers 
> that explains when they should be used, so that others can be 
> aware of vSMP's special needs here.

Thanks,

	Ingo
