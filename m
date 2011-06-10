Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1FJL24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 07:28:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:51348 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1FJL2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 07:28:54 -0400
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>
In-Reply-To: <alpine.LSU.2.00.1106091655560.2710@sister.anvils>
References: <20110609130647.937204592@chello.nl>
	 <20110609131307.493181962@chello.nl>
	 <20110609130617.f8aca966.akpm@linux-foundation.org>
	 <20110609202707.GA28951@elte.hu> <1307652883.2497.1028.camel@laptop>
	 <20110609140714.fc9ea187.akpm@linux-foundation.org>
	 <alpine.LSU.2.00.1106091655560.2710@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Jun 2011 13:28:31 +0200
Message-ID: <1307705311.3941.118.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 16:57 -0700, Hugh Dickins wrote:
> 
> All console-related activity curently happens under spin_lock_irqsave(&console_lock). 
> This causes interrutps to be blocked for 1-2 milliseconds with vgacon, and for
> hundreds of milliseconds with fbdevs.  This results in network overruns, audio
> dropouts, dropped characters on serial ports and other such nice things.

Hmm, with these proposed patches we're actually back to that. I wonder
if fbdev is still that crappy..
