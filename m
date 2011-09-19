Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab1ISS0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:26:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56619 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab1ISS0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:26:04 -0400
Date: Mon, 19 Sep 2011 19:25:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Simon Glass <sjg@chromium.org>
Cc: "Ramirez Luna, Omar" <omar.ramirez@ti.com>, Rabin Vincent <rabin@rab.in>,
        lk <linux-kernel@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: BUG() dies silently
Message-ID: <20110919182544.GY16381@n2100.arm.linux.org.uk>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com> <CAH+eYFBSiL44CMOpgED+TAOTUH_dQMaKKu=hC3ynG0Y2nQ8ekw@mail.gmail.com> <CAB-zwWi1K8y8fHzy0hgcFPgSfhMrZNfoKQ9xuU00Y1sLg6ZBmw@mail.gmail.com> <20110919144313.GU16381@n2100.arm.linux.org.uk> <20110919165943.GX16381@n2100.arm.linux.org.uk> <CAPnjgZ1JDGt7Dzp9VrRKKApeZ9RT9oqry+UkQZwVCw1P+t9pew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPnjgZ1JDGt7Dzp9VrRKKApeZ9RT9oqry+UkQZwVCw1P+t9pew@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 11:02:08AM -0700, Simon Glass wrote:
> Hi Russell,
> 
> On Mon, Sep 19, 2011 at 9:59 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Sep 19, 2011 at 03:43:13PM +0100, Russell King - ARM Linux wrote:
> >> On Mon, Sep 19, 2011 at 09:26:49AM -0500, Ramirez Luna, Omar wrote:
> >> > Hi
> >> >
> >> > On Sat, Sep 17, 2011 at 1:07 AM, Rabin Vincent <rabin@rab.in> wrote:
> >> > > If the "Use generic BUG() handler" patch is only scheduled for the next
> >> > > merge window and not for 3.1, can this patch be merged instead for 3.1
> >> > > and -stable?  This problem is easily seen with GCC 4.6.
> >> >
> >> > I can send it for both and let the maintainers decide.
> >> >
> >> > Russell, do you give your ack?
> >>
> >> I think it's too large a change for -stable and 3.1 - let's get it into
> >> 3.2 first, and make sure no one sees any regressions there.  Then we can
> >> think about submitting it to stable once its proven itself.
> >
> > And we're seeing link failures with the patch in the kernel, so it's
> > *definitely* not stable material as it stands, even if the current code
> > is a problem for GCC 4.6.
> >
> > Regressions trump bug fixes.
> 
> Can you point me to the link failures please?

There's two emails during the last couple of months on lakml:

	3.1-rc1 link failure

	Link failures due to __bug_table in current -next

The former I looked into and came to the conclusion that the only way to
solve it is to stop using asm-generic/vmlinux.lds.S in its entirety and
go back to hand-coding ARMs vmlinux.lds file.  No one's come forward
with any better suggestion to fix this, so I'm getting very close to
having to make a decision over this.  I think I'm going to have to drop
the generic bug support for the time being.
