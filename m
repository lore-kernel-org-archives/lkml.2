Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0GADtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 23:49:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46213 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0GADtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 23:49:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 1 Jul 2010 12:30:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Greg KH <gregkh@suse.de>, Dave Hansen <dave@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Message-Id: <20100701123057.9e5b7881.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C2C08CF.4040901@austin.ibm.com>
References: <20100628154455.GA13918@suse.de>
	<1277769867.8354.531.camel@nimitz>
	<20100629115232.38BC.A69D9226@jp.fujitsu.com>
	<1277827384.8354.3413.camel@nimitz>
	<20100629180415.GB1240@suse.de>
	<20100630093251.a30ed1e0.kamezawa.hiroyu@jp.fujitsu.com>
	<20100630154755.GB12158@suse.de>
	<20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
	<4C2C08CF.4040901@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 22:17:35 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> On 06/30/2010 07:31 PM, KAMEZAWA Hiroyuki wrote:
> > On Wed, 30 Jun 2010 08:47:55 -0700
> > Greg KH <gregkh@suse.de> wrote:
> >>> and adding a scalable interface for large scale machines ?
> >>> I'd like to consider something..
> >>
> >> Dynamically changing the layout on big memory boxes makes sense to me,
> >> how about you?
> >>
> > 
> > like this ?
> > ==
> > boot option:
> > memory_sysfs_layout=compact
> > memory_sysfs_layout=auto (default)
> > memory_sysfs_layout=full
> > 
> > Considering briefly, how about this compact layout ?
> > 
> > /sys/devices/system/memory/:
> >                             list, hide, show, memoryX...
> > 
> > list: // show available memory index list.
> >   #cat list
> >    0 1 2 ....10000...
> > 
> > show: //an interface to enable the interface.
> >   #echo INDEX > memory_index
> >   will create memoryINDEX diretory.
> > 
> > hide: //an interface to hide the interface.
> >   #echo INDEX > memory_hide
> >   will remove memoryINDEX sysfs directory.
> > 
> > 
> > In compact mode, all memoryX interface are hidden at boot.
> > In full mode, all memoryX interaface are shown.
> > The Boot option just affects status at boot. If users want, he can make
> > all memory sysfs in shown state.
> 
> Do we need to make something as complicated as dynamically adding and removing
> the sysfs directories?  Why not a compact layout that just takes the files
> that currently reside in the memoryXX dirs and move them up to the memory
> directory. This would be state (which should probably be split into an
> 'online' and 'offline' file), removable, phys_index, and phys_device.
> 
I've considered several patterns.

with 4096 bytes buffer of sysfs, "printting bitmap" just covers small
amount of sections even with smart ASCII format to show contiguous range
as a chunk. That's my concern. (and 'list' file in above example
is impossible to impelement.)

If I can use rmdir/mkdir interface, it's much simple rather than above "echo".
But it seems impossible.
Because we have memory information in /proc/iomem already, I think hide/show
interface (instead of mkdir/rmdir) is not very bad.

If you can implement highly scalable interface, please.
I just stop dreaming and ack yours.

Thanks,
-Kame


