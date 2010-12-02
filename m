Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab0LBShp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:37:45 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59176 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab0LBShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:37:43 -0500
Date: Thu, 2 Dec 2010 19:37:24 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tobias Karnat <tobias.karnat@googlemail.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101202183724.GH27263@aftab>
References: <20101201123921.GA15530@a1.tnic>
 <1291209888.12511.11.camel@Tobias-Karnat>
 <20101201143329.GB18074@a1.tnic>
 <1291225614.8646.4.camel@Tobias-Karnat>
 <20101201193508.GA4916@liondog.tnic>
 <1291280613.10626.22.camel@Tobias-Karnat>
 <20101202152106.GA29301@a1.tnic>
 <1291306872.3898.7.camel@Tobias-Karnat>
 <20101202170610.GE27263@aftab>
 <1291313101.5563.13.camel@Tobias-Karnat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291313101.5563.13.camel@Tobias-Karnat>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 01:05:01PM -0500, Tobias Karnat wrote:
> This patch fixed it.
> I have rebooted five times and it does not crash anymore.
> 
> Thank you.

Thanks for testing and taking pictures :). I'll send it to Linus before
.37 is out.

> Btw, are there any information available regarding the NMI option?
> 
> parm:	edac_op_state:EDAC Error Reporting state: 0=Poll,1=NMI (int)
> 
> In edac.txt NMI is listed under FUTURE HARDWARE SCANNING.

Well, looking at <arch/x86/kernel/traps.c:mem_parity_error()> this
should already work. But it is kinda of a hack, if I'm reading Doug
correctly: http://lkml.org/lkml/2010/9/21/144

And yes, using some kind of an interrupt is much better than polling but
I don't know whether there's a single interrupt source for the error
types all edac drivers can decode and report. In the amd64_edac case,
we're piggybacking on MCE, for example. This was actually the initial
reason for 00740c58541b6087d78418cebca1fcb86dc6077d and dropping polling
from that driver.

Doug, any additions?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
