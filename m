Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab0KFPtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 11:49:15 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40779 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0KFPtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 11:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type:content-transfer-encoding;
        b=xH3LTBCw2QjNt6uy4n8sDP1LSDsU0XGfcoNCEuCxpNQoYir8jN6ogtUXfMRlSxbiY4
         RhYYIer9ZA7MV6pqC6FO+YKtWe2kZZu2p4Je3eoSLEh6EmeyCxCAFmcAdJUsppSBT9tp
         ZXBSUEEgPPjSGEU46qhACO40muYq6oZE4ktrY=
From: Ben Gamari <bgamari.foss@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Bus error on make allyesconfig, kernelbuild with HEAD
In-Reply-To: <87d3qicwxn.fsf@gmail.com>
References: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de> <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com> <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de> <20100730084353.GB5638@cr0.nay.redhat.com> <87d3qicwxn.fsf@gmail.com>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sat, 06 Nov 2010 11:49:10 -0400
Message-ID: <87aalmcv0p.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Nov 2010 11:07:48 -0400, Ben Gamari <bgamari.foss@gmail.com> wrote:
> On Fri, 30 Jul 2010 16:43:53 +0800, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> > This is useful. :) Looks like parse_dep_file() accesses out of
> > the mmap'ed memory range...
> > 
> Did anything ever happen with this? I seem to be experiencing similar
> issues while cross-compiling for ARM on x86-64. All tested kernels
> (v2.6.35 to master) fail with,

Here is .fixdep.d:


fixdep.o: scripts/basic/fixdep.c \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/sys/types.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/features.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/sys/cdefs.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/wordsize.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/gnu/stubs.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/types.h \
 /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stddef.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/typesizes.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/time.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/endian.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/endian.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/byteswap.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/sys/select.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/select.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/sigset.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/time.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/sys/sysmacros.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/pthreadtypes.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/sys/stat.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/stat.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/sys/mman.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/mman.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/unistd.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/posix_opt.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/confname.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/getopt.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/unistd.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/fcntl.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/fcntl.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/fcntl2.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/string.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/xlocale.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/string.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/string2.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/stdlib.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/string3.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/alloca.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/stdlib.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/stdio.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/libio.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/_G_config.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/wchar.h \
 /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stdarg.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/stdio_lim.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/sys_errlist.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/stdio.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/stdio2.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/limits.h \
 /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include-fixed/limits.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/posix1_lim.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/local_lim.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/linux/limits.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/posix2_lim.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/ctype.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/arpa/inet.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/netinet/in.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/stdint.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/wchar.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/sys/socket.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/sys/uio.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/uio.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/socket.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/sockaddr.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/asm/socket.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/asm/sockios.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/socket2.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/in.h
