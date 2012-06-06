Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab2FFRlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:41:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58655 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab2FFRlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:41:09 -0400
Date: Wed, 6 Jun 2012 19:41:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        shai@scalemp.com, akpm@linux-foundation.org, tglx@linutronix.de,
        ido@wizery.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86/pat: Avoid contention on cpa_lock if possible
Message-ID: <20120606174104.GB2110@gmail.com>
References: <1334873492-31255-1-git-send-email-ido@wizery.com>
 <tip-d2956406fb61e15ad2b47eda823288db4996acf1@git.kernel.org>
 <1339003443.23343.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1339003443.23343.6.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2012-06-06 at 09:18 -0700, tip-bot for Shai Fultheim wrote:
> 
> > [ I absolutely hate these locking patterns ... yet I have no better idea. Maybe the gents on Cc: ... ]
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> Oh yuck, this is vile..
> 
> static struct static_key scale_mp_trainwreck = STATIC_KEY_INIT_FALSE;
> 
> static DEFINE_SPINLOCK(_cpa_lock);
> 
> static inline void cpa_lock(void)
> {
> 	if (static_key_false(&scale_mp_trainwreck))
> 		return;
> 
> 	spin_lock(&_cpa_lock);
> }
> 
> static inline void cpa_unlock(void)
> {
> 	if (static_key_false(&scale_mp_trainwreck))
> 		return;
> 
> 	spin_lock(&_cpa_lock);
> }
> 
> And then use cpa_{,un}lock(), and the scale-mp guys can
> static_key_slow_inc(&scale_mp_trainwreck).
> 
> [ and yes I hate those jump_label names ... but I'm not wanting
>   to go through another round of bike-shed painting. ]

ok.

Another problem this patch has is inadequate testing:

arch/x86/mm/pageattr.c:798:2: error: implicit declaration of 
function ‘is_vsmp_box’ [-Werror=implicit-function-declaration]

So I'm removing it from tip:x86/mm for now.

Thanks,

	Ingo
