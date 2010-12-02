Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab0LBSFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:05:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56960 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab0LBSFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:05:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=S0vt/uMiVvejX1cK3hk7HX5oSKs2dNtucm+5YiJCbV8A6pEC0vj87XCLL0bbSvwSjn
         01I/SylyeklyrGFq4aXvvFEGcdW/QlmA1I5nnbfL3TSWHHvF5+Y+QXI9Sa9mqIFUt28x
         04uMaD3KbWI7iPG3xI20Fm0Og18oz1bBokYEU=
Subject: Re: edac_core: crashes on shutdown
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101202170610.GE27263@aftab>
References: <1291201307.3029.21.camel@Tobias-Karnat>
	 <20101201123921.GA15530@a1.tnic> <1291209888.12511.11.camel@Tobias-Karnat>
	 <20101201143329.GB18074@a1.tnic> <1291225614.8646.4.camel@Tobias-Karnat>
	 <20101201193508.GA4916@liondog.tnic>
	 <1291280613.10626.22.camel@Tobias-Karnat> <20101202152106.GA29301@a1.tnic>
	 <1291306872.3898.7.camel@Tobias-Karnat>  <20101202170610.GE27263@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 19:05:01 +0100
Message-ID: <1291313101.5563.13.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 02.12.2010, 18:06 +0100 schrieb Borislav Petkov:
> On Thu, Dec 02, 2010 at 11:21:12AM -0500, Tobias Karnat wrote:
> > Am Donnerstag, den 02.12.2010, 16:21 +0100 schrieb Borislav Petkov:
> > > Well, thanks for the photos. I don't have an idea what might cause this
> > > workqueue corruption I'm seeing, all reg/unreg paths look ok. The only
> > > change that came in between .35 and .36.1 I can think of being relevant
> > > is 00740c58541b6087d78418cebca1fcb86dc6077d. You could try backing that
> > > one out to see whether it fixes the issue.
> > 
> > Yes, reverting this fixed the issue!
> > 
> > But why?
> 
> Dang, I know why. This whole ->op_state fumbling is pretty fragile and
> needs de-fragilizing :o).
> 
> Please try out the one below after re-reverting
> 00740c58541b6087d78418cebca1fcb86dc6077d (i.e., ontop of .36.1).
> 
> Thanks.

This patch fixed it.
I have rebooted five times and it does not crash anymore.

Thank you.

Btw, are there any information available regarding the NMI option?

parm:	edac_op_state:EDAC Error Reporting state: 0=Poll,1=NMI (int)

In edac.txt NMI is listed under FUTURE HARDWARE SCANNING.

-Tobias

