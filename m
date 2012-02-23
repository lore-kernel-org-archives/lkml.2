Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2BWA5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:57:15 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60585 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab2BWA5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:57:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of chris.diamand@gmail.com designates 10.180.92.229 as permitted sender) smtp.mail=chris.diamand@gmail.com; dkim=pass header.i=chris.diamand@gmail.com
From: Chris Diamand <chris.diamand@gmail.com>
To: kristoffer.ericson@gmail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Chris Diamand <chris.diamand@gmail.com>
Subject: [PATCH] Jornada 720: Fixes "Invalid argument" when changing backlight brightness.
Date: Thu, 23 Feb 2012 00:57:30 +0000
Message-Id: <1329958651-8575-1-git-send-email-chris.diamand@gmail.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry - this patch I just sent is for kernels 2.6.24/2.6.26.
(I think it's actually been fixed on versions >3.0 but they versions don't
seem to work on the jornada for various other reasons...)

Thanks,
Chris.

---------------------
On jornada 720. Running:
echo n > /sys/class/backlight/s1d13806fb/brightness
would give a "write error: Invalid argument" as the max_brightness
was not set, so any value other that 0 exceeds it. Now sets
max_brightness to 255 when the module is loaded.

Backlight can also be turned on and off using
echo 0-4 > /sys/class/backlight/s1d13806fb/bl_power

Also added some extra braces so jornada720_ssp.c.

