Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab0GZUdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:33:38 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:51588 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752131Ab0GZUdg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:33:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RJcLbu7hVp+bOaYGYlaoEWLJhDa68BqnDwzh9MO8bJWLbtP/GtUUvWfDeD/3WbhM2BTb8oisFsY3tGZVsOPikCLLpsHl4GxmOiA4Jj+4S/QPVwezxkTYDBXy+9tRoE2j;
Date: Mon, 26 Jul 2010 13:33:33 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm-intel fixes since 2.6.35-rc4
Message-ID: <20100726133333.2e540e50@virtuousgeek.org>
In-Reply-To: <AANLkTi=T90D3KNpsVCkyLgEQK4XZ2D6YA6U7pjFNdCUK@mail.gmail.com>
References: <87eieqf453.fsf@pollan.anholt.net>
	<AANLkTi=T90D3KNpsVCkyLgEQK4XZ2D6YA6U7pjFNdCUK@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jul 2010 13:19:14 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jul 26, 2010 at 12:13 PM, Eric Anholt <eric@anholt.net> wrote:
> > The following changes since commit 815c4163b6c8ebf8152f42b0a5fd015cfdcedc78:
> >
> >  Linux 2.6.35-rc4 (2010-07-04 20:22:50 -0700)
> >
> > are available in the git repository at:
> >  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus
> 
> Hmm. This seems to introduce a new warning:
> 
>   drivers/gpu/drm/i915/intel_dp.c:744: warning:
> ‘ironlake_edp_panel_off’ defined but not used
> 
> when I pulled it.
> 
> And the warning appears to be due to a real bug: instead of calling
> ironlake_edp_panel_off(), the code calls ironlake_edp_backlight_off()
> twice. I assume that the _intention_ was to call both the backlight
> and panel "off" routines, rather than making doubly sure that just the
> backlight is off by turning it off twice.
> 
> Tssk, tssk. Sadly, I noticed this too late, so now it's pulled and pushed out.

Arg.  Well at least the patch has been tested and is confirmed
working.  Fix for the warning on its way now (just going to test it to
make extra sure it still works when the panel actually gets shut off!)

-- 
Jesse Barnes, Intel Open Source Technology Center
