Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2JZAFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:05:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:52251 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab2JZAFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:05:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: =?UTF-8?q?=5B=2000/31=5D=203=2E0=2E49-stable=20review?=
Date: Thu, 25 Oct 2012 17:04:07 -0700
Message-Id: <20121026000214.941721299@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.49 release.
There are 31 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Oct 28 00:01:59 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.49-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Elric Fu <elricfu1@gmail.com>
    xHCI: handle command after aborting the command ring

Elric Fu <elricfu1@gmail.com>
    xHCI: cancel command after command timeout

Elric Fu <elricfu1@gmail.com>
    xHCI: add aborting command ring function

Elric Fu <elricfu1@gmail.com>
    xHCI: add cmd_ring_state

David S. Miller <davem@davemloft.net>
    sparc64: Be less verbose during vmemmap population.

Jiri Kosina <jkosina@suse.cz>
    sparc64: do not clobber personality flags in sys_sparc64_personality()

David S. Miller <davem@davemloft.net>
    sparc64: Fix bit twiddling in sparc_pmu_enable_event().

David S. Miller <davem@davemloft.net>
    sparc64: Like x86 we should check current->mm during perf backtrace generation.

Al Viro <viro@zeniv.linux.org.uk>
    sparc64: fix ptrace interaction with force_successful_syscall_return()

Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
    tcp: resets are misrouted

jeff.liu <jeff.liu@oracle.com>
    RDS: fix rds-ping spinlock recursion

Graham Gower <graham.gower@gmail.com>
    skge: Add DMA mask quirk for Marvell 88E8001 on ASUS P5NSLI motherboard

ramesh.nagappa@gmail.com <ramesh.nagappa@gmail.com>
    net: Fix skb_under_panic oops in neigh_resolve_output

Jesse Barnes <jbarnes@virtuousgeek.org>
    drm/i915: apply timing generator bug workaround on CPT and PPT

Devin Heitmueller <dheitmueller@kernellabs.com>
    media: au0828: fix case where STREAMOFF being called on stopped stream causes BUG()

Andrew Morton <akpm@linux-foundation.org>
    amd64_edac:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]

Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
    cgroup: notify_on_release may not be triggered in some cases

Bjørn Mork <bjorn@mork.no>
    USB: option: add more ZTE devices

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist net interface on ZTE devices

Nicolas Boullis <nboullis@debian.org>
    usb: acm: fix the computation of the number of data bits

Ming Lei <ming.lei@canonical.com>
    USB: cdc-acm: fix pipe type of write endpoint

David Vrabel <david.vrabel@citrix.com>
    xen/x86: don't corrupt %eip when returning from a signal handler

Jacob Shin <jacob.shin@amd.com>
    x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.

Kees Cook <keescook@chromium.org>
    use clamp_t in UNAME26 fix

Kees Cook <keescook@chromium.org>
    kernel/sys.c: fix stack memory content leak via UNAME26

Arnd Bergmann <arnd@arndb.de>
    pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert: lockd: use rpc client's cl_nodename for id encoding

Sasha Levin <levinsasha928@gmail.com>
    SUNRPC: Prevent kernel stack corruption on long values of flush

Dan Carpenter <dan.carpenter@oracle.com>
    oprofile, x86: Fix wrapping bug in op_x86_get_ctrl()

Trond Myklebust <Trond.Myklebust@netapp.com>
    NLM: nlm_lookup_file() may return NLMv4-specific error codes

Chris Metcalf <cmetcalf@tilera.com>
    arch/tile: avoid generating .eh_frame information in modules


-------------

Diffstat:

 Makefile                                  |   4 +-
 arch/sparc/kernel/perf_event.c            |  15 +-
 arch/sparc/kernel/sys_sparc_64.c          |  10 +-
 arch/sparc/kernel/syscalls.S              |  32 ++--
 arch/sparc/mm/init_64.c                   |  28 ++-
 arch/tile/Makefile                        |   4 +
 arch/x86/kernel/entry_32.S                |   8 +-
 arch/x86/kernel/entry_64.S                |   2 +-
 arch/x86/kernel/setup.c                   |  17 +-
 arch/x86/oprofile/nmi_int.c               |   2 +-
 drivers/edac/amd64_edac.c                 |  11 +-
 drivers/gpu/drm/i915/i915_reg.h           |   5 +
 drivers/gpu/drm/i915/intel_display.c      |   4 +
 drivers/media/video/au0828/au0828-video.c |  12 +-
 drivers/net/skge.c                        |   7 +
 drivers/pcmcia/pxa2xx_sharpsl.c           |   2 +-
 drivers/usb/class/cdc-acm.c               |  22 ++-
 drivers/usb/host/xhci-mem.c               |   7 +
 drivers/usb/host/xhci-ring.c              | 282 +++++++++++++++++++++++++++++-
 drivers/usb/host/xhci.c                   |  33 +++-
 drivers/usb/host/xhci.h                   |  22 +++
 drivers/usb/serial/option.c               |  92 +++++++---
 fs/lockd/clntxdr.c                        |   2 +-
 fs/lockd/mon.c                            |   4 +-
 fs/lockd/svcproc.c                        |   3 +-
 kernel/cgroup.c                           |   3 +-
 kernel/sys.c                              |  12 +-
 net/core/neighbour.c                      |   6 +-
 net/ipv4/tcp_ipv4.c                       |   7 +-
 net/ipv6/tcp_ipv6.c                       |   3 +-
 net/rds/send.c                            |   2 +-
 net/sunrpc/cache.c                        |   4 +-
 32 files changed, 546 insertions(+), 121 deletions(-)


