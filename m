Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1F2Mv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:51:27 -0400
Received: from bar.sig21.net ([80.81.252.164]:56868 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab1F2MvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:51:23 -0400
Date: Wed, 29 Jun 2011 14:51:17 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: missing compat-ioctl for CDROM_DRIVE_STATUS + FDGETPRM
Message-ID: <20110629125117.GA5739@sig21.net>
References: <20110617090424.GA19345@sig21.net>
 <201106171502.39445.arnd@arndb.de>
 <20110629113834.GA4227@sig21.net>
 <201106291430.43102.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106291430.43102.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.646,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 02:30:42PM +0200, Arnd Bergmann wrote:
> On Wednesday 29 June 2011, Johannes Stezenbach wrote:
> > Sorry for very slow reply.  I think qemu's use of these ioctls
> > to probe if the device is a cdrom or floppy is valid, so instead
> > of adding a stat() call to check for block device in qemu, I think
> > it is better to silence the warning in the kernel.
> 
> Well, correct or not, it will keep causing annoying messages on
> old kernels, so why not do both?

OK, I'll send a patch for qemu, too.

> > Do I get it right that just adding two IGNORE_IOCTL() to
> > the ioctl_pointer array in linux/fs/compat_ioctl.c is sufficient,
> > like in commit 3f001711?
> 
> Yes.
> 
> > I.e. these ioctls are handled for block devices earlier
> > in compat_sys_ioctl()?
> 
> Right. We always first ask the driver, and then search the lookup table
> when the driver does not know how to handle it in compat mode.

Good, I'll send a patch soon.


Thanks,
Johannes
