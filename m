Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0EEAPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:15:07 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:49471 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752151Ab0EEAPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:15:05 -0400
Date: Wed, 5 May 2010 10:14:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Flash IO slow 1.5 MB/s
Message-ID: <20100505001458.GE8120@dastard>
References: <n2i9b1675091005032052wd935041ew5d96f145309af801@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n2i9b1675091005032052wd935041ew5d96f145309af801@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 09:52:44PM -0600, Trenton D. Adams wrote:
> If I mount my usb key with "sync" option, I get 500kb or less transfer
> speeds.  If I use the gnome defaults, I get 60M+ for awhile, and then
> it continually drops over time, down to the 500kb/s again.  Gnome
> defaults are...
> 
> /dev/sdc1 on /media/FLASH type vfat
> (rw,nosuid,nodev,noatime,uhelper=hal,shortname=lower,flush,uid=500)
> 
> I have done similar tests on both Rally2 64G usb stick and sandisk
> ultra (15M/s) SDHC 8G cards.  I get lousy performance on both, unless
> I set dirty bytes.  These are both FAT 32.  But, as you can see below,
> 14 minutes to transfer less than a couple gigs is a little nutty.  The
> 3 minutes is a lot nicer.  I am using 2.6.33 with a patch from
> https://bugzilla.kernel.org/show_bug.cgi?id=15374

Perhaps it might be worth taking the writeback tracing code
from this patch series:

http://marc.info/?l=linux-fsdevel&m=127173141007222&w=2

And seeing what that tells you about how writeback is acting
differently....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
