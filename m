Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab2GJPoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:44:24 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48260 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2GJPoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:44:23 -0400
Date: Tue, 10 Jul 2012 17:44:10 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] x86/mce: Need to let kill_proc() send signal to doomed
 process
Message-ID: <20120710154410.GA29892@aftab.osrc.amd.com>
References: <3908561D78D1C84285E8C5FCA982C28F19348DFF@ORSMSX104.amr.corp.intel.com>
 <f830ac24f491389b0246af0fb31d0546f3583380.1341866155.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f830ac24f491389b0246af0fb31d0546f3583380.1341866155.git.tony.luck@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 01:34:36PM -0700, Tony Luck wrote:
> In commit dad1743e5993f19b3d7e7bd0fb35dc45b5326626
>   x86/mce: Only restart instruction after machine check recovery if it is safe
> 
> we fixed mce_notify_process() to force a signal to the current process
> if it was not restartable (RIPV bit not set in MCG_STATUS). But doing
> it here means that the process doesn't get told the virtual address of
> the fault via siginfo_t->si_addr. This would prevent application level
> recovery from the fault.
> 
> Make a new MF_MUST_KILL flag bit for memory_failure() et. al. to use
> so that we will provide the right information with the signal.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> 
> v2: Fix brainfart where I forgot to check mi->restartable to decide whether
>     to pass in the new MF_MUST_KILL bit [Thanks Boris for spotting this!]
>     Use same style syntax !!(flags & MF_MUST_KILL) [Also from Boris]
>     Faked tests with RIPV set and not set ... and found that we need one
>     more check on MF_MUST_KILL earlier in hwpoison_user_mappings() to
>     make sure it doesn't think the clean page case is recoverable.

Ok, now it makes pretty good sense.

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
