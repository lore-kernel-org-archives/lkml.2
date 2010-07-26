Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0GZUTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:19:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538Ab0GZUTh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:19:37 -0400
MIME-Version: 1.0
In-Reply-To: <87eieqf453.fsf@pollan.anholt.net>
References: <87eieqf453.fsf@pollan.anholt.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 26 Jul 2010 13:19:14 -0700
Message-ID: <AANLkTi=T90D3KNpsVCkyLgEQK4XZ2D6YA6U7pjFNdCUK@mail.gmail.com>
Subject: Re: [git pull] drm-intel fixes since 2.6.35-rc4
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 12:13 PM, Eric Anholt <eric@anholt.net> wrote:
> The following changes since commit 815c4163b6c8ebf8152f42b0a5fd015cfdcedc78:
>
>  Linux 2.6.35-rc4 (2010-07-04 20:22:50 -0700)
>
> are available in the git repository at:
>  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

Hmm. This seems to introduce a new warning:

  drivers/gpu/drm/i915/intel_dp.c:744: warning:
‘ironlake_edp_panel_off’ defined but not used

when I pulled it.

And the warning appears to be due to a real bug: instead of calling
ironlake_edp_panel_off(), the code calls ironlake_edp_backlight_off()
twice. I assume that the _intention_ was to call both the backlight
and panel "off" routines, rather than making doubly sure that just the
backlight is off by turning it off twice.

Tssk, tssk. Sadly, I noticed this too late, so now it's pulled and pushed out.

            Linus
