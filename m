Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab2HGLrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:47:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:45965 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab2HGLrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:47:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH]: Autosleep patch.
Date: Tue, 7 Aug 2012 13:52:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Christopher Sacchi <chris.sacchi@gmail.com>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAGh4K3L_nY5B22g5oMBuoY=a1OB7U10yH1ZJvn0dG_O5TVz6+Q@mail.gmail.com> <501FE4E9.3080004@xenotime.net> <20120807110748.GA12534@roeck-us.net>
In-Reply-To: <20120807110748.GA12534@roeck-us.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208071352.56786.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 07, 2012, Guenter Roeck wrote:
> On Mon, Aug 06, 2012 at 08:38:17AM -0700, Randy Dunlap wrote:
> > On 08/06/2012 08:13 AM, Christopher Sacchi wrote:
> > 
> > > This patch (listed below), changes an old function in autosleep.c in
> > > kernel version 3.5. It's code is listed from the first -- line to the
> > > 2nd to last -- line.
> > > This patch was checked with checkpatch.pl with no errors:
> > > --
> > > --- power/autosleep.c	2012-07-21 20:58:29.000000000 +0000
> > > +++ power/autosleepnew.c	2012-08-06 10:52:26.000000000 +0000
> > 
> > 
> > The file names should include the full path from the top level of the
> > kernel source tree.  E.g.:
> > 
> > --- linux.orig/kernel/power/autosleep.c
> > +++ linux/kernel/power/autosleep.c
> > 
> > This patch uses the name autosleepnew.c, which is not what is
> > required/expected.
> > 
> > Your previous patches were for wireless (mac80211) components, so they
> > needed to go to the linux-wireless mailing list.  This patch is not
> > about wireless, so don't send it to that mailing list, although you
> > could send it to the linux-pm@vger.kernel.org mailing list.
> > Please see the MAINTAINERS file for where to send patches.
> > 
> > 
> > > @@ -30,7 +30,7 @@ static void try_to_suspend(struct work_s
> > >  	if (!pm_get_wakeup_count(&initial_count, true))
> > >  		goto out;
> > > 
> > > -	mutex_lock(&autosleep_lock);
> > > +	mutex_lock_interruptable();
> > > 
> 
> Plus, this code obviously never compiled. Nor does the submitter ever explain
> what he actually tries to accomplish.

We've discussed this offlist and as far as I can see it there is no bug and
nothing needs to be fixed.

Thanks,
Rafael
