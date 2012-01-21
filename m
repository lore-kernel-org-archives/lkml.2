Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab2AUSy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:54:27 -0500
Received: from host132-213-122-188.magnalink.cz ([188.122.213.132]:52175 "EHLO
	nbgentoo.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750980Ab2AUSy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:54:26 -0500
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Jan 2012 13:54:26 EST
Date: Sat, 21 Jan 2012 19:44:53 +0100
From: Lubos Kolouch <lubos.kolouch@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915 wakes from suspend to RAM with blank screen after commit
 cd9dde44f47501394b9f0715b6a36a92aa74c0d0
Message-ID: <20120121184453.GA2698@nbgentoo>
References: <jfe47e$5dn$1@dough.gmane.org>
 <86mx9gkjlv.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86mx9gkjlv.fsf@sumi.keithp.com>
X-Operating-System: Linux nbgentoo 3.3.0-rc1-dirty 
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012, 10:15:24, Keith Packard wrote:
> On Sat, 21 Jan 2012 10:32:14 +0000 (UTC), Lubos Kolouch <lubos.kolouch@gmail.com> wrote:
> 
> > I git bisected it to commit
> > cd9dde44f47501394b9f0715b6a36a92aa74c0d0 is the first bad commit
> > commit cd9dde44f47501394b9f0715b6a36a92aa74c0d0
> > Author: Adam Jackson <ajax@redhat.com>
> > Date:   Fri Oct 14 12:43:49 2011 -0400
> 
> Did you try reverting this single commit on top of 3.3-rc1?
> 
> And, can you collect the dmesg output with the kernel parameter drm.debug=0xe
> added to the boot line, both messages at boot time *and* messages during
> resume would be needed. If it works at boot time, I'm quite surprised it
> somehow doesn't work at resume...

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

Lubo¹ Kolouch
