Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1LITS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 14:18:29 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33218 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1LITS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 14:18:28 -0500
Date: Fri, 9 Dec 2011 20:18:19 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>,
        X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, MCE: Drain mcelog buffer
Message-ID: <20111209191819.GA17086@aftab>
References: <1323353332-5671-1-git-send-email-bp@amd64.org>
 <1323353332-5671-3-git-send-email-bp@amd64.org>
 <0207C53569FE594381A4F2EB66570B2A018EFB7762@orsmsx508.amr.corp.intel.com>
 <20111209182448.GA29629@gere.osrc.amd.com>
 <0207C53569FE594381A4F2EB66570B2A018EFB77AE@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0207C53569FE594381A4F2EB66570B2A018EFB77AE@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 10:40:10AM -0800, Luck, Tony wrote:
> > Do you see a usecase for multiple consumers?
> 
> Only a theoretical one ... we might have a cpu model specific decoder
> and an OEM supplied platform decoder - each as an independent module.

Well, off the top of my head, we could probably _not_ delete the already
logged MCEs (bool keep arg, or similar) and when the last one registers,
it passes keep=false and cleans them up. And since we probably know
which one is the last - order is enforced by the initcalls order -
we're done.

However, is the platform module using MCA at all or will it probably use
PCIe AER instead?

Also, at the time the platform module inits, we've already regged the
CPU decoders so we can go ahead and safely delete the logged MCEs.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
