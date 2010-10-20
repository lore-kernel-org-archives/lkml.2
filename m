Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0JTFrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 01:47:09 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58689 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0JTFrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 01:47:08 -0400
Date: Wed, 20 Oct 2010 07:47:52 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Drake <dsd@laptop.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dilinger@queued.net" <dilinger@queued.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@amd64.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>
Subject: Re: [PATCH] OLPC: Add XO-1 suspend/resume support
Message-ID: <20101020054752.GA10441@aftab>
References: <20101019220159.0DBBE9D401B@zog.reactivated.net>
 <4CBE1781.1050000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBE1781.1050000@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, Oct 19, 2010 at 06:11:13PM -0400

> On 10/19/2010 03:01 PM, Daniel Drake wrote:
> > Add code needed for basic suspend/resume of the XO-1 laptop.
> > 
> > swsusp_pg_dir needs to be exposed as it is used by the assembly
> > code run in the wakeup path.
> > 
> 
> Okay... this is Yet Another Reason why we need to unify all the bloody
> trampoline page tables.
> 
> What it comes down to is that there are several users which need a 1:1
> mapped pagetable and a chunk of memory < 1 MiB, and they should all be
> combined and linked together, and share a single pagetable set that
> sticks around.
> 
> Borislav has already been doing some of this work:
> 
> [PATCH] x86-32, mm: Add an initial page table for core bootstrapping
> 
> I thought that patch was already in -tip, but it looks like it's not...
> Borislav/Joerg... was there a newer patch or did we just miss the final
> version?  I remember we talked about this at some length, but it looks
> like I dropped the ball (I was on vacation when the above message was
> posted.)

The final version with fixed ACPI sleep is this one:
http://www.gossamer-threads.com/lists/linux/kernel/1270589

I ran it for a couple of weeks and it didn't show any regressions. If
you want to get it into the merge window, I can get you an updated
version against a -tip branch of your liking ASAP.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
