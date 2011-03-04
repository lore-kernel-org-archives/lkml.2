Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab1CDDgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 22:36:49 -0500
Received: from smtp.getmail.no ([84.208.15.66]:50032 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758483Ab1CDDgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 22:36:48 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
In-reply-to: <4D6CD10E.3050805@ladisch.de>
References: <op.vrm3n5yy6426ze@millennium> <4D6CD10E.3050805@ladisch.de>
Subject: Renicing for OpenGL smoothness.
To: linux-kernel@vger.kernel.org
Date: Fri, 04 Mar 2011 04:36:43 +0100
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.vrsuzhju6426ze@millennium>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiya. I'm sitting here playing some OpenGL games, and thinking, isn't it  
rude of processes demanding the same amount of cpu, when I am here,  
wanting the smoothest possible OpenGL experience.

So I am renicing. But my knowledge of the kernel is limited. So I was  
thinking, maybe some of you could inform me, which processes are involved  
in getting the graphics on-screen.

I have already started making a renicing script.

---

highpri=-20;
lowpri=19;
for pid in `pgrep ""`; do renice -n $lowpri -p $pid; done #ubuntu runs a  
lot of processes that can be put in the background.
for pid in `pgrep "init"`; do renice -n $highpri -p $pid; done #probably  
good to have high priority?
for pid in `pgrep "kthreadd"`; do renice -n $highpri -p $pid; done #does  
drivers or anything else create kernel threads that are involved in the  
graphics on-screen?
for pid in `pgrep "ksoftirq"`; do renice -n $highpri -p $pid; done #surely  
these are?
for pid in `pgrep "X"`; do renice -n $highpri -p $pid; done
for pid in `pgrep "metacity"`; do renice -n $highpri -p $pid; done
for pid in `pgrep "hd-audio0"`; do renice -n $highpri -p $pid; done

--
Comments and information appreciated.
