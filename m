Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2HGLHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:07:42 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50984 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab2HGLHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:07:40 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 7 Aug 2012 04:07:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Christopher Sacchi <chris.sacchi@gmail.com>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: Autosleep patch.
Message-ID: <20120807110748.GA12534@roeck-us.net>
References: <CAGh4K3L_nY5B22g5oMBuoY=a1OB7U10yH1ZJvn0dG_O5TVz6+Q@mail.gmail.com>
 <501FE4E9.3080004@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501FE4E9.3080004@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 08:38:17AM -0700, Randy Dunlap wrote:
> On 08/06/2012 08:13 AM, Christopher Sacchi wrote:
> 
> > This patch (listed below), changes an old function in autosleep.c in
> > kernel version 3.5. It's code is listed from the first -- line to the
> > 2nd to last -- line.
> > This patch was checked with checkpatch.pl with no errors:
> > --
> > --- power/autosleep.c	2012-07-21 20:58:29.000000000 +0000
> > +++ power/autosleepnew.c	2012-08-06 10:52:26.000000000 +0000
> 
> 
> The file names should include the full path from the top level of the
> kernel source tree.  E.g.:
> 
> --- linux.orig/kernel/power/autosleep.c
> +++ linux/kernel/power/autosleep.c
> 
> This patch uses the name autosleepnew.c, which is not what is
> required/expected.
> 
> Your previous patches were for wireless (mac80211) components, so they
> needed to go to the linux-wireless mailing list.  This patch is not
> about wireless, so don't send it to that mailing list, although you
> could send it to the linux-pm@vger.kernel.org mailing list.
> Please see the MAINTAINERS file for where to send patches.
> 
> 
> > @@ -30,7 +30,7 @@ static void try_to_suspend(struct work_s
> >  	if (!pm_get_wakeup_count(&initial_count, true))
> >  		goto out;
> > 
> > -	mutex_lock(&autosleep_lock);
> > +	mutex_lock_interruptable();
> > 

Plus, this code obviously never compiled. Nor does the submitter ever explain
what he actually tries to accomplish.

Guenter

> >  	if (!pm_save_wakeup_count(initial_count)) {
> >  		mutex_unlock(&autosleep_lock);
> > Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>
> > --
> 
> Signed-off-by: line is not part of the patch.  It should be near the
> end of the patch description, before the actual patch.
> 
> Again, please read and follow Documentation/SubmittingPatches.
> 
> thanks.
> 
> -- 
> ~Randy
> 
