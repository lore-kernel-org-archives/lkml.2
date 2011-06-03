Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab1FCQWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:22:18 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:57328
	"EHLO CH1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751976Ab1FCQWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:22:17 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 3 Jun 2011 11:22:13 -0500
From: Scott Wood <scottwood@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Timur Tabi <timur@freescale.com>, <kumar.gala@freescale.com>,
        <linux-kernel@vger.kernel.org>, <akpm@kernel.org>,
        <linux-console@vger.kernel.org>, <greg@kroah.com>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
Message-ID: <20110603112213.4f4d1b4e@schlenkerla.am.freescale.net>
In-Reply-To: <201106031728.43707.arnd@arndb.de>
References: <1306953337-15698-1-git-send-email-timur@freescale.com>
	<201106012340.14237.arnd@arndb.de>
	<20110601172412.761ff799@schlenkerla.am.freescale.net>
	<201106031728.43707.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jun 2011 17:28:43 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Thursday 02 June 2011, Scott Wood wrote:
> > I wanted to have the hypervisor take an update dtb (we already have special
> > meta-properties for things like deletion as part of the hv config
> > mechanism).  But others on the project wanted to keep it simple, and so
> > get/set property it was. :-/
> > 
> > It's unlikely to change at this point without a real need.
> > 
> > As for a filesystem interface, it's not a good match either. 
> > You can't iterate over anything to read out the full tree from the hv.
> 
> kexec iterates over /proc/device-tree to create a dts blob.

That's irrelevant, because we're not talking about that device tree.  We're
talking about the device tree of another hypervisor guest.

> > You can't delete anything. 
> 
> rm, rmdir
> 
> > You can't create empty nodes.
> 
> mkdir

I know how to operate a filesystem.  You can't do these operations *on
another guest's device tree through the hv interface*.

> > There would still be other ioctls needed for starting/stopping the
> > partition, etc.
> 
> Right, although you could model them as a file interface as well.
> KVMfs is one example doing that.

And what would be the benefit of this major restructuring and added
complexity?

-Scott

