Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab2H0OTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 10:19:03 -0400
Received: from mail.x86-64.org ([217.9.48.20]:59831 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab2H0OS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 10:18:59 -0400
Date: Mon, 27 Aug 2012 16:18:45 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, tony.luck@intel.com,
        bp@amd64.org, gong.chen@linux.intel.com, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lcm@us.ibm.com, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/mce: Pack boolean MCE boot flags into a structure
Message-ID: <20120827141845.GB27979@aftab.osrc.amd.com>
References: <20120827112503.10313.62594.stgit@localhost.localdomain>
 <20120827135859.GY16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827135859.GY16230@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 03:58:59PM +0200, Andi Kleen wrote:
> On Mon, Aug 27, 2012 at 04:55:03PM +0530, Naveen N. Rao wrote:
> > Many MCE boot flags are boolean in nature, but are declared as integers
> > currently. We can pack these into a bitfield to save some space.
> 
> Note that this doesn't necessarily save anything because it needs more
> code to access, and accesses are more common than the flag
> 
> 	cmpl  $0,foo(%rip)            7 bytes
>         testl $1,foo(%rip)           10 bytes

I got 7 bytes:

12e9:       f6 05 00 00 00 00 02    testb  $0x2,0x0(%rip)        # 12f0 <mce_start_timer.isra.18+0x30>

vs the old:

1654:       83 3d 00 00 00 00 00    cmpl   $0x0,0x0(%rip)        # 165b <mce_start_timer.clone.15+0x37>

also 7 bytes.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
