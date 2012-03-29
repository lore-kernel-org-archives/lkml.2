Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab2C2Xkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:40:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50355 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760366Ab2C2Xkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:40:41 -0400
Date: Thu, 29 Mar 2012 16:40:37 -0700
From: Greg K H <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/14] edac: rewrite the sysfs code to use struct device
Message-ID: <20120329234037.GA16094@kroah.com>
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
 <1333040821-6253-2-git-send-email-mchehab@redhat.com>
 <20120329220300.GA16491@kroah.com>
 <4F74EDEC.5020804@redhat.com>
MIME-Version: 1.0
In-Reply-To: <4F74EDEC.5020804@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 08:19:08PM -0300, Mauro Carvalho Chehab wrote:
> > Sweet, as per the documentation in the Documentation/kobjects.txt file,
> > I get to publically mock you for thinking you are smarter than the
> > kernel and this is an acceptable way to "outwhit" the driver core from
> > spitting errors at you when the kobject is released.
> 
> There's nothing there to free: all EDAC structures are allocated once
> (see edac_mc_alloc() and edac_align_ptr() logic, at drivers/edac/edac_mc.c).
> 
> Even the struct device for all csrows/channels/mcu is done on a single alloc
> there. Trying to free it earlier would cause a segfault.

That's wrong then, these are multiple struct devices, all with their own
reference counts, you can't just treat them all as the same thing, even
if it happens to line up with the module reference count.

> I didn't wrote that logic, nor I was tempted to change it: as this subsystem 
> is focused on memory error detection, having every data structure used there
> on a single page helps to minimize the probability of having an error at the 
> memory used to store the EDAC data.

Possibly, but again, you have multiple reference counts, you can't just
wave them off as being inconvenient.  Please read the documentation for
more details why.

greg k-h
