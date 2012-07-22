Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab2GVPDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 11:03:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53752 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2GVPDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 11:03:16 -0400
MIME-Version: 1.0
From: Alexandre Ferrando <alferpal@gmail.com>
Date: Sun, 22 Jul 2012 17:02:34 +0200
Message-ID: <CALELsEM07z6BckpSvEUrdJU5T3715uED=9g=K3OicnjRP=O6nw@mail.gmail.com>
Subject: PROBLEM: Build fails in 3.4.6
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary: Linux kernel 3.4.6 fails to build in some cases when
CONFIG_NO_HZ is set

Full description: Kernel build using configurations [ 0 ] (mine,
trying to build the zen kernel) and [ 1 ] (from someone using
slackware) fail to build with this error message when CONFIG_NO_HZ is
set:

kernel/built-in.o: In function `tick_nohz_stop_sched_tick.isra.9':
tick-sched.c:(.text+0x4a3e9): undefined reference to `calc_load_enter_idle'
kernel/built-in.o: In function `tick_nohz_idle_exit':
(.text+0x4a767): undefined reference to `calc_load_exit_idle'

Unsetting CONFIG_NO_HZ solves the issue.

However, CONFIG_NO_HZ seems not to be the root of the problem because
this configuration [ 2 ] of the zen kernel and Arch's stock kernel [ 3
] both build with CONFIG_NO_HZ set

[ 0 ] https://bugzilla.kernel.org/attachment.cgi?id=75791

[ 1 ] https://bugzilla.kernel.org/attachment.cgi?id=75781

[ 2 ] http://pkgbuild.com/~heftig/linux-zen/config.x86_64

[ 3 ] http://sprunge.us/RHWO

PS: It's my first time reporting an issue to this mailing list, so in
case the input is missing something, please tell me so I can give a
more accurate input.
