Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2HVKIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:08:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57702 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab2HVKIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:08:50 -0400
Date: Wed, 22 Aug 2012 12:08:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ido Yariv <ido@wizery.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, shai@scalemp.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/vsmp: Use hypervisor layer for
 initialization
Message-ID: <20120822100845.GB26323@gmail.com>
References: <1344445299-22142-1-git-send-email-ido@wizery.com>
 <tip-c00679af441c5be76e195deed2c76fef65a5d102@git.kernel.org>
 <20120822091141.GC23336@gmail.com>
 <20120822094648.GA14941@WorkStation.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822094648.GA14941@WorkStation.localnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ido Yariv <ido@wizery.com> wrote:

> Hi Ingo,
> 
> On Wed, Aug 22, 2012 at 11:11:41AM +0200, Ingo Molnar wrote:
> > 
> > * tip-bot for Ido Yariv <ido@wizery.com> wrote:
> > 
> > > Commit-ID:  c00679af441c5be76e195deed2c76fef65a5d102
> > > Gitweb:     http://git.kernel.org/tip/c00679af441c5be76e195deed2c76fef65a5d102
> > > Author:     Ido Yariv <ido@wizery.com>
> > > AuthorDate: Wed, 8 Aug 2012 20:01:38 +0300
> > > Committer:  Ingo Molnar <mingo@kernel.org>
> > > CommitDate: Wed, 22 Aug 2012 10:48:05 +0200
> > > 
> > > x86/vsmp: Use hypervisor layer for initialization
> > > 
> > > vSMP detection and initialization could be done by
> > > the hypervisor layer, so set it up that way.
> > > 
> > > This cleans up vSMP initialization.
> > > 
> > > Signed-off-by: Ido Yariv <ido@wizery.com>
> > > Acked-by: Shai Fultheim <shai@scalemp.com>
> > > Link: http://lkml.kernel.org/r/1344445299-22142-1-git-send-email-ido@wizery.com
> > > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > > ---
> > >  arch/x86/include/asm/hypervisor.h |    1 +
> > >  arch/x86/include/asm/setup.h      |    7 -------
> > >  arch/x86/kernel/cpu/hypervisor.c  |    1 +
> > >  arch/x86/kernel/setup.c           |    2 --
> > >  arch/x86/kernel/vsmp_64.c         |   27 +++++++++++++++++----------
> > >  5 files changed, 19 insertions(+), 19 deletions(-)
> > 
> > I had to zap this commit because it breaks the build:
> > 
> > (.init.rodata+0x4c8): undefined reference to `x86_hyper_vsmp'
> 
> I failed to notice that vsmp_64.c is only built on 64bit, so this will
> break on 32bit builds.
> 
> How about the patch below?

Please test it in the configs that matter and resubmit.

Thanks,

	Ingo
