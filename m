Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1LQBqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 20:46:34 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48324 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab1LQBq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 20:46:28 -0500
MIME-Version: 1.0
From: Abhijit Hoskeri <abhijithoskeri@gmail.com>
Date: Fri, 16 Dec 2011 17:46:06 -0800
Message-ID: <CAESSSuBCVU9os04BFQO7+y9EeFos_xVau4rFkdVArL=Ux38Nhg@mail.gmail.com>
Subject: Out of tree modules now taint the kernel, print warnings like the
 other kinds of taint.
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Out of tree modules now taint the kernel, print warnings like the
other kinds of taint.

commit f78b85df0b5fab5ea25f4b747aff60412d8b9b43
Author: Abhijit Hoskeri <abhijithoskeri@gmail.com>
Date:   Fri Dec 16 16:00:49 2011 -0800

    Out of tree modules taint the kernel, but unlike other forms of
taint, there is no warning.

    Print a warning to match other forms of kernel taint.

    Signed-off-by: Abhijit Hoskeri <abhijithoskeri@gmail.com>

diff --git a/kernel/module.c b/kernel/module.c
index 178333c..9e084c4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2487,8 +2487,10 @@ static int check_modinfo(struct module *mod,
struct load_info *info)
                return -ENOEXEC;
        }

-       if (!get_modinfo(info, "intree"))
+       if (!get_modinfo(info, "intree")) {
+               printk(KERN_WARNING "%s: out of tree module taints
kernel\n", mod->name);
                add_taint_module(mod, TAINT_OOT_MODULE);
+       }

        if (get_modinfo(info, "staging")) {
                add_taint_module(mod, TAINT_CRAP);


Regards,
Abhijit
