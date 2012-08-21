Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab2HUJQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:16:53 -0400
Received: from mail.x86-64.org ([217.9.48.20]:57265 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab2HUJQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:16:50 -0400
Date: Tue, 21 Aug 2012 11:16:39 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86, microcode, AMD: Per-family patches cache
Message-ID: <20120821091639.GA20468@aftab.osrc.amd.com>
References: <20120817143035.GA25700@aftab.osrc.amd.com>
 <5032C6DD.7060506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5032C6DD.7060506@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 04:23:09PM -0700, H. Peter Anvin wrote:
>> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode-updates-for-3.7
>>
> Hmmm... this isn't actually present on git.kernel.org, and 01/12
> is missing from your "v0" patchset on LKML (nevermind that a "v0"
> designator screams "don't apply"...)

Hmm, that's actually the tag and it is there:

http://git.kernel.org/?p=linux/kernel/git/bp/bp.git;a=tag;h=334a50f04aab22cb03c59e3ff333fe81a531a85c

I tried this locally, here's what I did:

$ git remote add bp git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git

$ git fetch bp
remote: Counting objects: 3, done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp
 * [new branch]                for-next   -> bp/for-next
 * [new branch]                master     -> bp/master
 * [new tag]                   l3-fix-for-3.5 -> l3-fix-for-3.5
 * [new tag]                   mce-fix-for-3.4 -> mce-fix-for-3.4
 * [new tag]                   microcode-fix-for-3.4 -> microcode-fix-for-3.4

$ git fetch --tags bp
remote: Counting objects: 155, done.
remote: Compressing objects: 100% (99/99), done.
remote: Total 118 (delta 92), reused 17 (delta 15)
Receiving objects: 100% (118/118), 22.42 KiB, done.
Resolving deltas: 100% (92/92), completed with 20 local objects.
>From git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp
 * [new tag]                   amd-rdmsr-cleanups-for-3.6 -> amd-rdmsr-cleanups-for-3.6
 * [new tag]                   microcode-updates-for-3.7 -> microcode-updates-for-3.7

$ git checkout -b test-merge tip/master
Checking out files: 100% (108/108), done.
Branch test-merge set up to track remote branch master from tip.
Switched to a new branch 'test-merge'

$ git merge microcode-updates-for-3.7
Auto-merging arch/x86/Kconfig
Merge made by the 'recursive' strategy.
 arch/x86/Kconfig                  |  20 +++---
 arch/x86/include/asm/microcode.h  |  10 +--
 arch/x86/kernel/microcode_amd.c   | 356 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------
 arch/x86/kernel/microcode_core.c  |  67 ++++++++++----------
 arch/x86/kernel/microcode_intel.c |   3 +-
 5 files changed, 273 insertions(+), 183 deletions(-)

So I think you need to fetch the tags with "git fetch --tags" - this is
why I had to fetch a second time above... I seem to remember this being
the case in other pull requests, btw.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
