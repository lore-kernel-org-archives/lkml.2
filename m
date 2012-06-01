Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653Ab2FAX1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 19:27:53 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51948 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759531Ab2FAX1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 19:27:51 -0400
Date: Sat, 2 Jun 2012 01:28:18 +0200
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
Message-ID: <20120601232818.GH30418@aftab.osrc.amd.com>
References: <20120531194207.GC16998@aftab.osrc.amd.com>
 <1338495092.13348.419.camel@gandalf.stny.rr.com>
 <20120531201824.GD16998@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6DE2@ORSMSX104.amr.corp.intel.com>
 <20120601091026.GC20959@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F71DB@ORSMSX104.amr.corp.intel.com>
 <20120601160050.GE28216@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F74E1@ORSMSX104.amr.corp.intel.com>
 <20120601230001.GE30418@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F76FF@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F76FF@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 11:19:17PM +0000, Luck, Tony wrote:
> > Uuh, that doesn't sound good. Can't you guys make the CMCI run on one
> > CPU only? I mean, it is a single CECC, no need to stop all cores on the
> > socket for it, right?
> >
> > Arguably, it'll be best if the core that sees the CECC fires the CMCI
> > too and the others continue on their merry way.
> 
> That would be best ... but life is more complicated. We can get CMCI for
> some processor errors where the error will be logged in a per-core bank,
> but for some reason it is hard to have just the threads on that core see
> the CMCI. So we just use a shotgun to blast everything standing in the
> general direction of the error - so that the one (or two) cpus that can
> actually see the error will get the message.  In the normal case when
> there is a very low rate of errors, this doesn't do much harm. But it makes
> the storm situation when there are many errors a whole lot worse (20x
> worse for Westmere with 10 cores * 2 threads).

Ok, this explains the whole deal behind throttling the CMCI and
temporarily polling the MCA registers.

This explanation could very well go into the commit message when you
guys are done testing the patch from tglx.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
