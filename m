Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1FHVil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:38:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab1FHVik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:38:40 -0400
Date: Wed, 8 Jun 2011 14:38:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nils Carlson <nils.carlson@ericsson.com>
Cc: <clemens@ladisch.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix periodic-emulation in HPET for delayed interrupts
Message-Id: <20110608143801.f494fa3e.akpm@linux-foundation.org>
In-Reply-To: <1306929530-23771-1-git-send-email-nils.carlson@ericsson.com>
References: <1306929530-23771-1-git-send-email-nils.carlson@ericsson.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011 13:58:50 +0200
Nils Carlson <nils.carlson@ericsson.com> wrote:

> When interrupts are delayed due to interrupt masking or due
> to other interrupts being serviced the HPET periodic-emuation
> would fail. This happened because given an interval t and
> a time for the current interrupt m we would compute the next
> time as t + m. This works until we are delayed for > t, in
> which case we would be writing a new value which is in fact
> in the past.
> 
> This can be solved by computing the next time instead as
> (k * t) + m where k is large enough to be in the future.
> The exact computation of k is described in a comment to
> the code.
>
> ...
>
> +		/* The time for the next interrupt would logically be t + m,
> +		 * however, if we are very unlucky and the interrupt is delayed
> +		 * for longer than t then we will completely miss the next
> +		 * interrupt if we set t + m and an application will hang.

Strange.  Normally when hardware generates an interrupt it doesn't get
"missed".  It just sits there pending until the CPU accepts it.

What exactly causes this interrupt to be "delayed"?  Are you referring
to the CPU disabling local interrupts for too long, or something else?

And why does this delay cause the interrupt to be completely missed?

IOW, is the hpet hardware as busted as it sounds? ;)

And how serious is this bug?  Can the fix be delayed until 3.1, or is it
needed in 3.0?  2.6.x.y?
