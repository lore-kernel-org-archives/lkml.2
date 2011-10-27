Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab1J0UEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:04:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36294 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab1J0UEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:04:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/6 v2] PM: Limit race conditions between runtime PM and system sleep (v2)
Date: Thu, 27 Oct 2011 22:06:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        linux-scsi@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org
References: <201106260054.20578.rjw@sisk.pl> <201106292334.24518.rjw@sisk.pl> <CAKnu2Mru4c-2LBCZ_k3ZA+v47u0+um8igYU7EWt8=qOTVgcUjA@mail.gmail.com>
In-Reply-To: <CAKnu2Mru4c-2LBCZ_k3ZA+v47u0+um8igYU7EWt8=qOTVgcUjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110272206.35180.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 27, 2011, Linus Walleij wrote:
> 2011/6/29 Rafael J. Wysocki <rjw@sisk.pl>:
> 
> > One of the roles of the PM core is to prevent different PM callbacks
> > executed for the same device object from racing with each other.
> > Unfortunately, after commit e8665002477f0278f84f898145b1f141ba26ee26
> > (PM: Allow pm_runtime_suspend() to succeed during system suspend)
> > runtime PM callbacks may be executed concurrently with system
> > suspend/resume callbacks for the same device.
> (...)
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> A quick question: is there some specific reason why this patch should
> not go into the 3.0.y stable releases?
>
> We are trying to produce
> a runtime PM system of product quality based on 3.0.y and we've
> already had to backport this patch ourselves to get things stable.
> 
> We have also backported:
> PM: Introduce generic "noirq" callback routines for subsystems (v2)
> PM / Runtime: Update documentation of interactions with system sleep
> PM / Runtime: Add new helper function: pm_runtime_status_suspended()
> 
> And now it seems to be sufficient to get this thing going.

Well, it isn't a simple fix and it changes the code's behavior quite
significantly, so I thought it might not be a good idea to risk problems
with -stable because of it.  Perhaps let's see how it works out in 3.1
and backport it later if there are no problem reports related to it?

Rafael
