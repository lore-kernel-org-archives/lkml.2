Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1FFSP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:15:28 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:13321
	"EHLO CH1EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753712Ab1FFSPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:15:22 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 6 Jun 2011 13:15:16 -0500
From: Scott Wood <scottwood@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Timur Tabi <timur@freescale.com>, <kumar.gala@freescale.com>,
        <linux-kernel@vger.kernel.org>, <akpm@kernel.org>,
        <linux-console@vger.kernel.org>, <greg@kroah.com>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
Message-ID: <20110606131516.69b9f361@schlenkerla.am.freescale.net>
In-Reply-To: <201106061753.10154.arnd@arndb.de>
References: <1306953337-15698-1-git-send-email-timur@freescale.com>
	<201106031728.43707.arnd@arndb.de>
	<20110603112213.4f4d1b4e@schlenkerla.am.freescale.net>
	<201106061753.10154.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011 17:53:09 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Friday 03 June 2011, Scott Wood wrote:
> > On Fri, 3 Jun 2011 17:28:43 +0200
> > Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > > On Thursday 02 June 2011, Scott Wood wrote:
> > > > I wanted to have the hypervisor take an update dtb (we already have special
> > > > meta-properties for things like deletion as part of the hv config
> > > > mechanism).  But others on the project wanted to keep it simple, and so
> > > > get/set property it was. :-/
> > > > 
> > > > It's unlikely to change at this point without a real need.
> > > > 
> > > > As for a filesystem interface, it's not a good match either. 
> > > > You can't iterate over anything to read out the full tree from the hv.
> > > 
> > > kexec iterates over /proc/device-tree to create a dts blob.
> > 
> > That's irrelevant, because we're not talking about that device tree.  We're
> > talking about the device tree of another hypervisor guest.
> 
> I understand that it's a different device tree. That doesn't mean we
> can't use the same tools.

The kernel does not have the same sort of access to this tree.

> > > > You can't delete anything. 
> > > 
> > > rm, rmdir
> > > 
> > > > You can't create empty nodes.
> > > 
> > > mkdir
> > 
> > I know how to operate a filesystem.  You can't do these operations *on
> > another guest's device tree through the hv interface*.
> 
> Why not?

Because the hypervisor does not support it.  It provides only getprop and
setprop.  I think you took my "you can't do that" statements to be a
statement about limitations of using a filesystem interfcae -- quite the
opposite, I was saying the hv functionality is too limited to support a
filesystem interface with normal semantics.

> > And what would be the benefit of this major restructuring and added
> > complexity?
> 
> I think it would be a slightly better abstraction, and the complexity
> is not as big as you make it sound. I'm mainly countering your statement
> that it would be a bad interface or that would not possible to do.
> 
> I'm not that opposed to having an ioctl interface for your hypervisor
> interface, but I am opposed to making design choices based on
> a bad representations of facts or not having considered the options
> that other people suggest.

I don't really see how a filesystem is a better abstraction for a wrapper
around a procedural interface.  A somewhat better argument is that ioctls
are a pain, and Linux doesn't have a better way to expose a procedural
interface, that doesn't require a wrapper program -- though as the wrapper
already exists, and the fs interface would probably be sufficiently awkward
that people would still use a wrapper, that doesn't buy us too much either.

This is not being proposed as any sort of standard kernel API, just a way
for userspace to get access to implementation-specific hcalls.
Implementation-specific backdoor is practically the definition of ioctl. :-)

I would be interested to see a concrete proposal for what this would look
like as a filesystem, though, based on the actual operations that are
available.  How would you deal with getting all the parameters in,
performing the operation, and getting the results back?  What about when
multiple processes are doing this at the same time?  What would the memcpy
hcall look like?

-Scott

