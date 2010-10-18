Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab0JRXjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:39:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118Ab0JRXjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:39:49 -0400
Date: Mon, 18 Oct 2010 16:39:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH v2][GIT PULL] ftrace: Remove recursion between
 recordmcount and scripts/mod/empty
Message-Id: <20101018163935.48260a13.akpm@linux-foundation.org>
In-Reply-To: <1287437213.16971.333.camel@gandalf.stny.rr.com>
References: <1287437213.16971.333.camel@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 17:26:53 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Please pull the latest tip/perf/recordmcount-2 tree

Today's linux-next has some problems.

make mrproper
make allmodconfig
make

  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  HOSTCC  scripts/genksyms/genksyms.o
  SHIPPED scripts/genksyms/lex.c
  SHIPPED scripts/genksyms/parse.h
  SHIPPED scripts/genksyms/keywords.c
  HOSTCC  scripts/genksyms/lex.o
  SHIPPED scripts/genksyms/parse.c
  HOSTCC  scripts/genksyms/parse.o
  HOSTLD  scripts/genksyms/genksyms
  CC      scripts/mod/empty.o
/bin/sh: /usr/src/25/scripts/recordmcount: No such file or directory

If you run `make' a few times, scritps/recordmcount eventually turns
up and the build runs OK.  Some ordering thing or a race or whatever?
