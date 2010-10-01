Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab0JAMVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:21:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:33047 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081Ab0JAMVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:21:47 -0400
Subject: Re: Introduce support for little endian PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, paulus@samba.org
In-Reply-To: <AANLkTikHcoccu-WGtSOSdkwU6Tw_An_VFkUcEoY==8=c@mail.gmail.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	 <AANLkTikHcoccu-WGtSOSdkwU6Tw_An_VFkUcEoY==8=c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 22:21:32 +1000
Message-ID: <1285935692.2463.84.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 07:36 -0400, Josh Boyer wrote:
> On Fri, Oct 1, 2010 at 3:05 AM, Ian Munsie <imunsie@au1.ibm.com> wrote:
> > This patch set in combination with a patched GCC, binutils, uClibc and
> > buildroot has allowed for a full proof of concept little endian environment on
> > a 440 Taishan board, which was able to successfully run busybox, OpenSSH and a
> > handful of other userspace programs without problems.
> 
> Aside from my general "uh, why?" stance, I'm very very hesitant to
> integrate anything in the kernel that doesn'.t have released patches
> on the toolchain side.

We aren't yet talking about merging that as-is, though I beleive at
least -some- of the patches have merit on their own, such as the proper
accessors for device-tree properties. At the very least, it would make
it less painful for archs like ARM to borrow code in that area and will
make it cleaner for sparse when we generalize endian annotations.

The toolchain work was done as a quick & dirty experiment. Whether some
"proper" work there will happen remains to be decided.

> Also, which uClibc?  The old and crusty uClibc that uses the horrible
> linuxthreads, or the somewhat less crusty that just switched to NPTL
> (which hasn't been verified on normal PowerPC that I recall).  Why not
> use glibc...

Because this was a proof of concept and as such, it was easier to deal
with uclibc initially to get busybox going :-)

> > This is not yet complete support for little endian PowerPC, some outstanding
> > issues that I am aware of are:
> >  * We only support 32bit PowerPC for now (and indeed, only 44x)
> >  * The vdso has not been fixed to be endian agnostic - any userspace program
> >   accessing it will get an unexpected result.
> >  * I have not touched PCI at all
> >  * Remaining device tree accesses still need to be examined to ensure they are
> >   correctly handling the endianess of the device tree.
> >  * Any other driver that uses the device tree is likely be broken for the same reason.
> >  * I've included a patch for the alignment handler, however it is as yet
> >   completely untested due to a property of the hardware I've been using for
> >   testing.
> 
> I'm not meeting to detract here, but the Kconfig should be dependent
> on && BROKEN until the above is fixed.

Right.

I think Ian wasn't clear enough on the fact that those patches aren't
meant to be merged in the next merge window :-) I told him to shoot them
to the list for review, comments and discussions, but if we decide to
move along with integrating that, there's definitely more work to do.

Cheers,
Ben.

