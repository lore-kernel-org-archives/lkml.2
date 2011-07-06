Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1GFXdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:33:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754147Ab1GFXdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:33:49 -0400
Date: Wed, 6 Jul 2011 16:33:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@chromium.org>, Olaf Hering <olaf@aepfle.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic, vt: do not force oops output when panic_timeout
 < 0
Message-Id: <20110706163312.17c104dc.akpm@linux-foundation.org>
In-Reply-To: <20110622223039.GA13916@google.com>
References: <1308612129-12488-1-git-send-email-msb@chromium.org>
	<1308612129-12488-2-git-send-email-msb@chromium.org>
	<20110622223039.GA13916@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 15:30:39 -0700
Mandeep Singh Baines <msb@chromium.org> wrote:

> Mandeep Singh Baines (msb@chromium.org) wrote:
> > Avoid risk (of screen_unblank) and wasted cycles unblanking if
> > you intend to reboot immediately.
> > 
> 
> The original patch doesn't work. It worked fine when I tested with
> a serial port. When I disabled the serial out, my machine started to
> get wedged on a panic. I guess screen_unblank was in bust_spinlocks
> for a reason. It probably bust some spin_locks somewhere.
> 
> Below is a replacement for this patch which calls screen_unblank but
> does not force output when the panic timeout is negative (no wait).
> 
> -- >8 -- (snip)
> 
> Don't force output if you intend to reboot immediately.
> 
> This patch depends on:
> 
> http://lkml.kernel.org/r/1308612129-12488-1-git-send-email-msb@chromium.org

Please fold this into that and resend the patch series.  Please add
the needed update to Documentation/kernel-parameters.txt.
