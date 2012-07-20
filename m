Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2GTQdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:33:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58229 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2GTQdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:33:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120720121848.GA29183@aftab.osrc.amd.com>
References: <cover.1342723082.git.tony.luck@intel.com>
	<180a06f3f357cf9f78259ae443a082b14a29535b.1342723082.git.tony.luck@intel.com>
	<20120720121848.GA29183@aftab.osrc.amd.com>
Date: Fri, 20 Jul 2012 09:33:23 -0700
X-Google-Sender-Auth: -nRnrEoW1NPnpmKffKnNUAqL6Kk
Message-ID: <CA+8MBbLX_cLR1+DpjuG-D5=5YhnTy3aGS4RL1iviRYomYoveWg@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86/mce: Add quirk for instruction recovery on Sandy
 Bridge processors
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe define a default empty quirk_no_way_out() on the remaining
> families/vendors so that the compiler can optimize it away and we save
> ourselves the if-test?

Perhaps I misunderstood your suggestion. I don't see how the compiler will
manage to optimize it all away.  I just tried defining

static void quirk_no_way_out_nop(int bank, struct mce *m, struct pt_regs *regs)
{
}

and providing that as an initial value for the quirk_no_way_out
function pointer.

Then I deleted the "if (quirk_no_way_out)".

Looking at the assembly code produced, I now just have an unconditional call:

 callq  *0x9fe992(%rip)        # ffffffff81a18668 <quirk_no_way_out>


I'd think that a call through a function pointer to an empty function is
more expensive that testing whether that function pointer was NULL.

-Tony
