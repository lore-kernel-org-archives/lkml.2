Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab0GAXaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:30:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:38163 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab0GAXaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:30:13 -0400
Date: Thu, 1 Jul 2010 16:26:34 -0700
From: Greg KH <gregkh@suse.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Message-ID: <20100701232634.GD13617@suse.de>
References: <20100628154455.GA13918@suse.de>
 <1277769867.8354.531.camel@nimitz>
 <20100629115232.38BC.A69D9226@jp.fujitsu.com>
 <1277827384.8354.3413.camel@nimitz>
 <20100629180415.GB1240@suse.de>
 <20100630093251.a30ed1e0.kamezawa.hiroyu@jp.fujitsu.com>
 <20100630154755.GB12158@suse.de>
 <20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 09:31:30AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 30 Jun 2010 08:47:55 -0700
> Greg KH <gregkh@suse.de> wrote:
> > > and adding a scalable interface for large scale machines ?
> > > I'd like to consider something..
> > 
> > Dynamically changing the layout on big memory boxes makes sense to me,
> > how about you?
> > 
> 
> like this ?
> ==
> boot option:
> memory_sysfs_layout=compact
> memory_sysfs_layout=auto (default)
> memory_sysfs_layout=full
> 
> Considering briefly, how about this compact layout ?
> 
> /sys/devices/system/memory/:
>                             list, hide, show, memoryX...
> 
> list: // show available memory index list.
>   #cat list
>    0 1 2 ....10000...
> 
> show: //an interface to enable the interface.
>   #echo INDEX > memory_index
>   will create memoryINDEX diretory.
> 
> hide: //an interface to hide the interface.
>   #echo INDEX > memory_hide
>   will remove memoryINDEX sysfs directory.

Ick, that can get confusing very quickly, and not really solve any of
your root problems, right?

> In compact mode, all memoryX interface are hidden at boot.
> In full mode, all memoryX interaface are shown.
> The Boot option just affects status at boot. If users want, he can make
> all memory sysfs in shown state.
> 
> At hot-add event (via acpi) or probe-event, newly created memory section
> should be start from "shown" mode. hotplug scirpt can hide it after online.
> 
> At hot-remove, the users has to offline memory before hotplug. He'll has
> to do check list and show interface.
> 
> I think this change is not very difficult technically but can this kind of
> interface be allowed ?

Not really, I don't like it.

Why not just simplify what you currently have to not use so many
directories and files?

And maybe, this doesn't belong in sysfs at all...

thanks,

greg k-h
