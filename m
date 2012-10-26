Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab2JZNzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:55:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab2JZNy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:54:59 -0400
Date: Fri, 26 Oct 2012 15:00:07 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 4/5] perf tools: Always show CHK message when doing try-cc
Message-ID: <20121026130007.GB1067@krava.brq.redhat.com>
References: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
 <1351241752-2919-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351241752-2919-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 05:55:51PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It might be useful to see what's happening behind us rather than just
> waiting few seconds during the config checking.

Do we want to see all that within just simple 'make'
also in case nothing gets rebuilt? It seems noisy..


[jolsa@krava perf]$ make
    CHK -fstack-protector-all
    CHK -Wstack-protector
    CHK -Wvolatile-register-var
    CHK bionic
    CHK libelf
    CHK libdw
    CHK libunwind
    CHK -DLIBELF_MMAP
    CHK libaudit
    CHK libnewt
    CHK gtk2
Makefile:608: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
    CHK perl
    CHK python
    CHK python version
    CHK libbfd
    CHK -DHAVE_STRLCPY
    CHK -DHAVE_ON_EXIT
    CHK -DBACKTRACE_SUPPORT
    SUBDIR ../lib/traceevent/
    LINK perf

hum, also not sure why's there ^^^ the final LINK for no change rebuild..

jirka
