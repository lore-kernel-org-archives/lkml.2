Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031522Ab2CSOf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:35:56 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:5211 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964937Ab2CSOfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:35:55 -0400
Date: Mon, 19 Mar 2012 10:35:48 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Regression: black screen on VGA w/ nouveau in Linux 3.3
Message-ID: <20120319143548.GA27172@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Just upgraded to Linux 3.3 on my desktop and noticed that the VGA output
on my card w/ nouveau is totally black (both at the console and in X).
Almost everything appears to work normally: DPMS works, modesetting
works, DDC works... all messages indicate that things are working --
just the image is completely black.

The VGA is one of two outputs in use: the other (DVI) output works
normally.  The card also has an unused TV-out port, FWIW.

The card is an NV36 generation (Geforce FX5700 AGP).  This is a
regression from Linux 3.2 -- unfortunately, bisection has proved
extremely difficult because the intermediate kernels git is asking me
to test panic immediately on boot (and compiling Linux takes a fairly
long time on this box too).  The failed attempt went like this:

  git bisect start 'drivers/gpu'
  # bad: [c16fa4f2ad19908a47c63d8fa436a1178438c7e7] Linux 3.3
  git bisect bad c16fa4f2ad19908a47c63d8fa436a1178438c7e7
  # good: [805a6af8dba5dfdd35ec35dc52ec0122400b2610] Linux 3.2
  git bisect good 805a6af8dba5dfdd35ec35dc52ec0122400b2610
  # skip: [5d56fe5fd794a98c4f446f8665fd06b82e93ff64] Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next
  git bisect skip 5d56fe5fd794a98c4f446f8665fd06b82e93ff64
  # good: [dffc9ceb55695f121adc57dd1fde7304c3afe81e] gma500: kill virtual mapping support
  git bisect good dffc9ceb55695f121adc57dd1fde7304c3afe81e
  # skip: [5c2a5ce689c99037771a6c110374461781a6f042] drm: add missing exports for i810 driver.
  git bisect skip 5c2a5ce689c99037771a6c110374461781a6f042
  # skip: [44517c44496062180a6376cc704b33129441ce60] drm/radeon/kms: Add an MSI quirk for Dell RS690
  git bisect skip 44517c44496062180a6376cc704b33129441ce60

  (I stopped at this point)

I'm running the latest git xf86-video-nouveau, but since the issue
occurs at the console it's probably not too important...

Let me know if you need any more info,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

