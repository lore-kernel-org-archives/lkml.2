Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0EQFEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:04:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:55094 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0EQFEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:04:15 -0400
Date: Sun, 16 May 2010 22:06:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
Message-ID: <20100516220638.2baf315d@infradead.org>
In-Reply-To: <5adf3fee-0f7b-4039-b13f-619640cc4b88@default>
References: <1273887635-27610-1-git-send-email-venki@google.com>
	<87tyq9mqrz.fsf@basil.nowhere.org>
	<35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
	<20100515121424.38f5b389@infradead.org>
	<e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>
	<20100515224305.17a04022@infradead.org>
	<alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>
	<b7b4f345-944c-4cbc-b98a-700f915183b9@default
 alpine.LFD.2.00.1005161925480.3368@localhost.localdomain>
	<5adf3fee-0f7b-4039-b13f-619640cc4b88@default>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 May 2010 18:31:30 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> 
> It seems like the only advantages the kernel has here over
> a reasonably intelligent app is that: 1) the kernel can run
> a warp test and the app can't, and 2) the kernel can
> estimate the frequency of the TSC and the app can't.

and 3) the kernel gets thermal interrupts and the app does not
and 4) the kernel decides which power management to use when
and 5) the kernel can find out if SMI's happened, and the app cannot.
and 6) the kernel can access tsc and a per cpu offset/frequency
data atomically, without being scheduled to another CPU. The app cannot
[well it can ask the kernel to be pinned, and that's a 99.99% thing,
but still]

[snipped a bunch of twists of my argument that are not correct]


look we're not disabling ring 3 tsc. We could, but we don't.
we're just telling you that WE as kernel cannot tell you, in 
an architectural and long term (multiple kernel versions and
hardware generations) stable way, when the tsc is "usable".
Because WE know it is barely if any so. We continuously add
workarounds, calibrations and tweaks for this, and stop using it
at runtime when something smells funny and defeats our logic.

If you want to find out yourself if the tsc is good enough for you
that is one thing.... but if you want the kernel to have an official
interface for it.... the kernel has to live by that commitment.
We cannot put in that interface "oh and you need to implement the same
workarounds, scaling and offsets as the kernel does", because that's
in a huge flux, and will change from kernel version to kernel version.
The only shot you could get is some vsyscall/vdso function that gives
you a unit (but that is not easy given per cpu offset/frequency/etc..
but at least the kernel can try)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
