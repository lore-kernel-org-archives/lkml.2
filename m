Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0F2SEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:04:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab0F2SEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:04:49 -0400
Date: Tue, 29 Jun 2010 11:04:15 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Message-ID: <20100629180415.GB1240@suse.de>
References: <20100628154455.GA13918@suse.de>
 <1277769867.8354.531.camel@nimitz>
 <20100629115232.38BC.A69D9226@jp.fujitsu.com>
 <1277827384.8354.3413.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277827384.8354.3413.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 09:03:04AM -0700, Dave Hansen wrote:
> On Tue, 2010-06-29 at 11:56 +0900, KOSAKI Motohiro wrote:
> > > On Mon, 2010-06-28 at 08:44 -0700, Greg KH wrote:
> > > > > The directories being created are the standard directories, one for each of the memory
> > > > > sections present at boot.  I think the most used files in each of these directories
> > > > > is the state and removable file used to do memory hotplug.
> > > > 
> > > > And perhaps we shouldn't really be creating so many directories?  Why
> > > > not work with the memory hotplug developers to change their interface to
> > > > not abuse sysfs in such a manner? 
> > > 
> > > Heh, it wasn't abuse until we got this much memory.  But, I think this
> > > one is pretty much 100% my fault.
> > > 
> > > Nathan, I think the right fix here is probably to untie sysfs from the
> > > sections a bit.  We should be able to have sysfs dirs that represent
> > > more than one contiguous SECTION_SIZE area of memory.
> > 
> > Why do we need abi breakage? Yourself talked about we guess ppc don't
> > actually need 16MB section. I think IBM folks have to confirm it.
> > If our guessing is correct, the firmware fixing is only necessary.
> 
> >From the mouth of the kernel dumbass who coded this up: it's not the
> firmware's fault.  We shouldn't punt this to them, and the proper fix
> _isn't_ in the firmware, plus they may have other more fundamental
> reasons to keep the LMB sizes what they are.

I agree, this should be fixed in the api to userspace, having this many
sysfs directories and/or files is just looney.

thanks,

greg k-h
