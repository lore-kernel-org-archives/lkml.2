Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab0F3Aha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 20:37:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37907 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0F3Ah2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 20:37:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 30 Jun 2010 09:32:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg KH <gregkh@suse.de>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Message-Id: <20100630093251.a30ed1e0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100629180415.GB1240@suse.de>
References: <20100628154455.GA13918@suse.de>
	<1277769867.8354.531.camel@nimitz>
	<20100629115232.38BC.A69D9226@jp.fujitsu.com>
	<1277827384.8354.3413.camel@nimitz>
	<20100629180415.GB1240@suse.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010 11:04:15 -0700
Greg KH <gregkh@suse.de> wrote:

> On Tue, Jun 29, 2010 at 09:03:04AM -0700, Dave Hansen wrote:
> > On Tue, 2010-06-29 at 11:56 +0900, KOSAKI Motohiro wrote:
> > > > On Mon, 2010-06-28 at 08:44 -0700, Greg KH wrote:
> > > > > > The directories being created are the standard directories, one for each of the memory
> > > > > > sections present at boot.  I think the most used files in each of these directories
> > > > > > is the state and removable file used to do memory hotplug.
> > > > > 
> > > > > And perhaps we shouldn't really be creating so many directories?  Why
> > > > > not work with the memory hotplug developers to change their interface to
> > > > > not abuse sysfs in such a manner? 
> > > > 
> > > > Heh, it wasn't abuse until we got this much memory.  But, I think this
> > > > one is pretty much 100% my fault.
> > > > 
> > > > Nathan, I think the right fix here is probably to untie sysfs from the
> > > > sections a bit.  We should be able to have sysfs dirs that represent
> > > > more than one contiguous SECTION_SIZE area of memory.
> > > 
> > > Why do we need abi breakage? Yourself talked about we guess ppc don't
> > > actually need 16MB section. I think IBM folks have to confirm it.
> > > If our guessing is correct, the firmware fixing is only necessary.
> > 
> > >From the mouth of the kernel dumbass who coded this up: it's not the
> > firmware's fault.  We shouldn't punt this to them, and the proper fix
> > _isn't_ in the firmware, plus they may have other more fundamental
> > reasons to keep the LMB sizes what they are.
> 
> I agree, this should be fixed in the api to userspace, having this many
> sysfs directories and/or files is just looney.
> 
> thanks,
> 

Hmm, adding 
 CONFIG_NEW_MEMORY_SYSFS_LAYOUT or
 memory_sysfs_layout=small boot option
and adding a scalable interface for large scale machines ?
I'd like to consider something..

Thanks,
-Kame



