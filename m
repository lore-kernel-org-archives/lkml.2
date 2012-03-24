Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2CXM0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 08:26:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52714 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab2CXM0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 08:26:40 -0400
MIME-Version: 1.0
From: Ulrich Drepper <drepper@gmail.com>
Date: Sat, 24 Mar 2012 08:26:19 -0400
Message-ID: <CAOPLpQe+SP7Nvr_EU44hcCu3UXVtF84EmL-_eskA1UfGr6JrPQ@mail.gmail.com>
Subject: last fs/proc/array.c change
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure whether this has already been reported, at least I haven't
seen it.  A recent patch to fs/proc/array.c contained this:


-       seq_printf(m, "%lu %lu %lu %lu 0 %lu 0\n",
-                       size, resident, shared, text, data);
+       /*
+        * For quick read, open code by putting numbers directly
+        * expected format is
+        * seq_printf(m, "%lu %lu %lu %lu 0 %lu 0\n",
+        *               size, resident, shared, text, data);
+        */
+       seq_put_decimal_ull(m, 0, size);
+       seq_put_decimal_ull(m, ' ', resident);
+       seq_put_decimal_ull(m, ' ', shared);
+       seq_put_decimal_ull(m, ' ', text);
+       seq_put_decimal_ull(m, ' ', 0);
+       seq_put_decimal_ull(m, ' ', text);
+       seq_put_decimal_ull(m, ' ', 0);
+       seq_putc(m, '\n');


See the second to last seq_put_decimal_ull.  This is a copy&paste
mistake since given the original format it should read

+       seq_put_decimal_ull(m, ' ', data);

(i.e., data instead of text).
