Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1EOUHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 16:07:18 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:47323 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751378Ab1EOUHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 16:07:17 -0400
Date: Sun, 15 May 2011 22:06:54 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: getter PTRACE_GETSIGINFO should not modify anything  [Re: [PATCH
 11/11] ptrace: implement group stop notification for ptracer]
Message-ID: <20110515200654.GA32659@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <20110515140232.GB31855@host1.jankratochvil.net>
 <20110515142827.GF23665@htj.dyndns.org>
 <20110515171748.GA25216@host1.jankratochvil.net>
 <20110515172811.GM23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515172811.GM23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 May 2011 19:28:11 +0200, Tejun Heo wrote:
> It's a balancing act.  The primary goal is to make it _functional_ as
> the current ptrace is outright broken in many places.  The second, at
> least for me, is not deviating from the current behavior too much
> unless required by the first goal or not doing so is extremely silly.

You are introducing new API which requires new codepaths in every
debugger-like program using it.  I do not find the "not deviating" reason as
valid for making the _new_ API parts needlessly imperfect.  Otherwise in the
next step we will want to fix the new imperfect parts and - there will be
three APIs that time to be supported in each debugger-like program depending
on how old kernel versions the debugger wants to support.


> After all, this is a pretty low level API which only a handful are
> gonna use.

People are now rather directed on #gdb@freenode to use gdb instead of dealing
with ptrace when coding various monitoring/debugging helpers.  While sure
ptrace is not a mainstream syscall I would find great making it more easy.


Sure the changes should be still small - I do not ask for making unrelated new
changes; just making the already needed changes perfect in their scope.


Thanks,
Jan
