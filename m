Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1EVXnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 19:43:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752795Ab1EVXnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 19:43:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1105221817100.1868@natty-nar>
References: <alpine.DEB.2.02.1105221720040.2065@natty-nar> <BANLkTik9ZmQz1A0PBC4P-9XF-hB6Ywr3uQ@mail.gmail.com>
 <alpine.DEB.2.02.1105221817100.1868@natty-nar>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 22 May 2011 16:43:07 -0700
Message-ID: <BANLkTimt0ozTCSarTVwkOpvgLoW-pizMvA@mail.gmail.com>
Subject: Re: Resume Issues :Exec of NX page, Synaptics Botchup
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dtor@mail.ru>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 3:22 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>
> Now I get a different call trace for the same NX error. (And Synaptics is
> completely dead this time - not attributable to the patch, it was dumb
> luck perhaps that it wored last time.)

Just because I'm crazy, can you double-check that you applied my patch
and booted the right kernel?

Because that NX error *really* looks like the call to setup_smep(),
and the eip still very much looks like something jumped to the
"__init" region, not the "__cpuinit" region.

That backtrace really still looks like the same thing.

Oh, and you should do

-static int disable_smep __initdata;
+static int disable_smep __cpuinitdata;

too, I guess. Not that it should matter for this particular oops.

                 Linus
