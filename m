Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab1DMU6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:58:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46646 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627Ab1DMU6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:58:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: freezer: should barriers be smp ?
Date: Wed, 13 Apr 2011 22:58:17 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org
References: <BANLkTi=F-C-vwX4PGGfbkdTBw3OWL-twfg@mail.gmail.com>
In-Reply-To: <BANLkTi=F-C-vwX4PGGfbkdTBw3OWL-twfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104132258.17705.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 13, 2011, Mike Frysinger wrote:
> when we suspend/resume Blackfin SMP systems, we notice that the
> freezer code runs on multiple cores.  this is of course what you want
> -- freeze processes in parallel.  however, the code only uses non-smp
> based barriers which causes us problems ... our cores need software
> support to keep caches in sync, so our smp barriers do just that.  but
> the non-smp barriers do not, and so the frozen/thawed processes
> randomly get stuck in the wrong task state.
> 
> thinking about it, shouldnt the freezer code be using smp barriers ?

Yes, it should, but rmb() and wmb() are supposed to be SMP barriers.

Or do you mean something different?

Rafael
