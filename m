Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab1LNQg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:36:29 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:7603 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558Ab1LNQg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:36:28 -0500
Message-ID: <4EE8D08A.9070202@tilera.com>
Date: Wed, 14 Dec 2011 11:36:26 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: roel <roel.kluin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: misplaced parens near likely
References: <4EE6815E.8090905@gmail.com>
In-Reply-To: <4EE6815E.8090905@gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 5:34 PM, roel wrote:
> Parentheses were missing.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Thanks, I'll take this into the tile tree.

> ---
>  arch/tile/lib/spinlock_32.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> This is what it should be, right?
>
> diff --git a/arch/tile/lib/spinlock_32.c b/arch/tile/lib/spinlock_32.c
> index cb0999f..b16ac49 100644
> --- a/arch/tile/lib/spinlock_32.c
> +++ b/arch/tile/lib/spinlock_32.c
> @@ -144,7 +144,7 @@ void arch_read_unlock(arch_rwlock_t *rwlock)
>  	for (;;) {
>  		__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 1);
>  		val = __insn_tns((int *)&rwlock->lock);
> -		if (likely(val & 1) == 0) {
> +		if (likely((val & 1) == 0)) {
>  			rwlock->lock = val - (1 << _RD_COUNT_SHIFT);
>  			__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 0);
>  			break;

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

