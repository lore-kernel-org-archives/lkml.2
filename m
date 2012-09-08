Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401Ab2IHAtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:49:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60932 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760375Ab2IHAs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:48:59 -0400
Date: Fri, 7 Sep 2012 17:48:54 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET RESEND 0/5] perf tools: Cleanup hist printing code (v4)
Message-ID: <20120908004854.GD20401@ghostprotocols.net>
References: <1346640790-17197-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346640790-17197-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 03, 2012 at 11:53:05AM +0900, Namhyung Kim escreveu:
> This is a cleanup and refactoring patchset for the hist printing code
> by adding perf_hpp__format functions and perf_hpp.  I believe it makes
> the code easy to maintain and to add new features like upcoming group
> viewing and callchain accumulation.

I applied this patch series to then get some patches from Jiri's 'perf
diff' series, so that he can use what you did here, as you noticed the
overlap when reviewing his series.

But then 'perf diff' segfaults :-\

I left your patch series + with that overhead column fixlet at my tree,
branch tmp.perf/hpp.

The segfaults happens here:

Program received signal SIGSEGV, Segmentation fault.
0x0000000000498837 in hpp__entry_delta (hpp=0x7fffffffdeb0, he=0xcd6310) at ui/hist.c:200
200			old_percent = 100.0 * he->pair->period / old_total;
Missing separate debuginfos, use: debuginfo-install atk-1.28.0-2.el6.x86_64 bzip2-libs-1.0.5-7.el6_0.x86_64 elfutils-libelf-0.152-1.el6.x86_64 elfutils-libs-0.152-1.el6.x86_64 expat-2.0.1-11.el6_2.x86_64 fontconfig-2.8.0-3.el6.x86_64 freetype-2.3.11-6.el6_2.9.x86_64 glib2-2.22.5-7.el6.x86_64 gtk2-2.18.9-10.el6.x86_64 libX11-1.3-2.el6.x86_64 libXau-1.0.5-1.el6.x86_64 libXcomposite-0.4.1-2.el6.x86_64 libXcursor-1.1.10-2.el6.x86_64 libXdamage-1.1.2-1.el6.x86_64 libXext-1.1-3.el6.x86_64 libXfixes-4.0.4-1.el6.x86_64 libXi-1.3-3.el6.x86_64 libXinerama-1.1-1.el6.x86_64 libXrandr-1.3.0-4.el6.x86_64 libXrender-0.9.5-1.el6.x86_64 libpng-1.2.49-1.el6_2.x86_64 libselinux-2.0.94-5.3.el6.x86_64 libxcb-1.5-1.el6.x86_64 nss-softokn-freebl-3.12.9-11.el6.x86_64 pango-1.28.1-3.el6_0.5.x86_64 perl-libs-5.10.1-127.el6.x86_64 pixman-0.18.4-1.el6_0.1.x86_64 xz-libs-4.999.9-0.3.beta.20091007git.el6.x86_64 zlib-1.2.3-27.el6.x86_64
(gdb) p he->pair
$1 = (struct hist_entry *) 0x0

Please try with:

  perf record -a usleep 1
  perf record -a usleep 1
  perf diff

it will use perf.data.old and perf.data and will segfault in that branch.

- Arnaldo
