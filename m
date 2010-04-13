Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab0DMVyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:54:35 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:43213 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab0DMVyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:54:33 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.589
Message-ID: <4BC4E812.6050602@tremplin-utc.net>
Date: Tue, 13 Apr 2010 23:54:26 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Since 2.6.34-rc*, I have a regression on alsa which prevents the sound
to be played correctly. When playing, the music goes too fast, skipping
some parts. Typically, it's very easy to reproduce by doing:
time mplayer -endpos 30 sound-file-which-lasts-more-than-thirty-sec.mp3

If the wall clock is less than 30s, you have the bug. With my intel-hda
(AD1981), it's reliably reproducible: it gives ~27s, instead of the
normal ~31s.

After bisection, it turns out that it is commit
7b3a177b0d4f92b3431b8dca777313a07533a710, aka "ALSA: pcm_lib: fix
"something must be really wrong" condition" which caused this
regression. Reverting it on top of 2.6.34-rc3+ fixes the problem.

Let me know if you need more info,
Cheers,
Eric

PS: For the info, the bisection was especially hard to do because about
80 alsa commits around the faulty one were all applied on kernel
versions which did not boot on my laptop. On top of the first known bad
I had to revert all of them, and run an "invert bisection" on it...
Enjoy the bisection result ;-)
