Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab2EaTln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:41:43 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45009 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153Ab2EaTlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:41:42 -0400
Date: Thu, 31 May 2012 21:42:07 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120531194207.GC16998@aftab.osrc.amd.com>
References: <20120531121741.GB14515@aftab.osrc.amd.com>
 <4FC7788C.1070405@redhat.com>
 <20120531142229.GF14515@aftab.osrc.amd.com>
 <4FC783EA.80704@redhat.com>
 <20120531145416.GI14515@aftab.osrc.amd.com>
 <4FC787BF.3020006@redhat.com>
 <20120531151408.GJ14515@aftab.osrc.amd.com>
 <4FC798E2.4000402@redhat.com>
 <20120531171337.GN14515@aftab.osrc.amd.com>
 <1338492772.13348.388.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338492772.13348.388.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 03:32:52PM -0400, Steven Rostedt wrote:
> Just so I understand your point. You are saying things like grain that
> don't change but are different per device, should just be in some sysfs
> file somewhere, and things that are dynamic during runtime should go
> into the tracepoint.

Right, for the majority of edac drivers, grain is a static value
assigned once per driver initialization.

Then there are other drivers which report different grain per error.

Now, all I'm saying is, the static ones should report grain once when
the driver inits in dmesg or in sysfs and _not_ report grain in each
tracepoint invocation - we don't want to waste space in the ring buffer
for information which never or only very seldom changes.

For the drivers where grain is per error, they report it in the
tracepoint (and only they!) as part of the driver-specific char string.

This way all is fair and no space in the ring buffer gets wasted.

Makes sense?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
