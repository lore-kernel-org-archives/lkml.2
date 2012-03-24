Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2CXK1W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 06:27:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49999 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab2CXK1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 06:27:20 -0400
Date: Sat, 24 Mar 2012 14:26:12 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>, Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org
Subject: [PATCH v2 0/10] Fixes for common mistakes w/ for_each_process and
 task->mm
Message-ID: <20120324102609.GA28356@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a reincarnation of the task->mm fixes. Several architectures
were traverse the tasklist in an unsafe manner, plus there are a
few cases of unsafe access to task->mm.

In v2 I decided to introduce a small helper in cpu.c: most arches
duplicate the same [buggy] code snippet, so it's better to fix it
and move the logic into a common function.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
