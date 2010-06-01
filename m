Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab0FAWbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 18:31:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39860 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab0FAWbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 18:31:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: 2.6.35 Radeon KMS power management regression?
Date: Wed, 2 Jun 2010 00:32:30 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "dri-devel" <dri-devel@lists.freedesktop.org>
References: <4C04A767.8000209@crca.org.au> <AANLkTikTyYOGEEkFoV9NfbWE9Jxe9Q6Kk1mAJ4PDNL5r@mail.gmail.com>
In-Reply-To: <AANLkTikTyYOGEEkFoV9NfbWE9Jxe9Q6Kk1mAJ4PDNL5r@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006020032.30163.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 June 2010, Dave Airlie wrote:
> On Tue, Jun 1, 2010 at 4:23 PM, Nigel Cunningham
> <ncunningham@crca.org.au> wrote:
> > Hi all.
> >
> > Just wondering if anyone else has tried to hibernate while using Radeon KMS
> > and a tree with Dave's post 2.6.34 patches? My 32 bit P4 based system (with
> > an RV250 card) is hanging at the atomic copy, with the following backtrace
> >
> > hibernation_snapshot
> > dpm_suspend_start
> > async_synchronize_full
> > async_synchronize_cookie
> > async_synchronize_cookie_domain
> >
> > I've been trying to bisect, but this computer is being painfully slow, so I
> > haven't been making much progress. 2.6.34 with the same config is fine, and
> > my bisection progress so far seems to be pointing at the merge I mentioned
> > above.
> 
> The only thing I can think off might be the output polling task, or
> the fix from Jerome for AGP suspend/resume
> 10b06122afcc78468bd1d009633cb71e528acdc5 is AGP one to test
> 
> disabling output polling is a messier revert, might be easier to just edit
> drivers/gpu/drm/drm_crtc_helper.c:drm_kms_helper_poll_init and remove
> the delayed_slow_work_enqueue call, also forcing repoll to false
> inside output_poll_execute which should in theory stop the polling
> from starting or being kicked off later.
> 
> I'll try and recreate if I get a chance, cc'ing dri-devel also for Alex/Jerome.

I'm not reproducing this on Acer Ferrari One (that has an rs780 IIRC),
but it seems I can reproduce it on a desktop box with some PCIe r300.

Tomorrow I'll try .35-rc1 on HP nx6325.

Rafael
