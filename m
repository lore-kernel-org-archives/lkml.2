Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1HXItN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:49:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64672 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab1HXItK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:49:10 -0400
Message-ID: <4E54BB02.6060404@monstr.eu>
Date: Wed, 24 Aug 2011 10:49:06 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 17/43] microblaze: Use set_current_blocked() and block_sigmask()
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org> <1313772419-21951-18-git-send-email-matt@console-pimps.org>
In-Reply-To: <1313772419-21951-18-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> As described in e6fa16ab ("signal: sigprocmask() should do
> retarget_shared_pending()") the modification of current->blocked is
> incorrect as we need to check whether the signal we're about to block
> is pending in the shared queue.
> 
> Also, use the new helper function block_sigmask() which centralises
> the code for updating current->blocked after successfully delivering a
> signal and reduces the amount of duplicate code across
> architectures. In the past some architectures got this code wrong, so
> using this helper function should stop that from happening again.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Michal Simek <monstr@monstr.eu>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
> 
> v2 of this patch depends on "[PATCH 01/43] signal: Add block_sigmask()
> for adding sigmask to current->blocked" so they need to go through the
> same tree but this patch would benefit from some maintainer ACK's.

Please add there my ACK to it too.

> 
> Michal, I dropped your Acked-by because I felt this patch changed
> quite dramatically since v1 and warrants another review. I hope that's
> OK.

That's fine. I have run LTP tests and results look good.
I will add patches 14-16/43 v2 to microblaze next branch keep them
for a while. I will propose them to Linus tree for v3.2.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
