Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1AYJL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 04:11:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:52209 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1AYJL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 04:11:27 -0500
Subject: Re: [PATCH] a patch to fix the cpu-offline-online problem caused
 by pm_idle
From: Peter Zijlstra <peterz@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <AANLkTimq3jmza-t5iL10wgLLycwdDkJ3mznLQsKHM_Kf@mail.gmail.com>
References: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
	 <1295894492.28776.470.camel@laptop>
	 <AANLkTimq3jmza-t5iL10wgLLycwdDkJ3mznLQsKHM_Kf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 10:12:16 +0100
Message-ID: <1295946736.28776.479.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 20:59 -0500, Luming Yu wrote:
> 
> > Ow god this is ugly.. pm_idle should die asap, not find it way into generic code, so NAK!
> 
> Without the ugly fix, we seem not able to fix the problem in short time.
> Or , Are you suggesting to wrap  pm_idle or similar in some generic
> code that would not disappear in foreseeable future ,

There are patches out there removing pm_idle from x86 (at least).
pm_idle is a horribly broken interface that really should die.

>  Or  Are you just
> suggesting me don't do the stuff in kerne/cpu.c, and do it in Arch
> code?

Well, as it stand only about half the architectures out there even have
a pm_idle pointer, so your patch would break the other half.

If you really need to do this, do it in arch code, but really, why is
this needed at all? The changelog failed to explain wth happens and why
this solves it.

> But..I bet It's not that wise to let CPU hot-plug code to interact
> with PM code for all Arch, so I proposed the ugly patch in generic
> code. 

Which as I mentioned breaks about half the architectures we have.
