Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab2BDWX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 17:23:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37163 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab2BDWXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 17:23:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH Updated] PM/Freezer: Thaw only kernel threads if freezing of kernel threads fails
Date: Sat, 4 Feb 2012 23:27:09 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, pavel@ucw.cz, len.brown@intel.com,
        linux-pm@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Nigel Cunningham <nigel@tuxonice.net>
References: <20120201223105.6669.12718.stgit@srivatsabhat.in.ibm.com> <4F29C3E3.1040108@linux.vnet.ibm.com> <4F2D3C90.3000708@linux.vnet.ibm.com>
In-Reply-To: <4F2D3C90.3000708@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202042327.10045.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 04, 2012, Srivatsa S. Bhat wrote:
> On 02/02/2012 04:29 AM, Srivatsa S. Bhat wrote:
> 
> > 
> > From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > Subject: [PATCH] PM/Freezer: Thaw only kernel threads if freezing of kernel threads fails
> > 
> > If freezing of kernel threads fails, we are expected to automatically thaw
> > tasks in the error recovery path. However, at times, we encounter situations
> > in which we would like the automatic error recovery path to thaw only the
> > kernel threads, because we want to be able to do some more cleanup before
> > we thaw userspace. Something like:
> > 
> > error = freeze_kernel_threads();
> > if (error) {
> > 	/* Do some cleanup */
> > 
> > 	/* Only then thaw userspace tasks*/
> > 	thaw_processes();
> > }
> > 
> > An example of such a situation is where we freeze/thaw filesystems during
> > suspend/hibernation. There, if freezing of kernel threads fails, we would
> > like to thaw the frozen filesystems before thawing the userspace tasks.
> > 
> > So, modify freeze_kernel_threads() to thaw only kernel threads in case of
> > freezing failure. And change suspend_freeze_processes() accordingly.
> > (At the same time, let us also get rid of the rather cryptic usage of the
> > conditional operator (:?) in that function.)
> > 
> > Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > Acked-by: Tejun Heo <tj@kernel.org>
> > ---
> 
> 
> Hi Rafael,
> 
> I have reworked the changelog of this patch to indicate that this fixes a
> regression. Here is the updated patch:

Well, I've already fixed that up in my tree, but thanks anyway. :-)

Rafael
