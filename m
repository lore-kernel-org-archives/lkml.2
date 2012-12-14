Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab2LNUMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:12:23 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57084 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab2LNUMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:12:22 -0500
Date: Sat, 15 Dec 2012 00:12:17 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, aarcange@redhat.com,
        ak@linux.intel.com, Pavel Emelyanov <xemul@parallels.com>,
        Stefani Seibold <stefani@seibold.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, criu@openvz.org, mingo@redhat.com,
        john.stultz@linaro.org, tglx@linutronix.de
Subject: Re: [CRIU] [PATCH] Add VDSO time function support for x86 32-bit
 kernel
Message-ID: <20121214201217.GE6582@moon>
References: <50CA81A4.9040702@zytor.com>
 <CALCETrWCMQys5MCbd6E_7c+Bsvph5cfkrDDm5tNpyBdgVE-YeQ@mail.gmail.com>
 <50CA85BD.7070502@zytor.com>
 <CALCETrWKDJd1T_VCRNAzD-KTtYBbmvgE_ZYvb8uN4nBUYQvkgA@mail.gmail.com>
 <8c3585bc-fc7d-4826-913c-f4581494d91d@email.android.com>
 <CALCETrX5KUiQaV7dsAFa1SYyWPjUVwh43HvbPwqPStMxqE0ctQ@mail.gmail.com>
 <50CAE485.5020608@parallels.com>
 <50CB716D.6020501@zytor.com>
 <CALCETrWazriQVbQPc8u+KFyNUaa=kJUc=jdh9w7z6rS+kWEX1w@mail.gmail.com>
 <50CB7459.7010107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CB7459.7010107@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 10:47:53AM -0800, H. Peter Anvin wrote:
> On 12/14/2012 10:44 AM, Andy Lutomirski wrote:
> >>
> >> mremap() should work.  At the same time, the code itself is not going to
> >> have any stability guarantees between kernel versions -- it obviously
> >> cannot.
> > 
> > We could guarantee that the symbols in the vdso resolve to particular
> > offsets within the vdso.  (Yes, this is ugly.)
> > 
> > Does criu support checkpointing with one version of a shared library
> > and restoring with another?  If there are no textrels (or whatever the
> > relocation type that actually modifies text as opposed to just the plt
> > or got) then, in principle, it should be doable.  Otherwise some
> > kernel help will be needed to checkpoint reliably on one kernel and
> > restore somewhere else.
> > 
> > (This isn't a regression -- it's already broken.)
> > 
> The real issue is that happens if the process is checkpointed while
> inside the vdso and now eip/rip or a stack frame points into the vdso.
> This is not impossible or even unlikely, especially on 32 bits it is
> downright likely.

I fear if there are stacked ip which point to vdso -- we simply won't
be able to restore properly if vdso internal format changed significantly
between kernel versions. (At moment we restore vdso exactly at same position
it was on checkpoint stage with same content, iirc).

	Cyrill
