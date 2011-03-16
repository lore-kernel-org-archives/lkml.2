Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1CPQOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 12:14:41 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:54007 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab1CPQOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 12:14:33 -0400
Date: Wed, 16 Mar 2011 17:10:11 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Clemens Ladisch <clemens@ladisch.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound/core: merge list_del()/list_add_tail() to
 list_move_tail()
Message-ID: <20110316171011.5070ecb2@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge list_del() + list_add_tail() to list_move_tail().

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 sound/core/timer.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/sound/core/timer.c b/sound/core/timer.c
index ed01632..7c1cbf0 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -186,9 +186,8 @@ static void snd_timer_check_slave(struct snd_timer_instance *slave)
 		list_for_each_entry(master, &timer->open_list_head, open_list) {
 			if (slave->slave_class == master->slave_class &&
 			    slave->slave_id == master->slave_id) {
-				list_del(&slave->open_list);
-				list_add_tail(&slave->open_list,
-					      &master->slave_list_head);
+				list_move_tail(&slave->open_list,
+					       &master->slave_list_head);
 				spin_lock_irq(&slave_active_lock);
 				slave->master = master;
 				slave->timer = master->timer;
@@ -414,8 +413,7 @@ static void snd_timer_notify1(struct snd_timer_instance *ti, int event)
 static int snd_timer_start1(struct snd_timer *timer, struct snd_timer_instance *timeri,
 			    unsigned long sticks)
 {
-	list_del(&timeri->active_list);
-	list_add_tail(&timeri->active_list, &timer->active_list_head);
+	list_move_tail(&timeri->active_list, &timer->active_list_head);
 	if (timer->running) {
 		if (timer->hw.flags & SNDRV_TIMER_HW_SLAVE)
 			goto __start_now;
-- 
1.7.3.4
