Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1KLOpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 09:45:10 -0500
Received: from phobos.b-et-a.de ([80.237.154.114]:39832 "HELO un.b-et-a.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753820Ab1KLOpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 09:45:09 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Nov 2011 09:45:08 EST
Date: Sat, 12 Nov 2011 15:38:25 +0100
From: Klaus Ripke <klaus@ripke.com>
To: linux-kernel@vger.kernel.org
Subject: LOAD_FREQ (4*HZ+61) avoids loadavg Moire
Message-ID: <20111112143825.GX6192@aine.Speedport_W_502V_Typ_A>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LOAD_FREQ is (5*HZ+1) to avoid high load average when idle:
http://kerneltrap.org/mailarchive/linux-kernel/2007/10/3/328568

I suggest (4*HZ+61) for a better distribution.

With some seconds based load (like SSL heartbeats)
and LOAD_FREQ at (5*HZ+1) I see Moire patterns like inverse sawtooth,
since 2 or 3 probes hit the jobs (load increases quickly),
followed by several probes missing it.


A 4.61 sec interval gives optimal distribution over when within a
second a probe is taken, as .61 is close to golden ratio phi 1.618...
(test in http://ripke.com/goldenratio.c).

12*4.61 = 55.32 secs is still close to a minute,
and 13*4.61=59.93 is even closer than the current 12*5.01=60.12
(with exponents EXP_x adjusted to a ratio of 13 instead of 12).


best
Klaus
