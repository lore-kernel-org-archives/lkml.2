Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0F1PuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:50:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:44207 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab0F1PuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:50:03 -0400
Date: Mon, 28 Jun 2010 08:44:55 -0700
From: Greg KH <gregkh@suse.de>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Message-ID: <20100628154455.GA13918@suse.de>
References: <87d3vfeage.fsf@basil.nowhere.org>
 <4C24C279.3050206@austin.ibm.com>
 <20100628110658.387B.A69D9226@jp.fujitsu.com>
 <20100628150246.GA13192@suse.de>
 <4C28C1A8.8010904@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C28C1A8.8010904@austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 10:37:12AM -0500, Nathan Fontenot wrote:
> On 06/28/2010 10:02 AM, Greg KH wrote:
> > On Mon, Jun 28, 2010 at 11:20:27AM +0900, KOSAKI Motohiro wrote:
> >>> On 06/25/2010 04:19 AM, Andi Kleen wrote:
> >>>> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
> >>>>
> >>>>>> Proposed patch to disable memory hotplug via a boot option,
> >>>>>> mem_hotplug=[on|off].  The patch only disables memory hotplug in that it 
> >>>>>> prevents the creation of the memory sysfs directories for memory sections.
> >>>>>>
> >>>>>> This patch is meant to help alleviate very long boot times on systems with
> >>>>>> large memory (1+ TB) and many memory sections (10's of thousands).
> >>>>>
> >>>>> Why making simple /sys file is so slowly? Couldn't we fix such performance
> >>>>> problem?
> >>>
> >>> The issue is the large number of sysfs memory directories that get created.
> >>> On a system with 1 TB of memory I am seeing ~63,00 directories.  The long
> >>> creation time is due to the string compare check in sysfs code to ensure
> >>> we are not creating a directory with a duplicate name.
> >>
> >> Ah, I see. probably this is sysfs issue. So Let's cc Greg and Eric.
> >> Greg, I have dumb question. Why sysfs call strcmp() so heavily? I mean why sysfs
> >> don't have hash based name dupliation check?
> > 
> > Because we have not needed such complexity before.
> > 
> > You might want to take a step back and asky why you are creating 63
> > thousand directories in sysfs for large memory systems.  Are you really
> > going to use all of those directories?  What are they for?  Perhaps
> > someone created the wrong interface to memory and that needs to be fixed
> > instead?
> > 
> 
> The directories being created are the standard directories, one for each of the memory
> sections present at boot.  I think the most used files in each of these directories
> is the state and removable file used to do memory hotplug.

And perhaps we shouldn't really be creating so many directories?  Why
not work with the memory hotplug developers to change their interface to
not abuse sysfs in such a manner?

thanks,

greg k-h
