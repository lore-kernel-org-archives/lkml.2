Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab1AUNyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:54:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51027 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1AUNyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:54:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=HDUb03hBx1ShFogVC0dOPAYySKYGp1u7UyWZFJ+21aET4+uNQh4onFXqqoT1EfDKRp
         pn7IRwU53kb9j7krbGq3/+7t93Ikglojr1S6x6IdKuov+xAhHax/DvnHSxV86budkfKj
         sxKratgpvEZRpWi27KAN69qEdQakiV+TJ+tD4=
MIME-Version: 1.0
Date: Fri, 21 Jan 2011 21:54:19 +0800
Message-ID: <AANLkTi=kcpiXAFAy9c31qU+4u=BHckSec29C5Khm3gxC@mail.gmail.com>
Subject: x86_64: could increment fp when getting wchan?
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When getting wchan (wait channel?) the stack of given task is scanned
for IP that is not in the scheduling area. What looks odd is the IP
could be checked as many times as allowed in the loop without changing
the location on stack. Could the IP be checked up stair the stack?

Hillf
---

--- a/arch/x86/kernel/process_64.c	2011-01-05 08:50:20.000000000 +0800
+++ b/arch/x86/kernel/process_64.c	2011-01-21 21:46:04.000000000 +0800
@@ -543,7 +543,7 @@ unsigned long get_wchan(struct task_stru
 		ip = *(u64 *)(fp+8);
 		if (!in_sched_functions(ip))
 			return ip;
-		fp = *(u64 *)fp;
+		fp += 8;
 	} while (count++ < 16);
 	return 0;
 }
