Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965993Ab2FAW7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:59:36 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51857 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965935Ab2FAW7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:59:34 -0400
Date: Sat, 2 Jun 2012 01:00:01 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "Chen, Gong" <gong.chen@intel.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120601230001.GE30418@aftab.osrc.amd.com>
References: <20120531171337.GN14515@aftab.osrc.amd.com>
 <1338492772.13348.388.camel@gandalf.stny.rr.com>
 <20120531194207.GC16998@aftab.osrc.amd.com>
 <1338495092.13348.419.camel@gandalf.stny.rr.com>
 <20120531201824.GD16998@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6DE2@ORSMSX104.amr.corp.intel.com>
 <20120601091026.GC20959@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F71DB@ORSMSX104.amr.corp.intel.com>
 <20120601160050.GE28216@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F74E1@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F74E1@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 06:21:29PM +0000, Luck, Tony wrote:
> But we need to make sure that user space can actually run. That's the
> motivation behind the CMCI disable patches. Since Intel broadcasts
> CMCI to all cpus on a socket - a CMCI storm on a single socket machine
> will stop any user code from running.

Uuh, that doesn't sound good. Can't you guys make the CMCI run on one
CPU only? I mean, it is a single CECC, no need to stop all cores on the
socket for it, right?

Arguably, it'll be best if the core that sees the CECC fires the CMCI
too and the others continue on their merry way.

> I'd make one small change to what you said:
> 
> The kernel's job is to report enough error information that user space
> can make an accurate assessment of the source of the error.
> 
> I.e. "enough" is less than "as many errors as it possibly can".

Ok, I see what you mean.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
