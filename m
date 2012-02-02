Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2BBCkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:40:36 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45960 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab2BBCkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:40:35 -0500
Message-ID: <1328150427.2342.107.camel@work-vm>
Subject: Re: [PATCH] clocksource: Load the ACPI PM clocksource asynchronously
From: john stultz <johnstul@us.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>, arjanvandeven@gmail.com
Date: Wed, 01 Feb 2012 18:40:27 -0800
In-Reply-To: <20120130205120.652aa64f@infradead.org>
References: <20120130205120.652aa64f@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020202-7282-0000-0000-00000621532C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 20:51 -0800, Arjan van de Ven wrote:
> From ef4b0d23878277dfd75828f13353e605aae2937f Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, 30 Jan 2012 20:23:30 -0800
> Subject: [PATCH] clocksource: Load the ACPI PM clocksource asynchronously
> 
> The ACPI clocksource takes quite some time to initialize,
> and this increases the boot time of the kernel for a
> double digit percentage. This while almost all modern
> systems will be using the HPET already anyway.
> 
> This patch turns the clocksource loading into an asynchronous
> operation; which means it won't hold up the boot while
> still becoming available normally.
> 
> To make this work well, an udelay() had to be turned into an
> usleep_range() so that on UP systems, we yield the CPU to
> regular boot tasks instead of spinning.
> 
> CC: John Stultz <johnstul@us.ibm.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Len Brown <lenb@kernel.org>
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


Looks good to me. I've gone ahead and queued it

thanks
-john


