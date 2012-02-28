Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2B1P2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 10:28:10 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34139 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2B1P2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 10:28:08 -0500
Date: Tue, 28 Feb 2012 16:27:51 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, sp@numascale.com, bp@amd64.org,
        tglx@linutronix.de, daniel@numascale-asia.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/platform: Remove incorrect error message
 in x86_default_fixup_cpu_id()
Message-ID: <20120228152751.GA14647@aftab>
References: <20120224153127.GD28921@alberich.amd.com>
 <tip-d7dedbe3694bbf97b4e3409e1fa52d97a3b9f028@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-d7dedbe3694bbf97b4e3409e1fa52d97a3b9f028@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 04:07:33AM -0800, tip-bot for Andreas Herrmann wrote:
> Commit-ID:  d7dedbe3694bbf97b4e3409e1fa52d97a3b9f028
> Gitweb:     http://git.kernel.org/tip/d7dedbe3694bbf97b4e3409e1fa52d97a3b9f028
> Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
> AuthorDate: Fri, 24 Feb 2012 16:31:27 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 27 Feb 2012 10:35:47 +0100
> 
> x86/platform: Remove incorrect error message in x86_default_fixup_cpu_id()
> 
> It's only called from amd.c:srat_detect_node(). The introduced
> condition for calling the fixup code is true for all AMD
> multi-node processors, e.g. Magny-Cours and Interlagos. There we
> have 2 NUMA nodes on one socket. Thus there are cores having
> different numa-node-id but with equal phys_proc_id.
> 
> There is no point to print error messages in such a situation.
> 
> The confusing/misleading error message was introduced with
> commit 64be4c1c2428e148de6081af235e2418e6a66dda (x86: Add
> x86_init platform override to fix up NUMA core numbering).
> 
> Change the default fixup function (remove the error message),
> move the Numascale-specific condition for calling the fixup into
> the fixup-function itself and slightly adapt the comment.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> Reviewed-by: Daniel J Blueman <daniel@numascale-asia.com>
> Cc: Borislav Petkov <bp@amd64.org>
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> Cc: Steffen Persvold <sp@numascale.com>
> Link: http://lkml.kernel.org/r/20120224153127.GD28921@alberich.amd.com
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Maybe this one should be queued for x86/urgent instead and should go to
Linus soonish since it cures an issue which came in during the 3.3 merge
window with 64be4c1c2428e148de6081af235e2418e6a66dda?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
