Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0F3AAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 20:00:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36384 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab0F3AAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 20:00:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Hansen <dave@linux.vnet.ibm.com>,
       Greg KH <gregkh@suse.de>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <4C2A1387.1090406@austin.ibm.com>
References: <20100629115232.38BC.A69D9226@jp.fujitsu.com> <4C2A1387.1090406@austin.ibm.com>
Message-Id: <20100630084644.38F7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 09:00:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/28/2010 09:56 PM, KOSAKI Motohiro wrote:
> >> On Mon, 2010-06-28 at 08:44 -0700, Greg KH wrote:
> >>>> The directories being created are the standard directories, one for each of the memory
> >>>> sections present at boot.  I think the most used files in each of these directories
> >>>> is the state and removable file used to do memory hotplug.
> >>>
> >>> And perhaps we shouldn't really be creating so many directories?  Why
> >>> not work with the memory hotplug developers to change their interface to
> >>> not abuse sysfs in such a manner? 
> >>
> >> Heh, it wasn't abuse until we got this much memory.  But, I think this
> >> one is pretty much 100% my fault.
> >>
> >> Nathan, I think the right fix here is probably to untie sysfs from the
> >> sections a bit.  We should be able to have sysfs dirs that represent
> >> more than one contiguous SECTION_SIZE area of memory.
> > 
> > Why do we need abi breakage? Yourself talked about we guess ppc don't
> > actually need 16MB section. I think IBM folks have to confirm it.
> > If our guessing is correct, the firmware fixing is only necessary.
> 
> Yes, ppc still needs to support add/remove of 16MB sections.  This correlates
> to the smallest lmb size on ppc that we need to support.

okey. I'm not against the change by strong reason. fortunatelly hotplug users are still few.
If we maintain CONFIG_OLD_MEMHOTPLUG_LAYOUT a while time, I guess
nobody oppose new one.


> > Thats said, I don't 100% refuse your idea. it's interesting. but, 
> > In generical I hate _unncessary_ abi change.
> 
> Me too, but I'm not sure the current sysfs layout of memory scales well
> for machines with huge amounts of memory.
> 
> How about providing an alternate sysfs layout for systems that have a large
> number of memory sections?  Even on the machines I worked with that have
> 1 and 2 TB of memory, if we increase the memory sections size to equal the
> lmb size we still would be creating 6k+ directories for a 1 TB machine.
> This would alleviate much of the perfomrance issue but still leaves us with 
> a directory of thousands (or tens of thousands for really big systems) 
> of memoryXXX subdirectories, which is not really human readable.

?? human readable?
As far as I observed, this dir have been no human readable since it was born. but
nobody complained this one because only hotplug-script need to read this.

Am I missing something?

> Or some method of having a single memory XXX dir represent multiple sections,
> as Dave suggested would work. Perhaps there is a way to subdivide the
> memory section dirs into separate dirs based on their node.
> 
> At the point of dealing with this many memory sections would it make sense
> to not create directories for each of the memory sections? Perhaps just
> files to report information about the memory sections.

Probably, It will works. I have one question. How many dir do the patch reduce 
on your machine? Do we need to combinate Eric's hash-dir patch?



