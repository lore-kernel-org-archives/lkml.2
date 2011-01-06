Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab1AFM6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 07:58:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56033 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1AFM6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 07:58:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=uecwrYP7sm3ppl7UzXBIUFlG6Eq/znmtahYJ31GOb78IhG2Xmbu8Cd17P5dUbmJlFx
         GQZjHT/Jlv5BouO1gA9gxTS5ppe93t16AGv2HMoIG01CMqdi0Rv/AEB28lKuOn9rEyHH
         XJiPVG4xDsKZ7fBdmDqIBWvyO45gr/irNkLYY=
MIME-Version: 1.0
Date: Thu, 6 Jan 2011 20:58:12 +0800
Message-ID: <AANLkTinOPuYsVovrZpbuCCmG5deEyc8WgA_A1RJx_YK7@mail.gmail.com>
Subject: [PATCH] sched: fix strncmp operation
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the operands, buf, is incorrect, since it is stripped and the
correct address for subsequent string comparing could change if
leading white spaces, if any, are removed from buf.

It is fixed by replacing buf with cmp.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched.c	2010-11-01 19:54:12.000000000 +0800
+++ b/kernel/sched.c	2011-01-06 20:52:02.000000000 +0800
@@ -751,7 +751,7 @@ sched_feat_write(struct file *filp, cons
 	buf[cnt] = 0;
 	cmp = strstrip(buf);

-	if (strncmp(buf, "NO_", 3) == 0) {
+	if (strncmp(cmp, "NO_", 3) == 0) {
 		neg = 1;
 		cmp += 3;
 	}
