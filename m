Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1BNNbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:31:21 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60468 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab1BNNbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:31:18 -0500
Date: Mon, 14 Feb 2011 14:32:10 +0100
From: Borislav Petkov <bp@amd64.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, Tejun Heo <tj@kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix section mismatch in reference from
 native_play_dead
Message-ID: <20110214133210.GC9137@aftab>
References: <20110203131333.GA4161@swordfish.minsk.epam.com>
 <20110214122550.GA15860@elte.hu>
 <20110214123244.GA4586@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214123244.GA4586@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 07:32:44AM -0500, Sergey Senozhatsky wrote:
> > -int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
> > +int mwait_usable(const struct cpuinfo_x86 *c)
> >  {
> >  	u32 eax, ebx, ecx, edx;
> >  
> > 
> 
> `int mwait_usable(..)' is called from `void __cpuinit select_idle_routine(...)'
> 
> I think we still have section mismatch in this case. Is it correct?

Right, but mwait_usable() is not __cpuinit anymore and __cpuinit
functions should be able to call other functions without annotation,
methinks, no?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
