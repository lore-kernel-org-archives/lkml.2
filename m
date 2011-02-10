Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1BJCf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:35:58 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35718 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1BJCf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:35:57 -0500
X-AuditID: b753bd60-a50bbba000004916-f3-4d534f0b228a
X-AuditID: b753bd60-a50bbba000004916-f3-4d534f0b228a
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/makefile  0/2] Perf bugfixes for cross-builds
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Date: Thu, 10 Feb 2011 11:28:47 +0900
Message-ID: <20110210022847.15395.31441.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are some bugfixes related to cross builds.
- Introduce ARCH=XX for cross-builds instead of obsolate
  EXTRA_CFLAGS=-mXX option.
- Rename obsolate NO_PERL to NO_LIBPERL

Still not sure how I can do cross-builds i386 binary with
perl/python support on x86-64. Anyway, now we can do without
that as below;

 $ make ARCH=i386 NO_LIBPERL=1 NO_LIBPYTHON=1

Thank you,

---

Masami Hiramatsu (2):
      perf tools: Rename old NO_PERL option to NO_LIBPERL
      perf tools: Introduce ARCH= option for cross building


 tools/perf/Makefile              |   48 +++++++++++++++++++++++++-------------
 tools/perf/arch/arm/Makefile     |    2 +-
 tools/perf/arch/powerpc/Makefile |    2 +-
 tools/perf/arch/s390/Makefile    |    2 +-
 tools/perf/arch/sh/Makefile      |    2 +-
 tools/perf/arch/sparc/Makefile   |    2 +-
 tools/perf/arch/x86/Makefile     |    2 +-
 7 files changed, 38 insertions(+), 22 deletions(-)

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

