Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798Ab2C3PcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:32:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58003 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2C3Pb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:31:56 -0400
Date: Fri, 30 Mar 2012 08:31:52 -0700
From: Greg K H <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/14] edac: rewrite the sysfs code to use struct device
Message-ID: <20120330153152.GD18488@kroah.com>
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
 <1333040821-6253-2-git-send-email-mchehab@redhat.com>
 <20120329220300.GA16491@kroah.com>
 <4F74EDEC.5020804@redhat.com>
 <20120329234037.GA16094@kroah.com>
 <4F7516B3.8070505@redhat.com>
MIME-Version: 1.0
In-Reply-To: <4F7516B3.8070505@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 11:13:07PM -0300, Mauro Carvalho Chehab wrote:
> Em 29-03-2012 20:40, Greg K H escreveu:
> > On Thu, Mar 29, 2012 at 08:19:08PM -0300, Mauro Carvalho Chehab wrote:
> >>> Sweet, as per the documentation in the Documentation/kobjects.txt file,
> >>> I get to publically mock you for thinking you are smarter than the
> >>> kernel and this is an acceptable way to "outwhit" the driver core from
> >>> spitting errors at you when the kobject is released.
> >>
> >> There's nothing there to free: all EDAC structures are allocated once
> >> (see edac_mc_alloc() and edac_align_ptr() logic, at drivers/edac/edac_mc.c).
> >>
> >> Even the struct device for all csrows/channels/mcu is done on a single alloc
> >> there. Trying to free it earlier would cause a segfault.
> > 
> > That's wrong then, these are multiple struct devices, all with their own
> > reference counts, you can't just treat them all as the same thing, even
> > if it happens to line up with the module reference count.
> > 
> >> I didn't wrote that logic, nor I was tempted to change it: as this subsystem 
> >> is focused on memory error detection, having every data structure used there
> >> on a single page helps to minimize the probability of having an error at the 
> >> memory used to store the EDAC data.
> > 
> > Possibly, but again, you have multiple reference counts, you can't just
> > wave them off as being inconvenient.  Please read the documentation for
> > more details why.
> 
> This is there since the beginning. The current kobj's have this issue. Those
> patchsets are not making it better or worse, as the EDAC csrow kobj's are
> already there at the current approach: all of them are allocated together
> with the mci kobj.
> 
> On the other hand, I'm working on this patch series in order to correct a 
> serious bug at the EDAC API almost all days during the last 2 months, as
> nobody ever cared enough to address this serious issue.

That's because no one had touched the code.  Now that it has an active
developer (i.e. you), it needs to be fixed.

Especially as the code you just added is wrong, and it's documented as
wrong, and you know it is wrong as you are working around the kernel
warnings by providing release functions that do nothing.

So please fix it, it's your code now.

greg k-h
