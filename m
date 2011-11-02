Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab1KBTT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:19:59 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:45381 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756374Ab1KBTTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:19:55 -0400
X-Sasl-enc: UUH7mJOHo6lxuhqsHeRHMoebdHKRAWNEuLp7hPGFPRfB 1320261594
Date: Wed, 2 Nov 2011 12:14:32 -0700
From: Greg KH <greg@kroah.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        linux-scsi@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org
Subject: Re: [PATCH 4/6 v2] PM: Limit race conditions between runtime PM and
 system sleep (v2)
Message-ID: <20111102191432.GC29355@kroah.com>
References: <201106260054.20578.rjw@sisk.pl>
 <201106292329.04163.rjw@sisk.pl>
 <201106292334.24518.rjw@sisk.pl>
 <CAKnu2Mru4c-2LBCZ_k3ZA+v47u0+um8igYU7EWt8=qOTVgcUjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKnu2Mru4c-2LBCZ_k3ZA+v47u0+um8igYU7EWt8=qOTVgcUjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 03:54:20PM +0200, Linus Walleij wrote:
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
> not go into the 3.0.y stable releases? We are trying to produce
> a runtime PM system of product quality based on 3.0.y and we've
> already had to backport this patch ourselves to get things stable.
> 
> We have also backported:
> PM: Introduce generic "noirq" callback routines for subsystems (v2)
> PM / Runtime: Update documentation of interactions with system sleep
> PM / Runtime: Add new helper function: pm_runtime_status_suspended()
> 
> And now it seems to be sufficient to get this thing going.

So, what specific git commits do you want to see in the 3.0-stable
tree, and in what order should they be applied in?

thanks,

greg k-h
