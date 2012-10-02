Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2JBBK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 21:10:59 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53599 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2JBBK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 21:10:57 -0400
MIME-Version: 1.0
Date: Mon, 1 Oct 2012 21:10:57 -0400
Message-ID: <CAOvdn6WemnDgO4wb5xutMiVBVTrZUrX3Nn8hQXVsJML6cRMPcg@mail.gmail.com>
Subject: linux-next: build failure in dwarf-regs.c
From: Ben Guthro <ben.guthro@gmail.com>
To: Ian Munsie <imunsie@au.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I pulled the latest bits up to
797b9e5ae93270ec27a1f1ed48cd697d01b2269f - but am seeing the following
build failure with gcc 4.6.3

 CC arch/x86/util/dwarf-regs.o
arch/x86/util/dwarf-regs.c:72:13: error: no previous prototype for
'get_arch_regstr' [-Werror=missing-prototypes]
cc1: all warnings being treated as errors
make[3]: *** [arch/x86/util/dwarf-regs.o] Error 1
make[3]: Leaving directory
`/data/home/bguthro/dev/orc-newdev.git/linux/build/tools/tools/perf'
make[2]: *** [build-linux-tools] Error 2
make[2]: Leaving directory `/data/home/bguthro/dev/orc-newdev.git/linux'
make[1]: *** [install-kernel] Error 2
make[1]: Leaving directory `/data/home/bguthro/dev/orc-newdev.git/orc-kernel'
make: *** [dist-kernels] Error 2


git blame shows that line coming in from the following changeset -
though April is a long time ago in kernel time - so this must have
come in with some other merge in this 3.7 window

commit cd932c593995abee1d1a8a0bfe608f7d103d87ad
Author: Ian Munsie <imunsie@au.ibm.com>
Date:   Tue Apr 20 16:58:32 2010 +1000

    perf: Move arch specific code into separate arch directory

    The perf userspace tool included some architecture specific code to map
    registers from the DWARF register number into the names used by the regs
    and stack access API.

    This moves the architecture specific code out into a separate
    arch/x86 directory along with the infrastructure required to use it.

    Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
    Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>


Apologies to Ian, who may reciece this multiple times, as I worked out
some email bounce issues with LKML
