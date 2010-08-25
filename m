Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab0HYJvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:51:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57810 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0HYJvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=rFL5CwZoNnE9x3H4nhO+iIADxq2g6D7xkVtpEWtyl8TsftsEVaX4uLePc3Tgub+C42
         vi/XnuZY1aH2XfGy0L5z+ryJQ75szxbgsYY6g6SXnnnd7Jj75Nq4IPY7G7kRbl0ayXYD
         uxv1a4sfKnqEHTwBN9zBtZjlJB9ijM4yu06Iw=
From: Kan-Ru Chen <kanru@kanru.info>
To: Ivan Bulatovic <combuster@gmx.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm/i915/tv: After disabling the pipe, use wait_for_vblank_off()
In-Reply-To: <1282691196.2120.30.camel@localhost.localdomain>
References: <1282647815.2221.15.camel@localhost.localdomain> <1282662712-20493-1-git-send-email-chris@chris-wilson.co.uk> <1282684130.2199.25.camel@localhost.localdomain> <89k83a$9drtkt@azsmga001.ch.intel.com> <1282691196.2120.30.camel@localhost.localdomain>
User-Agent: Notmuch/0.3.1-61-g3791a58 (http://notmuchmail.org) Emacs/24.0.50.1 (x86_64-pc-linux-gnu)
Date: Wed, 25 Aug 2010 17:51:00 +0800
Message-ID: <87k4nfrpff.fsf@anar.kanru.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 01:06:36 +0200, Ivan Bulatovic <combuster@gmx.com> wrote:
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

Same here with my Acer 3810T, Intel GM45, the kernel was built from git pulled today.

v2.6.36-rc2-203-g502adf5

TV1 connected (normal left inverted right x axis y axis)
   848x480        30.0 +
   640x480        30.0 +
   1024x768       30.0  
   800x600        30.0  

and the fb only occupies 1/3rd of the screen, the fbset output

mode "848x480"
    geometry 848 480 1366 768 32
    timings 0 0 0 0 0 0 0
    rgba 8/16,8/8,8/0,0/0
endmode

-Kanru
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
> 
> /edit: had to remove linux-gfx from cc or mail wouldn't send otherwise

