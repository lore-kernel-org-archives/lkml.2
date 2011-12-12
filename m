Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1LLOT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:19:28 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34154 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1LLOTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:19:24 -0500
Date: Mon, 12 Dec 2011 15:19:13 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>,
        X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, MCE: Drain mcelog buffer
Message-ID: <20111212141913.GC6799@aftab>
References: <1323353332-5671-1-git-send-email-bp@amd64.org>
 <1323353332-5671-3-git-send-email-bp@amd64.org>
 <0207C53569FE594381A4F2EB66570B2A018EFB7762@orsmsx508.amr.corp.intel.com>
 <20111209182448.GA29629@gere.osrc.amd.com>
 <0207C53569FE594381A4F2EB66570B2A018EFB77AE@orsmsx508.amr.corp.intel.com>
 <20111209191819.GA17086@aftab>
 <0207C53569FE594381A4F2EB66570B2A018EFB7A7D@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0207C53569FE594381A4F2EB66570B2A018EFB7A7D@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 02:08:59PM -0800, Luck, Tony wrote:
> > Well, off the top of my head, we could probably _not_ delete the already
> > logged MCEs (bool keep arg, or similar) and when the last one registers,
> > it passes keep=false and cleans them up. And since we probably know
> > which one is the last - order is enforced by the initcalls order -
> > we're done.
> 
> Knowing when the last one has come is hard if there are modules as well
> as built-in registrants.  We could save the whole list, and deliver a
> copy of the history of the world so far to each as they register (never
> deleting anything). But that sounds odd - why should a module loaded
> 6 months after system boot expect to see everything.

Well, currently the buffer overflows at the 32th entry so something that
registers 6 months after system boot will probably see unrelated errors
from 6 months ago depending on the error rate.

> I think if we ensure that the cpu decoder gets first chance to register,
> we should be OK with giving it all the pended stuff. We can defer doing
> something more complicated until the point that someone has a real use
> case.

Agreed, and this is currently the case on AMD and Intel, AFAICT, where
the i7 or sb edac module registers. We can always change it later if
required.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
