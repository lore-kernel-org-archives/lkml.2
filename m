Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1CIWLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:11:45 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:58485 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1CIWLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:11:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Subject: Re: Kernelspace firmware loaders (was: linux-next: manual merge of the staging tree with the v4l-dvb tree)
Date: Wed, 9 Mar 2011 23:11:39 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37-gentoo-r1; KDE/4.6.1; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Ben Gamari <bgamari.foss@gmail.com>
References: <20110304163905.ed6dd630.sfr@canb.auug.org.au> <201103071751.28477.laurent.pinchart@ideasonboard.com> <201103071940.29074.liplianin@me.by>
In-Reply-To: <201103071940.29074.liplianin@me.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103092311.42936.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Igor,

On Monday 07 March 2011 18:40:28 Igor M. Liplianin wrote:
> В сообщении от 7 марта 2011 18:51:27 автор Laurent Pinchart написал:
> > On Monday 07 March 2011 17:16:58 Greg KH wrote:
> > > On Mon, Mar 07, 2011 at 03:07:36PM +0100, Laurent Pinchart wrote:
> > > > On Friday 04 March 2011 18:54:24 Mauro Carvalho Chehab wrote:
> > > > > Em 04-03-2011 14:13, Greg KH escreveu:
> > > > > > On Fri, Mar 04, 2011 at 04:39:05PM +1100, Stephen Rothwell wrote:
> > > > > >> Today's linux-next merge of the staging tree got a conflict in
> > > > > >> drivers/staging/Kconfig between commit
> > > > > >> a1256092a1e87511c977a3d0ef96151cda77e5c9 ("[media] Altera FPGA
> > > > > >> firmware download module") from the v4l-dvb tree and commit
> > > > > >> 0867b42113ec4eb8646eb361b15cbcfb741ddf5b ("staging: gma500:
> > > > > >> Intel GMA500 staging driver") from the staging tree.
> > > > > >> 
> > > > > >> I fixed it up (see below) and can carry the fix as necessary.
> > > > > > 
> > > > > > That looks correct.
> > > > > > 
> > > > > > Mauro, what is this driver and why is it added to the staging
> > > > > > tree?
> > > > > 
> > > > > This driver implements the FPGA programming logic for a firmware
> > > > > required by a DVB driver, and was proposed initially for 2.6.37
> > > > > inclusion. During the 2.6.38 development cycle, it suffered several
> > > > > revisions, based on our input at the media and lkml mailing lists,
> > > > > where Igor fixed all CodingStyle issues.
> > > > > 
> > > > > In the last minute, during 2.6.38 merge window, two developers
> > > > > (Laurent and Ben) [1] complained against adding a driver for
> > > > > loading FPGA firmware as-is. So, I decided to add it, for now, at
> > > > > staging, to avoid needing to postpone a long series of patches
> > > > > again just because of that, especially since a series of DVB-C
> > > > > devices are without support on Linux without this patch series,
> > > > > and there are very few DVB-C devices currently supported.
> > > > > 
> > > > > The Altera driver is compliant with CodingStyle, and, from my side,
> > > > > it is ok to move it to drivers/others, but it doesn't hurt to give
> > > > > some time for Ben and Laurent to propose alternative way of
> > > > > implementing the firmware request logic.
> > > > > 
> > > > > If nothing happens until 2.6.40 merge window, I think we should go
> > > > > forward and move it to the proper place.
> > > > 
> > > > What's the policy regarding firmware loaders in kernelspace vs.
> > > > userspace ? JTAG is a quite complex protocol, and we already have
> > > > lots of JTAG libraries in userspace (http://urjtag.org/ seems to be
> > > > the most popular one). We also have userspace firmware loaders (such
> > > > as fxload for the Cypress EZ USB microcontrollers). Do we need a
> > > > kernelspace JTAG implementation ?
> > > > 
> > > > > [1]
> > > > > http://www.mail-archive.com/linux-media@vger.kernel.org/msg26422.ht
> > > > > ml
> > > 
> > > If the code is just a "pass-through" to the hardware, I have no
> > > objection to the driver being in the kernel, if it needs to be in order
> > > to control the hardware properly.
> > 
> > The code implements a JTAG TAP state machine with a bit-banging
> > algorithm, including direct parallel port (LPT) access, and a bitcode
> > interpreter for
> 
> LPT access procedure included for historical reason, on early development
> stages it was used for program FPGA, then we swithed to cx23885 GPIO's.
> Developer can choose(develop) his own procedure for JTAG pins access.

Shouldn't LPT support be removed then ?

> > the files generated by the Altera FPGA proprietary development tools.
> 
> So, we used this tools. And the code is from widely opened sources.

Are we going to add support for all proprietary (and standard ?) FPGA file 
formats, with FPGA programming algorithms from multiple vendors, and TAP 
access support at various levels (not all JTAG interfaces can be controlled at 
the bit-banging level, some use higher level commands) to the kernel ? That 
would be a big amount of complex code, for very little benefit.

You could simplify this by going for a single file format across multiple 
devices from multiple vendors, such as XSVF, but I'm not sure it's a good 
solution either.

-- 
Regards,

Laurent Pinchart
