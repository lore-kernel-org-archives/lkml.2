Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab2C1Xyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 19:54:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49780 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905Ab2C1Xyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 19:54:39 -0400
Date: Wed, 28 Mar 2012 16:54:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the scsi tree
Message-ID: <20120328235435.GB17212@kroah.com>
References: <20120326121719.dc4c2b1faca5cf12c8d76d93@canb.auug.org.au>
 <1332748641.2836.8.camel@dabdike>
 <20120326140721.GA19827@kroah.com>
 <20120327221721.GA3233@p183.telecom.by>
 <20120327222216.GB469@kroah.com>
 <20120327223510.GB3233@p183.telecom.by>
 <20120327223939.GC3233@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327223939.GC3233@p183.telecom.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 01:39:39AM +0300, Alexey Dobriyan wrote:
> On Wed, Mar 28, 2012 at 01:35:10AM +0300, Alexey Dobriyan wrote:
> > On Tue, Mar 27, 2012 at 03:22:16PM -0700, Greg KH wrote:
> 
> > > > The amount of code once removed from staging prevented me from doing
> > > > any work on them.
> > > > 
> > > > Looking at staging ->read_proc users this is going to be a problem for
> > > > its removal. :-(
> > > 
> > > Why?
> > 
> > Because if staging does count, I can't remove the interface
> > without breaking allmodconfig and it would take forever to convert
> > staging stuff. I don't have energy to do it anymore.
> > Mainline still have several _hard_ ->read_proc conversions.
> > I've tried several times and failed.
> > 
> > If staging doesn't count, I will break allmodconfig and all those nasty
> > emails will show up anyway implying that staging does count.
> 
> It's comparable to what mainline has besides staging.
> I'm talking about this.
> 
> $ grep -e read_proc -w -n -r drivers/staging/
> drivers/staging/comedi/proc.c:92:               comedi_proc->read_proc = comedi_read;
> drivers/staging/rtl8192u/ieee80211/ieee80211_module.c:298:      e->read_proc = show_debug_level;
> drivers/staging/serial/68360serial.c:2428:      /* .read_proc = rs_360_read_proc, */
> drivers/staging/rtl8192e/rtllib_module.c:262:   e->read_proc = show_debug_level;

Only the comedi one should probably stick around, and even then, it
really should be moved to a sysfs file or three, or even better, a
debugfs file.

> $ grep -e create_proc_read_entry -w -n -r drivers/staging/
> drivers/staging/telephony/ixj.c:7763:   create_proc_read_entry ("ixj", 0, NULL, ixj_read_proc, NULL);
> drivers/staging/ft1000/ft1000-usb/ft1000_proc.c:189:            ft1000_proc_file = create_proc_read_entry(dev->name, 0644,
> drivers/staging/ft1000/ft1000-usb/ft1000_proc.c:221:            create_proc_read_entry(dev->name, 0644,
> drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c:181:         create_proc_read_entry(dev->name, 0644, info->proc_ft1000,
> drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c:200: create_proc_read_entry(dev->name, 0644, info->proc_ft1000,
> drivers/staging/rtl8192u/r8192U_core.c:714:     e = create_proc_read_entry("stats-rx", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192u/r8192U_core.c:724:     e = create_proc_read_entry("stats-tx", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192u/r8192U_core.c:733:     e = create_proc_read_entry("stats-ap", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192u/r8192U_core.c:742:     e = create_proc_read_entry("registers", S_IFREG | S_IRUGO,
> drivers/staging/cxt1e1/sbeproc.c:325:    e = create_proc_read_entry ("info", S_IFREG | S_IRUGO,
> drivers/staging/rtl8187se/r8180_core.c:343:     e = create_proc_read_entry("stats-hw", S_IFREG | S_IRUGO,
> drivers/staging/rtl8187se/r8180_core.c:351:     e = create_proc_read_entry("stats-rx", S_IFREG | S_IRUGO,
> drivers/staging/rtl8187se/r8180_core.c:360:     e = create_proc_read_entry("stats-tx", S_IFREG | S_IRUGO,
> drivers/staging/rtl8187se/r8180_core.c:368:     e = create_proc_read_entry("registers", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:873:      e = create_proc_read_entry("stats-rx", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:881:      e = create_proc_read_entry("stats-tx", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:889:      e = create_proc_read_entry("stats-ap", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:897:      e = create_proc_read_entry("registers-0", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:903:      e = create_proc_read_entry("registers-1", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:909:      e = create_proc_read_entry("registers-2", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:915:      e = create_proc_read_entry("registers-3", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:921:      e = create_proc_read_entry("registers-4", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:927:      e = create_proc_read_entry("registers-5", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:933:      e = create_proc_read_entry("registers-6", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:939:      e = create_proc_read_entry("registers-7", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:945:      e = create_proc_read_entry("registers-8", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:951:      e = create_proc_read_entry("registers-9", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:957:      e = create_proc_read_entry("registers-a", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:963:      e = create_proc_read_entry("registers-b", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:969:      e = create_proc_read_entry("registers-c", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:975:      e = create_proc_read_entry("registers-d", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:981:      e = create_proc_read_entry("registers-e", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:987:      e = create_proc_read_entry("RF-A", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:993:      e = create_proc_read_entry("RF-B", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:999:      e = create_proc_read_entry("RF-C", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:1005:     e = create_proc_read_entry("RF-D", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:1011:     e = create_proc_read_entry("SEC-CAM-1", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:1017:     e = create_proc_read_entry("SEC-CAM-2", S_IFREG | S_IRUGO,
> drivers/staging/rtl8192e/rtl8192e/rtl_debug.c:1023:     e = create_proc_read_entry("SEC-CAM-3", S_IFREG | S_IRUGO,
> drivers/staging/wlags49_h2/wl_main.c:912:       create_proc_read_entry( "wlags", 0, NULL, scull_read_procmem, dev );


I don't understand, I thought you were talking about scsi drivers, why
list all of these?  What does your patch do?

greg k-h
