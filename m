Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab2CLSLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:11:14 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:53938 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab2CLSLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:11:13 -0400
Date: Mon, 12 Mar 2012 19:10:47 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Mark A. Grondona" <mgrondona@llnl.gov>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120312181047.GB8214@aftab>
References: <20120308215716.GA5925@aftab>
 <4F59DC38.5080104@redhat.com>
 <20120309143806.GA11962@aftab>
 <4F5A329A.70702@redhat.com>
 <20120309184733.GB13745@aftab>
 <4F5A5E2D.4090408@redhat.com>
 <20120311113411.GB29175@aftab>
 <4F5C9B6C.2080904@redhat.com>
 <20120312163911.GC7255@aftab>
 <3908561D78D1C84285E8C5FCA982C28F15B61A34@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F15B61A34@ORSMSX103.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 05:03:47PM +0000, Luck, Tony wrote:
> > Err, the fact that you have UE counters doesn't have anything to do with
> > the request that you want to panic on an UE. Especially if conservative
> > systems would panic on the first UE anyway without asking software.
> 
> We have some UE events for which even a conservative system might
> think it reasonable to defer the panic (e.g. patrol scrub on a "free" page).

Right, and in that case you don't need an UE counter because it won't go
higher than 1, would it?

What my thought is, is that if the system panics on UE unconditionally
anyway (either by sw or a hw method), then you don't need to enable
panic_on_ue in edac because it does so anyway, and, as a result, you
don't need UE counters at all. So, in that case, you could "state" in
the driver that you don't want to init the UE counters because you're
not going to use them, no?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
