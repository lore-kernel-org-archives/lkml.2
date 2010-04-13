Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0DMSUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:20:13 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53876 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0DMSUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:20:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ks6g0c2TxBAxtp8vXhMBVs14eKn7/WYfWXBypsE+Xw61ESrOK1N1Qz/dOtJVUlVBIt
         /yjkn0iFWdbQL7N/BsXPthN2heWzNGhwDaNEjl5SYJDkk9GUVsTERWd1uF14CygtxR/q
         MwdPNa0nm/vEXuu48Xi8MqkBK6BRPoXvxzFIc=
Date: Tue, 13 Apr 2010 20:22:48 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33.2 does not boot on Atom?
Message-ID: <20100413182248.GA8468@linux-m68k.org>
References: <20100406205509.GA12034@linux-m68k.org> <20100412061604.GB31112@kroah.com> <20100413090952.GA17227@linux-m68k.org> <20100413132802.GC15247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413132802.GC15247@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 06:28:02AM -0700, Greg KH wrote:
> On Tue, Apr 13, 2010 at 11:09:52AM +0200, Richard Zidlicky wrote:
> > On Sun, Apr 11, 2010 at 11:16:05PM -0700, Greg KH wrote:
> > > On Tue, Apr 06, 2010 at 10:55:09PM +0200, Richard Zidlicky wrote:
> > > > Hi,
> > > > 
> > > > I have been compiling my own kernels since ages and switched from 2.6.32.8 to 
> > > > 2.6.33.2 now.
> > > > Same procedure like allways - copied .config to new buildtree, make menuconfig
> > > > (almost nothing changed in config), installed the new kernel on 2 machines.
> > > 
> > > Oops, that's the problem, you need to do 'make oldconfig' to ensure you
> > > didn't miss anything, and to adjust any new defaults.
> > 
> > I can confirm that "make oldconfig" does not fix the problem.
> > 
> > Grub appears to load the kernel (at least it does not come back with an error as it otherwise
> > would), cursor in the topleft corner and absolutely no activity. 
> > no reaction to ctrl-alt-del or magic keys. For all other kernels I would see at least the
> > "uncompressing kerne.." message, not here.
> 
> Try asking on a Fedora kernel list as this might just be a config issue
> with the way modesetting is set up.

it is a clean kernel.org kernel, with early printk and I tried playing with 
various (no)rhgb noquiet options just to be sure. So this does really appear to
be something that happens in the earliest bootstages before uncompressing and
can not think how it could be Fedora's fault - it does not get anywhere close
to touching the initramd image.
The only way I can proceed is try some kind of bisecting.. real bisect won't
work as the wlan connection is painfully slow with the only working kernel
taht I have installed on that computer.

Btw I have filled a Fedora bug against a 2.6.32.11-fedora kernel with broken
kms but afaics this appears to be totally unrelated.

Richard
