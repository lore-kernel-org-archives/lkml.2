Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab1BRApg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:45:36 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37557 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1BRAp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:45:28 -0500
Date: Fri, 18 Feb 2011 00:45:22 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: John Linn <John.Linn@xilinx.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        catalin.marinas@arm.com, glikely@secretlab.ca, arnd@arndb.de
Subject: Re: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly macros
Message-ID: <20110218004522.GA27462@gallagher>
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com>
 <1297872716-13353-2-git-send-email-john.linn@xilinx.com>
 <1297872716-13353-3-git-send-email-john.linn@xilinx.com>
 <e58673f5-2881-4820-b5cd-99e8ef294ed5@VA3EHSMHS024.ehs.local>
 <20110217100126.GD22961@pulham.picochip.com>
 <cb015a68-c46f-400b-97ba-e1bf32e8dc2c@VA3EHSMHS019.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb015a68-c46f-400b-97ba-e1bf32e8dc2c@VA3EHSMHS019.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 05:37:47PM -0700, John Linn wrote:
> > > +static inline void arch_reset(char mode, const char *cmd)
> > > +{
> > > +	/* Add architecture specific reset processing here */
> > 
> > I think you can add cpu_reset(0) in here to try a soft reset by
> jumping
> > to the reset vector.  This should give you some reset functionality.
> 
> Hi Jamie,
> 
> How strongly do you feel that this has to be in on this initial patch
> set?
> 
> There will be many more coming later and I'd like to postpone that one
> as it's really additional
> functionality vs a bug (to me anyway).

I don't have a strong opinion on it.  If you leave it as it is so that 
arch_reset() will return then the generic ARM code will issue a printk 
to tell the user that it failed then drop into an infinite loop so it 
should be obvious that reset isn't implemented!

If reset is nontrivial then you're probably right to leave it out of 
this patch and put it into another later on.

Jamie
