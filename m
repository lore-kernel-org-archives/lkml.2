Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2IEAvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:51:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45693 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2IEAvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:51:31 -0400
Date: Wed, 5 Sep 2012 08:51:36 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] kernel/sys.c: call disable_nonboot_cpus in kernel_restart
Message-ID: <20120905005134.GM2362@S2101-09.ap.freescale.net>
References: <1346682298-13958-1-git-send-email-shawn.guo@linaro.org>
 <20120904153624.d4aaed4e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904153624.d4aaed4e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:36:24PM -0700, Andrew Morton wrote:
> On Mon,  3 Sep 2012 22:24:58 +0800
> Shawn Guo <shawn.guo@linaro.org> wrote:
> 
> > Like kernel_power_off calls disable_nonboot_cpus, we may want to have
> > kernel_restart call disable_nonboot_cpus as well.  Doing so can help
> > the machines that require boot cpu be the last alive cpu during reboot
> > to survive with kernel restart.
> 
> That does sound logical.  But the changelog is very vague and fluffy. 
> Does this patch actually fix any known problem on any known machine?
> 
Yes, it fixes one reboot issue seen on imx6q (Cortex-A9 Quad).  The
machine requires the restart routine run on primary cpu than secondary
ones.  Otherwise, the secondary core running restart routine will fail
to come to online after reboot.

-- 
Regards,
Shawn
