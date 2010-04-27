Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0D0TDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:03:17 -0400
Received: from smtp.getmail.no ([84.208.15.66]:42990 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab0D0TDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:03:16 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
X-PMX-Version: 5.5.3.366731, Antispam-Engine: 2.7.0.366912,
 Antispam-Data: 2010.4.27.184815
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Psychovisually-optimized HZ setting (2.6.33.3)
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com>
 <4BC588CF.5010507@redhat.com> <1902445479.2078.458.camel@ymzhang.sh.intel.com>
 <4BC6C8CD.1020801@redhat.com> <1902473858.2078.481.camel@ymzhang.sh.intel.com>
Date: Tue, 27 Apr 2010 21:03:11 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.vbt4jlyn6426ze@millennium.getinternet.no>
In-reply-to: <1902473858.2078.481.camel@ymzhang.sh.intel.com>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on the research I did with optimizing my machine for  
graphics.
I also wrote the following article:  
http://www.paradoxuncreated.com/articles/Millennium/Millennium.html
It is a bit outdated now, but I will update it with current information.
The value might iterate.

Peace Be With You,
Uwaysi Bin Kareem.


--- Kconfig.hzorig	2010-04-27 13:33:10.302162524 +0200
+++ Kconfig.hz	2010-04-27 20:39:54.736959816 +0200
@@ -45,6 +45,18 @@
  	 1000 Hz is the preferred choice for desktop systems and other
  	 systems requiring fast interactive responses to events.

+	config HZ_3956
+		bool "3956 HZ"
+	help
+	 3956 Hz is nearly the highest timer interrupt rate supported in the  
kernel.
+	 Graphics workstations, and OpenGL applications may benefit from this,
+	 since it gives the lowest framerate-jitter. The exact value 3956 is
+	 psychovisually-optimized, meaning that it aims for a level of jitter,
+	 percieved to be natural, and therefore non-nosiy. It is tuned for a
+	 profile of "where the human senses register the most information".
+	
+	
+
  endchoice

  config HZ
@@ -53,6 +65,7 @@
  	default 250 if HZ_250
  	default 300 if HZ_300
  	default 1000 if HZ_1000
+	default 3956 if HZ_3956

  config SCHED_HRTICK
  	def_bool HIGH_RES_TIMERS && (!SMP || USE_GENERIC_SMP_HELPERS)

