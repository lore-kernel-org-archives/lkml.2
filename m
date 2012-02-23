Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2BWRCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:02:01 -0500
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:35189 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2BWRB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:01:59 -0500
X-Greylist: delayed 1718 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Feb 2012 12:01:59 EST
Message-ID: <4F4669B1.4020306@tu-ilmenau.de>
Date: Thu, 23 Feb 2012 17:30:41 +0100
From: =?UTF-8?B?U3RlcGhhbiBCw6Ryd29sZg==?= 
	<stephan.baerwolf@tu-ilmenau.de>
Reply-To: stephan.baerwolf@tu-ilmenau.de
Organization: TU-Ilmenau
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120217 Thunderbird/10.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Buesch <mb@bu3sch.de>, Chris Wilson <chris@chris-wilson.co.uk>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: responsiveness: newer kernels causing lagging and blocking
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under various conditions linux since 2.6.39-rc1 laggs and blocks enormously the whole system.
(For example while starting "winecfg" (on a thinkpad X220) and parallel moving the
mousecursor you can observe a periodic blocking for some seconds)

After bisecting a little while, commit "4819d2e4310796c4e9eef674499af9b9caf36b5a"
(" drm: Retry i2c transfer of EDID block after failure ") seems to be responsible.

Because function "drm_do_probe_ddc_edid" loops trying "i2c_transfer" it consumes a lot
of time during errors. Reverting or changing "retries" from 5 to 1 extremly minimizes the
problem to "not perceptible".
It seems the locking within "i2c_transfer" slows everything down.
So maybe it is possible to yield() before calling it?


regards Stephan
