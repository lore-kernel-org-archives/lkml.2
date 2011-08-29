Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1H2Uo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 16:44:29 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:29248 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab1H2Uo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 16:44:28 -0400
Message-ID: <4E5BFA2A.5020900@tilera.com>
Date: Mon, 29 Aug 2011 16:44:26 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Oleg Nesterov <oleg@redhat.com>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 32/43] tile: Use set_current_blocked() and block_sigmask()
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org> <1313772419-21951-33-git-send-email-matt@console-pimps.org>
In-Reply-To: <1313772419-21951-33-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/2011 12:46 PM, Matt Fleming wrote:
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
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>
> v2 of this patch depends on "[PATCH 01/43] signal: Add block_sigmask()
> for adding sigmask to current->blocked" so they need to go through the
> same tree but this patch would benefit from some maintainer ACK's.
>
> Chris, I dropped your Acked-by because I felt this patch changed quite
> dramatically since v1 and warrants another review. I hope that's OK.
>
>
>  arch/tile/kernel/compat_signal.c |    5 +----
>  arch/tile/kernel/signal.c        |   13 ++-----------
>  2 files changed, 3 insertions(+), 15 deletions(-)
>

Still looks good to me :-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Sorry for the late reply; I was away on vacation.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

