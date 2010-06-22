Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0FVLcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 07:32:00 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36029 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab0FVLb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 07:31:59 -0400
Date: Tue, 22 Jun 2010 20:31:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sankar P <sankar.curiosity@gmail.com>
Cc: penberg@cs.helsinki.fi, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, lrodriguez@atheros.com,
       catalin.marinas@arm.com, rnagarajan@novell.com, teheo@novell.com,
       linux-mm@kvack.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kmemleak: config-options: Default buffer size for kmemleak
Message-ID: <20100622113135.GB20140@linux-sh.org>
References: <AANLkTimb7rP0rS0OU8nan5uNEhHx_kEYL99ImZ3c8o0D@mail.gmail.com> <1277189909-16376-1-git-send-email-sankar.curiosity@gmail.com> <4C20702C.1080405@cs.helsinki.fi> <1277196403-20836-1-git-send-email-sankar.curiosity@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277196403-20836-1-git-send-email-sankar.curiosity@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 02:16:43PM +0530, Sankar P wrote:
> If we try to find the memory leaks in kernel that is
> compiled with 'make defconfig', the default buffer size
> of DEBUG_KMEMLEAK_EARLY_LOG_SIZE seem to be inadequate.
> 
> Change the buffer size from 400 to 1000,
> which is sufficient for most cases.
> 
Or you could just bump it up in your config where you seem to be hitting
this problem. The default of 400 is sufficient for most people, so
bloating it up for a corner case seems a bit premature. Perhaps
eventually we'll have no choice and have to tolerate the bloat, as we did
with LOG_BUF_SHIFT, but it's not obvious that we've hit that point with
kmemleak yet.
