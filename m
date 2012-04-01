Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2DAQbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:31:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2DAQbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:31:36 -0400
MIME-Version: 1.0
Date: Mon, 2 Apr 2012 00:31:35 +0800
Message-ID: <CABexPfEdd0k9UGTJL9Ae5B=e_dDZMsTGg-LNYrOjLKzHBxuPwg@mail.gmail.com>
Subject: How can I turn off/disable -O2/-Os optimization?
From: Zhihua Che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone

    I'm debugging linux kernel using kgdb/qemu， but I find that the
execution order didn't math the program order usually.  I guess it was
because the compiling optimization. So I decided to remove -O options
in Makefiles.
    First I removed -Ox in variables HOSTCFLAGS/HOSTCXXFLAGS in
<src_root_dir>/Makefile around line 248 and -Ox in variable
KBUILD_CFLAGS in <src_root_dir>/arch/x86/boot/Makefile around line 55.
But it didn't work, the step execution still didn't follow the program
order. Then I found I missed -Ox in KBUILD_CFLAGS in
<src_root_dir>/Makefile around line 562, so I removed them, but this
time, the compiling failed, complaining
    rcupdate.h:917:2: error: size of unnamed array is negative
   And finally, after grep, I find there are a load of -O2 option are
assigned in a load of Makefiles. So, How could I disable -O
optimization for debugging?

   Thanks for any tips
