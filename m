Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab2GQPsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:48:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:45318 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab2GQPsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:48:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="123493298"
Date: Tue, 17 Jul 2012 17:05:40 +0100
From: Alan Cox <alan@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20120717170540.2d457362@bob.linux.org.uk>
In-Reply-To: <20120717154529.GD16283@kroah.com>
References: <20120717134506.3f3f0614ad1d5193689de334@canb.auug.org.au>
	<20120717154529.GD16283@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012 08:45:29 -0700
Greg KH <greg@kroah.com> wrote:

> On Tue, Jul 17, 2012 at 01:45:06PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > After merging the tty tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > drivers/tty/tty_ioctl.c: In function 'set_sgflags':
> > drivers/tty/tty_ioctl.c:741:9: error: request for member 'c_iflag'
> > in something not a structure or union
> > drivers/tty/tty_ioctl.c:742:9: error: request for member 'c_oflag'
> > in something not a structure or union
> > drivers/tty/tty_ioctl.c:743:9: error: request for member 'c_lflag'
> > in something not a structure or union
> > drivers/tty/tty_ioctl.c:745:10: error: request for member 'c_iflag'
> > in something not a structure or union
> > drivers/tty/tty_ioctl.c:746:10: error: request for member 'c_lflag'
> > in something not a structure or union
> > drivers/tty/tty_ioctl.c:749:10: error: request for member 'c_lflag'
> > in something not a structure or union
> > drivers/tty/tty_ioctl.c:753:10: error: request for member 'c_oflag'
> > in something not a structure or union
> > drivers/tty/tty_ioctl.c:756:10: error: request for member 'c_iflag'
> > in something not a structure or union
> > drivers/tty/tty_ioctl.c:757:10: error: request for member 'c_lflag'
> > in something not a structure or union
> > drivers/tty/tty_ioctl.c:759:15: error: request for member 'c_lflag'
> > in something not a structure or union
> > drivers/tty/tty_ioctl.c:760:10: error: request for member 'c_cc' in
> > something not a structure or union drivers/tty/tty_ioctl.c:761:10:
> > error: request for member 'c_cc' in something not a structure or
> > union
> > 
> > Caused by commit adc8d746caa6 ("tty: move the termios object into
> > the tty").  Did anyone build test this?  :-(
> 
> It builds here for me just fine, this is odd.

Had me confused for a bit but while I couldn't find a config to test it
I could find the bug 8)

Alan
