Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab0HSUcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:32:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55517 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab0HSUco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:32:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [Regression, 2.6.36-rc1] ath9k resume problem on Acer Ferrari One
Date: Thu, 19 Aug 2010 22:31:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Luis Rodriguez <lrodriguez@atheros.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201008190001.11342.rjw@sisk.pl> <201008191605.08053.rjw@sisk.pl> <4C6D3D5C.7010504@kernel.org>
In-Reply-To: <4C6D3D5C.7010504@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008192231.01722.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 19, 2010, Tejun Heo wrote:
> Hello,
> 
> On 08/19/2010 04:05 PM, Rafael J. Wysocki wrote:
> > On Thursday, August 19, 2010, Tejun Heo wrote:
> >> Hello, Rafael.
> >>
> >> On 08/19/2010 12:01 AM, Rafael J. Wysocki wrote:
> >>> While testing 2.6.36-rc1 (with a couple of fixes on top) I noticed
> >>> that the ath9k driver didn't work after resume from suspend to RAM.
> >>> An attempt to unload the driver using rmmod caused the BUG_ON() in
> >>> kernel/workqueue.c:2844 to trigger.
> >>
> >> That BUG_ON() triggers if destroy_workqueue() is called while work
> >> items are still pending on the workqueue.  Can you please trigger
> >> stack traces after resume and post it?
> > 
> > Do you mean sysrq-t?
> 
> Yeah, I'm a bit confused regarding what's going on.  I thought the
> most likely cause is thawing failing to kick a frozen workqueue into
> working state but then flush_workqueue() which is called from
> destroy_workqueue() should have hung too, that is, unless
> flush_workqueue() is broken too.  If flush_workqueue() is not broken,
> then it could be that workqueue itself isn't at fault and works are
> being scheduled and executed fine for the workqueue ath9k is using but
> the driver doesn't work for another reason.
> 
> Also, the BUG_ON() being triggered means either flush_workqueue() is
> broken or the driver is failing to stop works on the workqueue from
> being requeued before calling destroy_workqueue().  So, finding out
> the followings would be great,
> 
> * While the driver isn't working, do a sysrq-t and see whether any
>   worker is executing a work for ath9k.
> 
> * Repeat it several times and see whether the work is stuck or making
>   progress and/or executing on different workers.

Actaully, I'm unable to reproduce the resume issue with current mainline
(HEAD = 763008c4357b73c8d18396dfd8d79dc58fa3f99d), so I guess it either is
a race (or another timing issue), or it's been fixed by one of the patches on
top of -rc1.

I'll let you know if I see it again.

Thanks,
Rafael
