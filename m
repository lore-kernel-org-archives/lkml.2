Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab2JCWUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:20:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab2JCWUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:20:03 -0400
Date: Wed, 3 Oct 2012 15:20:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: Re: [PATCH 1/5] rapidio: fix blocking wait for discovery ready
Message-Id: <20121003152001.665c9373.akpm@linux-foundation.org>
In-Reply-To: <1349291923-22860-2-git-send-email-alexandre.bounine@idt.com>
References: <1349291923-22860-1-git-send-email-alexandre.bounine@idt.com>
	<1349291923-22860-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Oct 2012 15:18:39 -0400
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> Fix blocking wait loop in the RapidIO discovery routine to avoid warning
> dumps about stalled CPU on x86 platforms.
> 
> ...
>
> +		to_end = jiffies + CONFIG_RAPIDIO_DISC_TIMEOUT * HZ;
> +		while (time_before(jiffies, to_end)) {
> +			if (rio_enum_complete(mport))
> +				goto enum_done;
> +			schedule_timeout_uninterruptible(msecs_to_jiffies(10));

I think a simple msleep(10) would suffice here?


