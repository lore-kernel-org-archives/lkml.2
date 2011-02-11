Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1BKNEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 08:04:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42471 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1BKNER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 08:04:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qzXa+LqVBPrK3sboC2aUkCMdIGQGSGW1j0pHp+EEnfReecmEA4T0TadUnafBsIKt27
         aDqmnbp4tbcF2ZxvJknDzVF6SwOPE/QrTtssLU0O7RYtxStmBgLK7NhMzO3FmrsG7Ihd
         m521ihA47fdQE3lVhSXXLm7WVWX83ByJBfLiU=
Date: Fri, 11 Feb 2011 14:04:12 +0100
From: Felix Blanke <felixblanke@gmail.com>
To: Chris Samuel <chris@csamuel.org>, Felix Blanke <felixblanke@gmail.com>,
        kreijack@inwind.it, Hugo Mills <hugo-lkml@carfax.org.uk>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: LOOP_GET_STATUS(64) truncates pathnames to 64 chars (was Re: Bug
 in mkfs.btrfs?!)
Message-ID: <20110211130412.GA2591@scooter>
References: <20110122144513.GA2539@scooter>
 <20110122145222.GB2539@scooter>
 <20110122151124.GC29985@carfax.org.uk>
 <20110122155612.GA3664@scooter>
 <20110123181827.GF29985@carfax.org.uk>
 <4D3CA568.7050506@libero.it>
 <20110124130104.GA7354@scooter>
 <4D3E160F.4050006@csamuel.org>
 <20110210122927.GB20488@foxbat.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210122927.GB20488@foxbat.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

are you sure that patch is in the kernel?

I'm using 2.6.37 and don't have those attribues in my /sys.



Felix

On 10. February 2011 - 13:29, Petr Uzel wrote:
> Date: Thu, 10 Feb 2011 13:29:27 +0100
> From: Petr Uzel <petr.uzel@suse.cz>
> To: Chris Samuel <chris@csamuel.org>
> Cc: Felix Blanke <felixblanke@gmail.com>, kreijack@inwind.it, Hugo Mills
>  <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org, Linux Kernel
>  <linux-kernel@vger.kernel.org>
> Subject: Re: LOOP_GET_STATUS(64) truncates pathnames to 64 chars (was Re:
>  Bug in mkfs.btrfs?!)
> Mail-Followup-To: Chris Samuel <chris@csamuel.org>, Felix Blanke
>  <felixblanke@gmail.com>, kreijack@inwind.it, Hugo Mills
>  <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org, Linux Kernel
>  <linux-kernel@vger.kernel.org>
> 
> On Tue, Jan 25, 2011 at 11:15:11AM +1100, Chris Samuel wrote:
> > /*
> >  * CC'd to linux-kernel in case they have any feedback on this.
> >  *
> >  * Long thread, trying to work out why mkfs.btrfs failed to
> >  * make a filesystem on an encrypted loopback mount called
> >  * /dev/loop2. Cause turned out to be mkfs.btrfs calling
> >  * LOOP_GET_STATUS to find out if the block device was mounted
> >  * and getting a truncated device name back and so it later
> >  * fails when lstat() is called on the truncated device path.
> >  *
> >  * The long device name for the encrypted loopback mount was
> >  * because /dev/disk/by-id/$ID was used when Felix created it
> >  * to cope with devices moving around.
> >  */
> > 
> > On 25/01/11 00:01, Felix Blanke wrote:
> > 
> > > you were talking about the LOOP_GET_STATUS function. I'm not
> > > quite sure where does it came from. Is it part of the kernel?
> > > Or does it come from the util-linux package?
> > 
> > It's in the kernel, and there is both LOOP_GET_STATUS (old
> > implementation) and LOOP_GET_STATUS64 (new implementation).
> > 
> > They return structures called loop_info and loop_info64
> > respectively and both are defined in include/linux/loop.h .
> > 
> > Sadly in both cases the lengths of paths are defined to be
> > LO_NAME_SIZE which is currently 64 and hence either
> > implementation will cause the problematic:
> > 
> > lstat("/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-par",
> > 0x7fffa30b3cf0) = -1 ENOENT (No such file or directory)
> > 
> > I've CC'd this to the LKML in case they have any feedback on
> > this apparent problem with the API.
>  
> Since 2.6.37, you can get full path to the backing file from sys:
> cat /sys/block/loopX/loop/backing_file
> 
> See
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-07/msg10996.html
> 
> 
> HTH,
> 
> Petr
> 
> --
> Petr Uzel
> IRC: ptr_uzl @ freenode


---end quoted text---
