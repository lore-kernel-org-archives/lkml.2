Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1G2KoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:44:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946Ab1G2KoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:44:15 -0400
Date: Fri, 29 Jul 2011 12:45:37 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: gregkh@suse.de, herton.krzesinski@canonical.com, gengor@gentoo.org,
        donald.h.fry@intel.com, wey-yi.w.guy@intel.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [64/99] Revert "iwlagn: Support new 5000 microcode."
Message-ID: <20110729104537.GB2106@redhat.com>
References: <20110727247.325703029@firstfloor.org>
 <20110727214903.75C262403FF@tassilo.jf.intel.com>
 <20110728082425.GA2207@redhat.com>
 <20110728173241.GJ8006@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110728173241.GJ8006@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 07:32:41PM +0200, Andi Kleen wrote:
> > commit dd7a2509b3a79b290730a9c6a784bf03fedabb9a
> > Author: Johannes Berg <johannes.berg@intel.com>
> > Date:   Wed Apr 28 23:33:10 2010 -0700
> > 
> >     iwlagn: implement loading a new firmware file type
> > 
> > > This was reported by Gentoo, Arch, and Canonical developers as causing
> > > problems for their users:
> > > 	https://bugs.archlinux.org/task/24302
> > This is a bug about 2.6.32.
> > 
> > > 	http://bugs.gentoo.org/show_bug.cgi?id=359445
> > This looks like problem when only 8.83.5 (v5) firmware is available
> > on the system, but kernel is old and support only v2 version. This
> > should be solved by providing both old 8.24.2 (v2) and new 8.83.5 (v5)
> > firmware blobs in one package.
> > 
> > > 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/796336
> > Also 2.6.32 case.
> 
> I took them from .32. Should I drop them?
Reverting support for v5 firmware in .32 is ok.

> > There could be reasons for this change, but I do not see them here.
> 
> Can you please clearly indicate which patches I should drop and which keep?
You already decided to drop this patch for now, good.

I can observe lot's of "Received BA when not expected" when new firmware
is used, not happen with old firmware. So this commit should be picked
from upstream:

commit bfd36103ec26599557c2bd3225a1f1c9267f8fcb
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Fri Apr 29 17:51:06 2011 +0200

    iwlagn: fix "Received BA when not expected" 

However we already applied it on 2.6.35 based Fedora-14 kernel (together with
some other iwlwifi patches), and get report about regression. So I need
to figure this out. I'm going to look more at the issue, and possibly
post some backport patches, when solve problems. For now, I think we should
not do anything with iwlwifi in 2.6.35, as long nobody will report some
regression.

Stanislaw
