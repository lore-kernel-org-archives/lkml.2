Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1FJOnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:43:37 -0400
Received: from service87.mimecast.com ([94.185.240.25]:36356 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752004Ab1FJOne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:43:34 -0400
Date: Fri, 10 Jun 2011 15:43:27 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-lpae tree with the arm tree
Message-ID: <20110610144326.GC18133@e102109-lin.cambridge.arm.com>
References: <20110610105255.3105eef2.sfr@canb.auug.org.au>
MIME-Version: 1.0
In-Reply-To: <20110610105255.3105eef2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Jun 2011 14:44:01.0768 (UTC) FILETIME=[D6A83E80:01CC277C]
X-MC-Unique: 111061015433002201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 01:52:55AM +0100, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-lpae tree got a conflict in
> arch/arm/mm/context.c between commit 07989b7ad63a ("Revert "ARM: 6943/1:
> mm: use TTBR1 instead of reserved context ID"") from the arm tree and
> commit 21fa7e3ea279 ("ARM: LPAE: Add context switching support") from the
> arm-lpae tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

Thanks for this. I replaced the conflicting commit (21fa7e4e ARM: LPAE:
Add context switching support) with an older version (prior to patch
6943/1 that Russell reverted). The cpu_set_reserved_ttbr0() is now
called cpu_set_asid() and does something different.

In my for-next branch I also included the patches that Russell pushed
via his tree to be able to solve the conflicts:

51b5dba Revert "ARM: 6943/1: mm: use TTBR1 instead of reserved context ID"
25194f6 Revert "ARM: 6944/1: mm: allow ASID 0 to be allocated to tasks"

and I removed from my branch:

b488121 ARM: mm: fix racy ASID rollover broadcast on SMP platforms

Hopefully there shouldn't be further conflicts in tomorrow's -next tree.

-- 
Catalin

