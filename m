Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0GAXaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:30:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:38165 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab0GAXaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:30:13 -0400
Date: Thu, 1 Jul 2010 16:28:42 -0700
From: Greg KH <gregkh@suse.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Message-ID: <20100701232842.GE13617@suse.de>
References: <20100628154455.GA13918@suse.de>
 <1277769867.8354.531.camel@nimitz>
 <20100629115232.38BC.A69D9226@jp.fujitsu.com>
 <1277827384.8354.3413.camel@nimitz>
 <20100629180415.GB1240@suse.de>
 <20100630093251.a30ed1e0.kamezawa.hiroyu@jp.fujitsu.com>
 <20100630154755.GB12158@suse.de>
 <20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
 <4C2C08CF.4040901@austin.ibm.com>
 <20100701123057.9e5b7881.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701123057.9e5b7881.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 12:30:57PM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 30 Jun 2010 22:17:35 -0500
> Nathan Fontenot <nfont@austin.ibm.com> wrote:
> 
> > On 06/30/2010 07:31 PM, KAMEZAWA Hiroyuki wrote:
> > > On Wed, 30 Jun 2010 08:47:55 -0700
> > > Greg KH <gregkh@suse.de> wrote:
> > >>> and adding a scalable interface for large scale machines ?
> > >>> I'd like to consider something..
> > >>
> > >> Dynamically changing the layout on big memory boxes makes sense to me,
> > >> how about you?
> > >>
> > > 
> > > like this ?
> > > ==
> > > boot option:
> > > memory_sysfs_layout=compact
> > > memory_sysfs_layout=auto (default)
> > > memory_sysfs_layout=full
> > > 
> > > Considering briefly, how about this compact layout ?
> > > 
> > > /sys/devices/system/memory/:
> > >                             list, hide, show, memoryX...
> > > 
> > > list: // show available memory index list.
> > >   #cat list
> > >    0 1 2 ....10000...
> > > 
> > > show: //an interface to enable the interface.
> > >   #echo INDEX > memory_index
> > >   will create memoryINDEX diretory.
> > > 
> > > hide: //an interface to hide the interface.
> > >   #echo INDEX > memory_hide
> > >   will remove memoryINDEX sysfs directory.
> > > 
> > > 
> > > In compact mode, all memoryX interface are hidden at boot.
> > > In full mode, all memoryX interaface are shown.
> > > The Boot option just affects status at boot. If users want, he can make
> > > all memory sysfs in shown state.
> > 
> > Do we need to make something as complicated as dynamically adding and removing
> > the sysfs directories?  Why not a compact layout that just takes the files
> > that currently reside in the memoryXX dirs and move them up to the memory
> > directory. This would be state (which should probably be split into an
> > 'online' and 'offline' file), removable, phys_index, and phys_device.
> > 
> I've considered several patterns.
> 
> with 4096 bytes buffer of sysfs, "printting bitmap" just covers small
> amount of sections even with smart ASCII format to show contiguous range
> as a chunk. That's my concern. (and 'list' file in above example
> is impossible to impelement.)

Yes, that's my concern as well.  sysfs is "one value per file" and if
you are worried about the size of the sysfs buffer, something is wrong
with your interface.

> If I can use rmdir/mkdir interface, it's much simple rather than above "echo".
> But it seems impossible.

That's what configfs is for :)

> Because we have memory information in /proc/iomem already, I think hide/show
> interface (instead of mkdir/rmdir) is not very bad.
> 
> If you can implement highly scalable interface, please.
> I just stop dreaming and ack yours.

Why not just create your own filesystem for this, "memoryfs", where you
can do what you want and you don't have to worry about sysfs apis and
buffer sizes.

thanks,

greg k-h
