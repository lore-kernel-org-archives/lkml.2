Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032938Ab2CPPbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:31:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49351 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032891Ab2CPPbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:31:43 -0400
Date: Fri, 16 Mar 2012 08:31:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120316153139.GI28696@kroah.com>
References: <20120314204355.GA10187@kroah.com>
 <20120314223102.GA27602@aftab>
 <4F61496D.8030000@redhat.com>
 <20120315113115.GA32149@aftab>
 <4F61E35B.9000906@redhat.com>
 <20120315213844.GA3781@aftab>
 <4F62FE38.6060704@redhat.com>
 <20120316111536.GA8577@aftab>
 <4F632D16.1090200@redhat.com>
 <4F63490E.3040500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F63490E.3040500@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 11:07:10AM -0300, Mauro Carvalho Chehab wrote:
> Em 16-03-2012 09:07, Mauro Carvalho Chehab escreveu:
> > Em 16-03-2012 08:15, Borislav Petkov escreveu:
> >> Lemme save you all the trouble:
> ...
> > Anyway, I wrote the patches for it already after Greg's email.
> > I'm just about to test them.
> 
> And they're already working. 
> 
> The patches are (will be, after mirror sync) at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git hw_events_v8
> 
> There are just two new patches on it (and some bug fix patches got fold
> to simplify their review):
> 
> c316427 edac: preserve the current EDAC sysfs API on a separate file
> 
> 	- Just copies the edac_mc_sysfs.c as edac_mc_sysfs_legacy.c,
> 	  in order to preserve the ABI before the changes;
> 
> 22790f1 edac: Convert edac mc to use struct device
> 
> 	- Fixes edac_mc_sysfs_legacy.c with the changes at the struct,
> 	  and converts edac_mc_sysfs to use struct device.
> 
> There are still a few adjustments to do, so this is not a final version,
> but the patch is already doing what's expected.
> 
> I decided to code the ras functions it as a new class, under:
> 	/sys/class/ras

Ah, you really shouldn't be creating new classes in the kernel either,
sorry.  Why is this needed, and you can't just use a bus and struct
device in the place where the kobjects were in the tree?

thanks,

greg k-h
