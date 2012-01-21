Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab2AUSwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:52:17 -0500
Received: from lo.gmane.org ([80.91.229.12]:39145 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab2AUSwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:52:16 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: i915 wakes from suspend to RAM with blank screen after commit
 cd9dde44f47501394b9f0715b6a36a92aa74c0d0
Date: Sat, 21 Jan 2012 18:51:57 +0000 (UTC)
Message-ID: <jff1gd$afi$1@dough.gmane.org>
References: <jfe47e$5dn$1@dough.gmane.org> <86mx9gkjlv.fsf@sumi.keithp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 188.122.213.132
User-Agent: Pan/0.135 (Tomorrow I'll Wake Up and Scald Myself with Tea; GIT
	30dc37b master)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard, Sat, 21 Jan 2012 10:15:24 -0800:

> On Sat, 21 Jan 2012 10:32:14 +0000 (UTC), Lubos Kolouch
> <lubos.kolouch@gmail.com> wrote:
> 
>> I git bisected it to commit cd9dde44f47501394b9f0715b6a36a92aa74c0d0 is
>> the first bad commit commit cd9dde44f47501394b9f0715b6a36a92aa74c0d0
>> Author: Adam Jackson <ajax@redhat.com>
>> Date:   Fri Oct 14 12:43:49 2011 -0400
> 
> Did you try reverting this single commit on top of 3.3-rc1?
> 
> And, can you collect the dmesg output with the kernel parameter
> drm.debug=0xe added to the boot line, both messages at boot time *and*
> messages during resume would be needed. If it works at boot time, I'm
> quite surprised it somehow doesn't work at resume...

I tried now and when I revert this line :

- return (pixel_clock * bpp + 7) / 8;
+ return (pixel_clock * bpp + 9) / 10;

resume works OK for me with 3.3-rc1.

Before change (failed)
----------------------
dmesg after boot - http://paste.pocoo.org/show/538343/
dmesg after failed resume -  http://paste.pocoo.org/show/538344/

After change (OK)
-----------------
dmesg after boot - http://paste.pocoo.org/show/538345/
dmesg after OK resume - http://paste.pocoo.org/show/538346/

Luboš Kolouch

