Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab0FEUw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 16:52:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63029 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab0FEUwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 16:52:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: hp_sdc_rtc: fix broken ioctl conversion
Date: Sat, 5 Jun 2010 22:52:21 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <201005241600.o4OG0QuA012887@hera.kernel.org> <AANLkTil7N3ZJclwotDQVt-8IYKudZ5mqPbyH906Cd4IJ@mail.gmail.com>
In-Reply-To: <AANLkTil7N3ZJclwotDQVt-8IYKudZ5mqPbyH906Cd4IJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201006052252.21168.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18j5tkx3Zk+oAv8185FFMDijP4l5dYugc+N7yi
 7p+lAwQRL/c3AqVtWHGsBKForqHeFcVBcQUCqAa6TRNuphEoeB
 RYhQpwTi/ZCv62r55WgCg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 55929332c92 "drivers: Push down BKL into various drivers"
introduced a regression in hp_sdc_rtc, caused by a missing
change of the .unlocked_ioctl pointer to the newly introduced
function.

On Saturday 05 June 2010, Geert Uytterhoeven wrote:
> Something went wrong with this one:
> 
> | drivers/input/misc/hp_sdc_rtc.c:681: warning: initialization from
> incompatible pointer type
> | drivers/input/misc/hp_sdc_rtc.c:665: warning:
> ‘hp_sdc_rtc_unlocked_ioctl’ defined but not used

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index e00a1cc..c190664 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -678,7 +678,7 @@ static const struct file_operations hp_sdc_rtc_fops = {
         .llseek =		no_llseek,
         .read =			hp_sdc_rtc_read,
         .poll =			hp_sdc_rtc_poll,
-        .unlocked_ioctl = 	hp_sdc_rtc_ioctl,
+        .unlocked_ioctl =	hp_sdc_rtc_unlocked_ioctl,
         .open =			hp_sdc_rtc_open,
         .fasync =		hp_sdc_rtc_fasync,
 };
