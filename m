Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab0I0TU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:20:29 -0400
Received: from mail.agmk.net ([91.192.224.71]:59129 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab0I0TU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:20:28 -0400
X-Greylist: delayed 1726 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 15:20:27 EDT
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: git bisect selects commit outside initial bisect range?
Date: Mon, 27 Sep 2010 20:51:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-rc6-00551-g7a6cb0d; KDE/4.5.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009272051.33882.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i've noticed on kernel 2.6.35.y some weird screen blinking during
e.g. <alt-tab> on kde4 with enabled accelerated desktop effects.

i've started git bisect between good-v2.6.34 and bad-v2.6.35-rc1
and after few steps git-bisect jumps to commit before v2.6.34.

[~/src/linux/linux-2.6]$ make kernelrelease
2.6.34-rc6-00551-g7a6cb0d

[~/src/linux/linux-2.6]$ git bisect log
git bisect start
# good: [e40152ee1e1c7a63f4777791863215e3faa37a86] Linus 2.6.34
git bisect good e40152ee1e1c7a63f4777791863215e3faa37a86
# bad: [67a3e12b05e055c0415c556a315a3d3eb637e29e] Linux 2.6.35-rc1
git bisect bad 67a3e12b05e055c0415c556a315a3d3eb637e29e
# good: [f8965467f366fd18f01feafb5db10512d7b4422c] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6
git bisect good f8965467f366fd18f01feafb5db10512d7b4422c
# bad: [d79df0b1eda0099a22cbcece01ce5e7d222450de] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
git bisect bad d79df0b1eda0099a22cbcece01ce5e7d222450de
# good: [ac3ee84c604502240122c47b52f0542ec8774f15] Merge branch 'dbg-early-merge' of git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb
git bisect good ac3ee84c604502240122c47b52f0542ec8774f15

is it normal that bisect selects next step outside initial range?

BR,
Pawel.

ps).
please CC me on reply.
