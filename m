Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab1KVWcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:32:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab1KVWcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:32:15 -0500
Date: Tue, 22 Nov 2011 14:32:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: vbyravarasu@nvidia.com
Cc: torvalds@linux-foundation.org, a.zummo@towertech.it, bunk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcd: limit bin2bcd input value to lie between 0-99
Message-Id: <20111122143214.5cc8f17e.akpm@linux-foundation.org>
In-Reply-To: <1321420292-26970-1-git-send-email-vbyravarasu@nvidia.com>
References: <1321420292-26970-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 10:41:32 +0530
vbyravarasu@nvidia.com wrote:

> From: venu byravarasu <vbyravarasu@nvidia.com>
> 
> Current implementation of bin2bcd allows any value
> between 0x0 to 0xF to be stored in the most significant
> nibble of its returned value, against to the BCD limits
> of 0 - 9. Hence fixing it.
> 
> e.g. say val passed to bin2bcd is 123.
> In that case the expected value to be returned by
> this function is 0x23.
> However, without the fix being added, it would
> return 0xC3.
> 

I'm not sure that I agree.  Passing 123 to bin2bcd() is a bug, isn't
it?  We want to know about bugs so we can fix them, and quietly repairing
thngs in callees prevents that.

