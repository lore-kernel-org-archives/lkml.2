Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab2DWUx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:53:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2DWUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:53:24 -0400
Date: Mon, 23 Apr 2012 13:53:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikolaus Voss <n.voss@weinmann.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] drivers/rtc/rtc-m41t93.c: don't let get_time() reset
 error state
Message-Id: <20120423135322.5b9b1635.akpm@linux-foundation.org>
In-Reply-To: <201204231230.q3NCUbbP015327@gatekeeper.vosshq.de>
References: <201204231230.q3NCUbbP015327@gatekeeper.vosshq.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012 12:51:23 +0200
Nikolaus Voss <n.voss@weinmann.de> wrote:

> If the rtc reports the time might be invalid due to oscillator
> failure, this flags must not be reset by get_time() as the read
> operation doesn't make the time valid.
> 
> Instead, the flag is reset in set_time() when a valid time is
> to be written.

This is rather vague - what is/are "these flags"?  From the patch I
think you're referring to (the maddeningly undocumented)
M41T93_FLAG_ST?  If so, I'd suggest something like

: If the rtc reports the time might be invalid due to oscillator failure,
: the M41T93_FLAG_ST flag must not be reset by get_time() as the read
: operation doesn't make the time valid.
: 
: Instead, the M41T93_FLAG_ST flag is reset in set_time() when a valid time
: is to be written.

Secondly, you provided no description of the user-visible effects of
the bug.  Hence I cannot work out which kernel version(s) this patch
should be merged into.

