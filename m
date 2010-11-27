Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0K0PQO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:16:14 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:4976 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab0K0PQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:16:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19697.8378.717761.236202@pilspetsen.it.uu.se>
Date: Sat, 27 Nov 2010 16:16:10 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scenario is that I do a remote login to an ARM build server,
use screen to start a sub-shell, in that shell start a largish
compile job, detach from that screen, and from the original login
shell I occasionally monitor the compile job with top or ps or
by attaching to the screen.

With kernels 2.6.37-rc2 and -rc3 this causes the machine to become
very sluggish: top takes forever to start, once started it shows no
activity from the compile job (it's as if it's sleeping on a lock),
and ps also takes forever and shows no activity from the compile job.

Rebooting into 2.6.36 eliminates these issues.

I do pretty much the same thing (remote login -> screen -> compile job)
on other archs, but so far I've only seen the 2.6.37-rc misbehaviour
on ARM EABI, specifically on an IOP n2100. (I have access to other ARM
sub-archs, but haven't had time to test 2.6.37-rc on them yet.)

Has anyone else seen this? Any ideas about the cause?

/Mikael
