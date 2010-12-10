Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0LJJE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 04:04:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0LJJEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 04:04:53 -0500
Date: Fri, 10 Dec 2010 10:03:24 +0100
From: Christian Glindkamp <christian.glindkamp@taskit.de>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>, linux@arm.linux.org.uk,
        costa.antonior@gmail.com, Igor Plyatov <plyatov@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux@maxim.org.za, linux-arm-kernel@lists.infradead.org,
        pgsellmann@portner-elektronik.at
Subject: Re: [PATCH] at91: Refactor Stamp9G20 and PControl G20 board file
Message-ID: <20101210090324.GB24295@taskit.de>
References: <4CFFE5A9.4040407@bluewatersys.com>
 <1291889759-12281-1-git-send-email-christian.glindkamp@taskit.de>
 <20101210033850.GC19897@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210033850.GC19897@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:36llS7m5Q5A7oRmf1ASlUMJwlSll4CTZrYYNA5PDHMj
 ho5YWyvbVQONCEVeDACDdwAfLGwjY1nZOy+GUiv0s65C0M/Qiq
 PumLRIc4homGFDTaR236oRAhn4IkZcqmZcuxDKIJRC+exlEqMI
 PkBL3gwbzbi2uR9iMzFzFgvX/4XhxMqz33fsSt/T/h3WFJ+kSO
 nq9TH6v9KsPVqhBPvuVdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-10 04:38, Jean-Christophe PLAGNIOL-VILLARD wrote:
> HI,
> 
> 	If the hardware are so near I do need to the need to create a new
> 	machine use system_rev to auto detect it will be better
> 
> 	but we need to have only one defconfig as done on rm9200
> 	it's really reduce the maintainance and allow to be sure when we
> 	compile the at91sam9g20_defconfig that we do not brake any board
> 
> 	if a board have incompatible option please the system_rev to specify
> 	them or a specific entry in the Kconfig for this board it will allow
> 	also to known this information for the maintainance

Just because it is near does not mean it is a revision of the other
board. Just compare
http://www.taskit.de/en/products/portuxg20/index.htm
http://www.taskit.de/en/products/stamp9g20/starterkit.htm

Apart from that, both boards are correctly identifiable via the machine
id for a year, respectively one and a half year for the Stamp9G20 EVB.
Why change it for sake of change?

They both have there own machine id to make it clear that these are
really different boards. I could have also submitted two board files
and maybe nobody would have noticed that share a lot, but I thought code
reuse is better so there are in the same file.

And for different carrier boards, system_rev does not make sense at all.

> 
> Best Regards,
> J.
> On 11:15 Thu 09 Dec     , Christian Glindkamp wrote:
> > As PControl G20 is a carrier board for the Stamp9G20 SoM, some code can
> > be shared. Therefore board-stamp9g20.c is refactored to allow reusing the
> > SoM initialization and board-pcontrol-g20.c is modified to use it.
> > 
> > Signed-off-by: Christian Glindkamp <christian.glindkamp@taskit.de>
> > ---
> > 
> > How about this approach? Compile tested for PControl G20 and run time tested
> > for Stamp9G20 EVB and PortuxG20.
> > 
> > Just a side note: PortuxG20 is not a carrier board for the Stamp9G20. It just
> > shares so much with the evaluation board, that it makes sense to put them both
> > into the same file. And there is no intention to put other boards into this
> > file.
> > 
> >  arch/arm/mach-at91/Makefile                 |    2 +-
> >  arch/arm/mach-at91/board-pcontrol-g20.c     |   98 +--------------------------
> >  arch/arm/mach-at91/board-stamp9g20.c        |   82 ++++++++++++-----------
> >  arch/arm/mach-at91/include/mach/stamp9g20.h |    7 ++
> >  4 files changed, 54 insertions(+), 135 deletions(-)
> >  create mode 100644 arch/arm/mach-at91/include/mach/stamp9g20.h
