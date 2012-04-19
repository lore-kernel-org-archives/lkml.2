Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2DSQDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:03:51 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:52614 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab2DSQDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:03:50 -0400
Date: Thu, 19 Apr 2012 18:03:47 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCHv2] x86/mce: Avoid reading every machine check bank
 register twice.
Message-ID: <20120419160347.GD3221@aftab.osrc.amd.com>
References: <53cdc9cc093af9e4dfd191f7e4185e50f7fc9db3.1334790229.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53cdc9cc093af9e4dfd191f7e4185e50f7fc9db3.1334790229.git.tony.luck@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 03:19:40PM -0700, Luck, Tony wrote:
> Reading machine check bank registers is slow. There is a trend of
> increasing the number of banks, and the number of cores. The main section
> of do_machine_check() is a serialized section where each cpu in turn
> checks every bank. Even on a little two socket SandyBridge-EP system
> that multiplies out as:
> 
> 	2 sockets * 8 cores * 2 hyperthreads * 20 banks = 640 MSRs
> 
> We already scan the banks in parallel in mce_no_way_out() to see if there
> is a fatal error anywhere in the system. If we build a cache of VALID
> bits during this scan, we can avoid uselessly re-reading banks that have
> no data. Note that this cache is only a hint. If the valid bit is set in a
> shared bank, all cpus that share that bank will see it during the parallel
> scan, but the first to find it in the sequential scan will (usually) clear
> the bank.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> 
> Version 2:
> 	+ mce_no_way_out() now scans all banks to build the full bitmap (instead of
> 	  breaking out early if it saw a fatal issue).
> 	+ changed name of bitmap from "hint" to "valid_banks"

Looks good.

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
