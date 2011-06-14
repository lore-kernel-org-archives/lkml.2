Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1FNMsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:48:55 -0400
Received: from smtp.tele.fi ([192.89.123.25]:42197 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab1FNMsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:48:53 -0400
X-Originating-Ip: [194.89.68.22]
Date: Tue, 14 Jun 2011 15:48:51 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        jeremy.fitzhardinge@citrix.com, stefano.stabellini@eu.citrix.com,
        error27@gmail.com, Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [GIT PULL] (xen) bug-fixes for 3.0-rc2: stable/bug.fixes (and
	potentially stable/vga.support)
Message-ID: <20110614124850.GQ32595@reaktio.net>
References: <20110606163841.GA19556@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606163841.GA19556@dumpdata.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 12:38:41PM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Linus,
> 
> Please git pull the two (or one) following branches:
> 
>  git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug.fixes stable/vga.support
> 
> The #stable/vga.support is based off 2.6.39 and here I am going to defer to your
> judgment whether you would be OK pulling it in or if I should defer to v3.1 with it.
> 

Hello,

If still possible, stable/vga.support branch is important for Linux 3.0,
since many people have already gotten bitten by the (accidently) missing vga text console support..

That vga text console patch only affects Xen, so it's safe to pull, even for 3.0-rc4 .. 

Thanks,

-- Pasi


> The patch adds VGA text support for the Linux kernel to boot under the Xen hypervisor.
> In the past we have been using the frame-buffer (so KMS) or serial console so it never
> occurred to me to actually look at the VGA text output (and hence the reason why I did
> not include it in the initial git pull for 3.0-rc1) - but it is still important for
> users with servers where they don't want to use KMS or Xorg - and without this
> patch they won't be able to see anything. Furthermore folks have been popping up on the
> mailing list testing 3.0-rc1 and this is the first thing they notice not working right :-(
> 
> The patch is contained within the Xen code base so the potential regression impact on
> other platforms is nill.
> 
> #stable/vga.support:
> 
>  arch/x86/xen/Makefile       |    2 +-
>  arch/x86/xen/enlighten.c    |    8 +++++
>  arch/x86/xen/vga.c          |   67 +++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/xen/xen-ops.h      |   11 +++++++
>  include/xen/interface/xen.h |   39 +++++++++++++++++++++++++
>  5 files changed, 126 insertions(+), 1 deletions(-)
> 
> Jeremy Fitzhardinge (1):
>       xen: allow enable use of VGA console on dom0
> 

