Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab2EYTWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 15:22:19 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37603 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab2EYTWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 15:22:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not recognized
Date: Fri, 25 May 2012 21:27:21 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: James Bottomley <jejbbe@hansenpartnership.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Miller <davem@davemloft.net>, mroos@linux.ee,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.1205251034190.1907-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1205251034190.1907-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205252127.21436.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 25, 2012, Alan Stern wrote:
> On Fri, 25 May 2012, James Bottomley wrote:
> 
> > > > This is actually looks wrong: it works if SCSI is built in, but it's a
> > > > nop if SCSI is a module (the nop function is gated by the else clause of
> > > > #ifdef CONFIG_SCSI)
> > > > 
> > > > Rafael, you added this not via the SCSI tree,
> > > 
> > > That's correct, it was committed directly by Linus.
> > > 
> > > > is that the intention?
> > > 
> > > Pretty much it is.
> > > 
> > > The code snippet is slightly out of context and it is a part of the
> > > software_resume() routine, which is only called when the kernel's built-in
> > > image reading code checks whether or not the image is present.  It won't
> > > work anyway if SCSI is not built in.
> > 
> > I don't understand this.
> > 
> > Why would it make a difference whether SCSI is modular at hybernation
> > resume time?  The reason it makes a difference at boot time is because
> > there's no initrd to wait for the scans and mount the root if we're not
> > modular, so the init path has to do it.  However, when resuming an
> > image, the module is already loaded into that image, so there should be
> > no difference at all between steps taken in the modular and non-modular
> > cases.
> 
> I think Rafael is referring to the boot kernel -- the one that reads in
> the hibernation image initially.

That's correct.

> Whether or not the boot kernel can have modular drivers isn't clear to me;

It can, but then the code in question is irrelevant and the resume has to
be triggered in a different way.  For example, by writing to
/sys/power/resume from the initrd boot scripts.

> I don't know when the check for a valid image in the swap area is carried
> out in relation to starting up the initramfs task.

This particular one is carried out before the initrd is loaded.

Thanks,
Rafael
