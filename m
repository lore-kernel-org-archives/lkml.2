Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1FHUyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:54:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755487Ab1FHUyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:54:46 -0400
MIME-Version: 1.0
In-Reply-To: <1307565125.2497.1003.camel@laptop>
References: <20110606155236.GA7374@elte.hu> <1307376039.2322.164.camel@twins>
 <20110606160810.GA16636@elte.hu> <1307376771.2322.168.camel@twins>
 <20110606161749.GA22157@elte.hu> <4DED0292.1040605@die-jansens.de>
 <4DED0423.4050904@die-jansens.de> <20110606170725.GD2391@elte.hu>
 <1307380311.2322.223.camel@twins> <1307548218.3941.6.camel@twins>
 <20110608191758.GA12457@elte.hu> <BANLkTim8LY0ekPQNZasUbinKcvS78y_umw@mail.gmail.com>
 <1307565125.2497.1003.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Jun 2011 13:53:48 -0700
Message-ID: <BANLkTimPXSVSrCWQq5Jy_RWMoqg1GJYLdQ@mail.gmail.com>
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arne Jansen <lists@die-jansens.de>,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, npiggin@kernel.dk, akpm@linux-foundation.org,
        frank.rowand@am.sony.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 1:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> atomic_down() is a tad iffy, it would have to wait for an actual
> semaphore owner, which might sleep etc.. So I skipped it.

I think sleeping would be fine: the "atomic" part is about the code
the semaphore protects, not about the down() itself.

But the way you made the semantics be (caller has to disable
interrupts) for the other helpers, that doesn't really work.

                               Linus
