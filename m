Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab0HXXGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:06:14 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:40745 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756348Ab0HXXF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:05:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BJ+4eJnPtat5krMkkQXsu3FTXX5cEfTHcBjV6vC3Vqwx2gp+PvrDA8tO3S+aizd8k7dpOFt5MmCPhrCeQ6rYjUPiB9f61kr71W2jYi+CkACSF61vjO4VERpQS2WYzCAb;
Date: Tue, 24 Aug 2010 16:05:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ivan Bulatovic <combuster@gmx.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        linux-gfx@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915/tv: After disabling the pipe, use
 wait_for_vblank_off()
Message-ID: <20100824160555.142b71fe@virtuousgeek.org>
In-Reply-To: <1282691071.2120.28.camel@localhost.localdomain>
References: <1282647815.2221.15.camel@localhost.localdomain>
	<1282662712-20493-1-git-send-email-chris@chris-wilson.co.uk>
	<1282684130.2199.25.camel@localhost.localdomain>
	<89k83a$9drtkt@azsmga001.ch.intel.com>
	<1282691071.2120.28.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 01:04:31 +0200
Ivan Bulatovic <combuster@gmx.com> wrote:

> On Tue, 2010-08-24 at 22:52 +0100, Chris Wilson wrote: 
> > On Tue, 24 Aug 2010 23:08:50 +0200, Ivan Bulatovic <combuster@gmx.com> wrote:
> > > Unfotunately I still get TV connection detected :(
> > 
> > Jesse spotted the root cause and Linus has now pushed that fix for
> > intel_wait_for_vblank() out. This is just a very minor bug in comparison.
> > Can you please test against linus/master and check that resolves the
> > spurious TV detection for you?
> > Thanks.
> > 
> > -- 
> > Chris Wilson, Intel Open Source Technology Centre
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> Spurious TV detection is still here and + I have a new problem with
> resolution in init3 when KMS fires up, it occupies only 1/3rd of the
> screen when booting.
> 
> I've tried patching the kernel I used for testing so far with that one
> liner and I've tried without patches we tried so far (git pull on a
> clean linux-git) and the symptoms are the same on both of them.
> 
> So
> - PIPE_VBLANK_INTERRUPT_STATUS) == 0,
> + PIPE_VBLANK_INTERRUPT_STATUS),
> in intel_display.c doesn't fix the issue, plus it brings a new one in my
> case.

Ugg, one step forward, two steps back.  Working on it.

-- 
Jesse Barnes, Intel Open Source Technology Center
