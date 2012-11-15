Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993421Ab2KOMEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 07:04:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60919 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993257Ab2KOMEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:04:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC Patch v1 38/55] ARC: Low level event capture/logging
Date: Thu, 15 Nov 2012 12:04:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <201211121355.23947.arnd@arndb.de> <50A4C6B5.9010500@synopsys.com>
In-Reply-To: <50A4C6B5.9010500@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211151204.13203.arnd@arndb.de>
X-Provags-ID: V02:K0:O7CCg1G8H+sCvQWxVaAq3PcQpnJIqOClWgZc/NoEYid
 Qafl961lOJ08OmFPhwLTQ3H5Pj1hNGfaRg+CUNKhsKws12+8Tz
 Hw/Ls9jXhP2X2UceO7ZOkKL4blzIeCCIZluTdkvMu+DAAuJ6YZ
 0Dq19RkwjJZ6AcatjSvYwaowkkusxUznYlVVxxWUVYY2V51Jlt
 lDEChQGjMfInDaJm0XJMyxB/vGH6Tv8ll7oJh8hcz1MQ0hd5Pl
 9qWAfkbdHmfK++Z/vKHgqvrndfZgDO8cIq8GlT6IVJRSO1ect8
 QXDq2QCTLJnWLwcgByrZ1ZUkBy5gY5bNzW28fbdhyYyJ1SvTK7
 pK1dogaEMi1dpElGj5KA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012, Vineet Gupta wrote:
> On Monday 12 November 2012 07:25 PM, Arnd Bergmann wrote:
> > On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
> >> +EXPORT_SYMBOL(take_snap);
> >> +
> >> ...
> >> +EXPORT_SYMBOL(take_snap2);
> > Where are these functions called?
> 
> These are called from various parts of ARCH code, such as before
> handling signal or TLB flush etc.
> 
> > Shouldn't this all just be part of the perf module?
> 
> These are for low level ARCH specific event snapshotting. Maybe
> perf/ftrace already have some of these in the generic code which
> eventually call the ARCH APIs. Our current perf support is just husk of
> an implementation. Once we have the full perf / ftrace support this
> module - except for the even t capture part could just go away.
> OTOH, I've not seen much usage of this from loadable modules - so if you
> deem correct, I can even remove the export.
> 
> > If not, can you make the exports GPL-only?
> 
> Am I right in understanding that this is more related to discouraging
> non GPL modules "in general" than having to do with port itself.

Mostly yes. I understand that there are some reasons why people want
to mark symbols as generally available, e.g. for standard interfaces
that have traditionally been available to every module. My rule is
usually that any newly introduced symbols should be EXPORT_SYMBOL_GPL
by default, unless there is a (documented) reason to use EXPORT_SYMBOL
instead. This is particularly true for low-level interfaces like the
one here.

If you can just remove the export, that is probably the best solution.

On a related note, any global symbol (exported or not) should normally
have a prefix that identifies the subsystem it belongs to. A global
identifier like "take_snap" can potentially conflict with symbols in
other parts of the kernel.

	Arnd
