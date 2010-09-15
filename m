Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab0IOF37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 01:29:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:15910 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab0IOF3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 01:29:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,369,1280732400"; 
   d="scan'208";a="607017627"
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>
In-Reply-To: <1284377790.2275.212.camel@laptop>
References: <1284360648.3269.115.camel@yhuang-dev.sh.intel.com>
	 <20100913123213.76b1b5fa@mschwide.boeblingen.de.ibm.com>
	 <1284377790.2275.212.camel@laptop>
Content-Type: multipart/mixed; boundary="=-uw8yNIShdlaInceUaAzx"
Date: Wed, 15 Sep 2010 13:29:50 +0800
Message-ID: <1284528590.2256.135.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uw8yNIShdlaInceUaAzx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2010-09-13 at 19:36 +0800, Peter Zijlstra wrote:
> On Mon, 2010-09-13 at 12:32 +0200, Martin Schwidefsky wrote:
> > On Mon, 13 Sep 2010 14:50:48 +0800
> > Huang Ying <ying.huang@intel.com> wrote:
> > 
> > > From:  Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > 
> > > In order for other NMI context users that want to run things from
> > > hard-IRQ context, extract the perf_event callback mechanism.
> > > 
> > > Huang Ying: some fixes
> > > 
> > > This patch is only tested on x86 platform.
> > > 
> > > 
> > > v4:
> > > 
> > > -rebased on latest -tip tree
> > > 
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> > On s390 I get compile errors:
> > 
> > include/linux/perf_event.h:464:29: error: asm/perf_event.h: No such file or directory
> > 
> > Not a good idea to completely remove the perf_event.h from arch/s390/include/asm.
> > With an empty header file the kernel at least compiles.
> 
> Urgh, Huang, could you at least compile test the other arches?

I uses the cross build tool from:

http://www.kernel.org/pub/tools/crosstool/

But I get compile errors on s390 and alpha even for tip/master
(ce0c65112d37ff04016b4e0962a406281640739b). The build logs are attached.

Do I use the wrong git tree? Or we should fix tip/master firstly?

And frv and sh have compile error even for linus/master and 2.6.35. So I
can not compile test for these arches.

Do I use the wrong cross tool?

The kernel configuration is generated as follow:

make defconfig
./scripts/config --enable perf_events

Best Regards,
Huang Ying


--=-uw8yNIShdlaInceUaAzx
Content-Disposition: attachment; filename="log_alpha"
Content-Type: text/plain; name="log_alpha"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

make -C /home/caritas/projects/mce/kernel/linux-mce.git O=/home/caritas/projects/mce/kernel/build-cross/obj-alpha/. 
  GEN     /home/caritas/projects/mce/kernel/build-cross/obj-alpha/Makefile
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/hash
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --silentoldconfig arch/alpha/Kconfig
  GEN     /home/caritas/projects/mce/kernel/build-cross/obj-alpha/Makefile
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  Using /home/caritas/projects/mce/kernel/linux-mce.git as source for kernel
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/conmakehash
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  CC      kernel/bounds.s
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  GEN     include/generated/bounds.h
  CC      arch/alpha/kernel/asm-offsets.s
  HOSTLD  scripts/mod/modpost
  GEN     include/generated/asm-offsets.h
  CALL    /home/caritas/projects/mce/kernel/linux-mce.git/scripts/checksyscalls.sh
<stdin>:1526:2: warning: #warning syscall fanotify_init not implemented
<stdin>:1530:2: warning: #warning syscall fanotify_mark not implemented
<stdin>:1534:2: warning: #warning syscall prlimit64 not implemented
  CHK     include/generated/compile.h
  CC      init/main.o
  CC      init/do_mounts.o
  CC      init/noinitramfs.o
  CC      init/calibrate.o
  LD      usr/built-in.o
  AS      arch/alpha/kernel/entry.o
  CC      arch/alpha/kernel/traps.o
  CC      arch/alpha/kernel/process.o
  CC      arch/alpha/kernel/init_task.o
  CC      arch/alpha/kernel/osf_sys.o
  CC      arch/alpha/kernel/irq.o
  CC      arch/alpha/kernel/irq_alpha.o
  CC      arch/alpha/kernel/signal.o
  CC      arch/alpha/mm/init.o
  CC      arch/alpha/kernel/setup.o
  CC      arch/alpha/mm/fault.o
  CC      arch/alpha/kernel/ptrace.o
  CC      arch/alpha/mm/extable.o
  CC      arch/alpha/kernel/time.o
  CC      arch/alpha/kernel/alpha_ksyms.o
  AS      arch/alpha/kernel/systbls.o
  CC      arch/alpha/kernel/err_common.o
  CC      arch/alpha/math-emu/math.o
  CC      arch/alpha/kernel/io.o
  CC      arch/alpha/kernel/console.o
  AS      arch/alpha/math-emu/qrnnd.o
  CC      arch/alpha/kernel/pci.o
  CC      kernel/sched.o
  CC      arch/alpha/kernel/pci_iommu.o
  CC      kernel/fork.o
  CC      mm/bootmem.o
  CC      arch/alpha/kernel/pci-sysfs.o
  CC      mm/filemap.o
  CC      kernel/exec_domain.o
  CC      mm/mempool.o
  CC      arch/alpha/kernel/module.o
  CC      kernel/panic.o
  CC      kernel/printk.o
  CC      mm/oom_kill.o
  CC      kernel/cpu.o
  CC      kernel/exit.o
  CC      arch/alpha/kernel/perf_event.o
  CC      mm/fadvise.o
  CC      arch/alpha/kernel/core_apecs.o
  CC      mm/maccess.o
  CC      kernel/itimer.o
  TIMEC   kernel/timeconst.h
  CC      mm/page_alloc.o
  CC      arch/alpha/kernel/core_cia.o
  CC      arch/alpha/kernel/core_irongate.o
  CC      kernel/softirq.o
  CC      mm/page-writeback.o
  CC      kernel/resource.o
  CC      mm/readahead.o
  CC      arch/alpha/kernel/core_lca.o
  CC      kernel/sysctl.o
  CC      mm/swap.o
  CC      kernel/sysctl_binary.o
  CC      arch/alpha/kernel/core_mcpcia.o
  CC      mm/truncate.o
  CC      kernel/capability.o
  CC      mm/vmscan.o
  CC      arch/alpha/kernel/core_polaris.o
  CC      ipc/util.o
  CC      kernel/ptrace.o
  CC      arch/alpha/kernel/core_t2.o
  CC      security/commoncap.o
  UPD     include/generated/compile.h
  CC      fs/open.o
  CC      init/version.o
  CC      mm/shmem.o
  CC      arch/alpha/kernel/core_tsunami.o
  CC      arch/alpha/kernel/sys_alcor.o
  CC      arch/alpha/kernel/sys_cabriolet.o
  CC      arch/alpha/kernel/sys_dp264.o
  CC      kernel/timer.o
  CC      mm/prio_tree.o
  CC      arch/alpha/kernel/sys_eb64p.o
  CC      arch/alpha/kernel/sys_eiger.o
/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/kernel/perf_event.c: In function 'alpha_pmu_add':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/kernel/perf_event.c:427: error: 'flags' redeclared as different kind of symbol
/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/kernel/perf_event.c:422: note: previous definition of 'flags' was here
/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/kernel/perf_event.c:457: error: 'hwc' undeclared (first use in this function)
/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/kernel/perf_event.c:457: error: (Each undeclared identifier is reported only once
/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/kernel/perf_event.c:457: error: for each function it appears in.)
/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/kernel/perf_event.c: In function 'alpha_pmu_del':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/kernel/perf_event.c:477: error: 'flags' redeclared as different kind of symbol
/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/kernel/perf_event.c:473: note: previous definition of 'flags' was here
  CC      arch/alpha/kernel/sys_jensen.o
make[3]: *** [arch/alpha/kernel/perf_event.o] Error 1
make[3]: *** Waiting for unfinished jobs....
  CC      kernel/user.o
  CC      mm/util.o
  CC      mm/mmzone.o
  CC      crypto/api.o
  CC      ipc/msgutil.o
  CC      kernel/signal.o
  CC      block/elevator.o
  CC      block/blk-core.o
  CC      fs/read_write.o
  CC      block/blk-tag.o
  CC      mm/vmstat.o
  CC      kernel/sys.o
  CC      mm/backing-dev.o
  CC      kernel/kmod.o
  CC      fs/file_table.o
  CC      mm/page_isolation.o
  CC      mm/mm_init.o
  CC      fs/super.o
  CC      kernel/workqueue.o
  LD      arch/alpha/mm/built-in.o
  CC      mm/mmu_context.o
  CC      security/min_addr.o
  CC      mm/fremap.o
  CC      mm/highmem.o
  CC      block/blk-sysfs.o
  CC      fs/char_dev.o
  LD      sound/built-in.o
  CC      kernel/pid.o
  CC      block/blk-barrier.o
  CC      kernel/rcupdate.o
  CC      crypto/cipher.o
  CC      block/blk-settings.o
  CC      block/blk-ioc.o
  LD      firmware/built-in.o
  CC      crypto/compress.o
  CC      mm/madvise.o
  CC      fs/stat.o
  CC      kernel/extable.o
  CC      ipc/msg.o
  CC      ipc/sem.o
  CC      ipc/shm.o
  CC      ipc/ipcns_notifier.o
  CC      mm/memory.o
  CC      ipc/syscall.o
  CC      mm/mincore.o
  CC      lib/bcd.o
  CC      ipc/ipc_sysctl.o
  LD      drivers/auxdisplay/built-in.o
  LD      arch/alpha/math-emu/math-emu.o
  CC      net/socket.o
  CC      kernel/params.o
  LD      arch/alpha/math-emu/built-in.o
  CC      mm/mlock.o
  CC      fs/exec.o
  CC      lib/div64.o
  CC      kernel/posix-timers.o
  CC      mm/mmap.o
  CC      mm/mprotect.o
  CC      lib/sort.o
  CC      kernel/kthread.o
  CC      drivers/base/core.o
  CC      fs/pipe.o
  LD      security/built-in.o
  CC      kernel/wait.o
  CC      fs/namei.o
  LD      arch/alpha/lib/built-in.o
  CC      mm/mremap.o
  CC      drivers/base/sys.o
alpha-linux-gcc -Wp,-MD,arch/alpha/lib/.__divlu.o.d  -nostdinc -isystem /usr/local/gcc-4.4.0-nolibc/alpha-linux/bin/../lib/gcc/alpha-linux/4.4.0/include -I/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/include -Iinclude  -I/home/caritas/projects/mce/kernel/linux-mce.git/include -include include/generated/autoconf.h -D__KERNEL__ -D__ASSEMBLY__ -gdwarf-2 -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -pipe -mno-fp-regs -ffixed-8 -msmall-data -fno-jump-tables -mcpu=ev5 -Wa,-mev6 -Wframe-larger-than=2048 -fno-stack-protector -fomit-frame-pointer -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DDIV -DINTSIZE   -c -o arch/alpha/lib/__divlu.o /home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/lib/divide.S
alpha-linux-gcc -Wp,-MD,arch/alpha/lib/.__divqu.o.d  -nostdinc -isystem /usr/local/gcc-4.4.0-nolibc/alpha-linux/bin/../lib/gcc/alpha-linux/4.4.0/include -I/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/include -Iinclude  -I/home/caritas/projects/mce/kernel/linux-mce.git/include -include include/generated/autoconf.h -D__KERNEL__ -D__ASSEMBLY__ -gdwarf-2 -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -pipe -mno-fp-regs -ffixed-8 -msmall-data -fno-jump-tables -mcpu=ev5 -Wa,-mev6 -Wframe-larger-than=2048 -fno-stack-protector -fomit-frame-pointer -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DDIV   -c -o arch/alpha/lib/__divqu.o /home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/lib/divide.S
  CC      kernel/kfifo.o
  CC      mm/msync.o
  LD      net/802/built-in.o
alpha-linux-gcc -Wp,-MD,arch/alpha/lib/.__remlu.o.d  -nostdinc -isystem /usr/local/gcc-4.4.0-nolibc/alpha-linux/bin/../lib/gcc/alpha-linux/4.4.0/include -I/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/include -Iinclude  -I/home/caritas/projects/mce/kernel/linux-mce.git/include -include include/generated/autoconf.h -D__KERNEL__ -D__ASSEMBLY__ -gdwarf-2 -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -pipe -mno-fp-regs -ffixed-8 -msmall-data -fno-jump-tables -mcpu=ev5 -Wa,-mev6 -Wframe-larger-than=2048 -fno-stack-protector -fomit-frame-pointer -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DREM -DINTSIZE   -c -o arch/alpha/lib/__remlu.o /home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/lib/divide.S
  CC      mm/rmap.o
alpha-linux-gcc -Wp,-MD,arch/alpha/lib/.__remqu.o.d  -nostdinc -isystem /usr/local/gcc-4.4.0-nolibc/alpha-linux/bin/../lib/gcc/alpha-linux/4.4.0/include -I/home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/include -Iinclude  -I/home/caritas/projects/mce/kernel/linux-mce.git/include -include include/generated/autoconf.h -D__KERNEL__ -D__ASSEMBLY__ -gdwarf-2 -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -pipe -mno-fp-regs -ffixed-8 -msmall-data -fno-jump-tables -mcpu=ev5 -Wa,-mev6 -Wframe-larger-than=2048 -fno-stack-protector -fomit-frame-pointer -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DREM   -c -o arch/alpha/lib/__remqu.o /home/caritas/projects/mce/kernel/linux-mce.git/arch/alpha/lib/divide.S
  CC      kernel/sys_ni.o
  LD      init/mounts.o
make[2]: *** [arch/alpha/kernel] Error 2
make[2]: *** Waiting for unfinished jobs....
  CC      lib/parser.o
  LD      init/built-in.o
  AS      arch/alpha/lib/callback_srm.o
  CC      fs/fcntl.o
  CC      crypto/algapi.o
  CC      ipc/mqueue.o
  CC      drivers/base/bus.o
  CC      arch/alpha/lib/checksum.o
  CC      fs/ioctl.o
  CC      fs/readdir.o
  CC      block/blk-map.o
  CC      drivers/block/floppy.o
  CC      fs/select.o
  CC      block/blk-exec.o
  CC      kernel/posix-cpu-timers.o
  CC      kernel/mutex.o
  CC      block/blk-merge.o
  CC      kernel/hrtimer.o
  CC      lib/halfmd4.o
  CC      net/8021q/vlan_core.o
  CC      kernel/rwsem.o
  CC      crypto/scatterwalk.o
  CC      lib/debug_locks.o
  CC [M]  drivers/block/loop.o
  CC [M]  net/8021q/vlan.o
  CC      lib/random32.o
  CC      mm/vmalloc.o
  CC      kernel/nsproxy.o
  CC      drivers/base/dd.o
  CC      kernel/srcu.o
  CC      mm/pagewalk.o
  CC      lib/bust_spinlocks.o
  CC      kernel/semaphore.o
  CC      mm/init-mm.o
  CC      mm/bounce.o
  CC      lib/hexdump.o
  CC      fs/fifo.o
  CC      lib/kasprintf.o
  CC      kernel/notifier.o
  CC      kernel/ksysfs.o
  CC      ipc/mq_sysctl.o
  CC      kernel/pm_qos_params.o
  CC      lib/bitmap.o
  CC      drivers/base/driver.o
  AS      arch/alpha/lib/clear_page.o
  CC      mm/page_io.o
  CC      block/blk-softirq.o
  CC      kernel/sched_clock.o
  CC      mm/swap_state.o
  CC      block/blk-timeout.o
  CC      kernel/cred.o
  CC      fs/dcache.o
  CC      drivers/base/class.o
  AS      arch/alpha/lib/clear_user.o
  CC      kernel/async.o
  CC      kernel/range.o
  CC      fs/inode.o
  AS      arch/alpha/lib/copy_page.o
  CC      block/blk-iopoll.o
  CC      drivers/base/platform.o
  CC      lib/scatterlist.o
  CC      drivers/cdrom/cdrom.o
  CC      kernel/groups.o
  CC      mm/swapfile.o
  CC      mm/thrash.o
  CC      kernel/irq/handle.o
  AS      arch/alpha/lib/copy_user.o
  CC      kernel/time/timekeeping.o
  CC      kernel/futex.o
  CC      drivers/base/cpu.o
  CC      kernel/time/ntp.o
  CC [M]  net/8021q/vlan_dev.o
  CC      kernel/rtmutex.o
  CC      fs/attr.o
  CC      drivers/base/firmware.o
  CC      kernel/dma.o
  CC [M]  net/8021q/vlan_netlink.o
  AS      arch/alpha/lib/csum_ipv6_magic.o
  CC      mm/dmapool.o
  CC      block/blk-lib.o
  CC      crypto/proc.o
  CC      fs/bad_inode.o
  CC      kernel/up.o
/home/caritas/projects/mce/kernel/linux-mce.git/kernel/irq/handle.c:432:3: warning: #warning __do_IRQ is deprecated. Please convert to proper flow handlers
  CC      kernel/module.o
  CC      block/ioctl.o
  CC      fs/file.o
  CC      arch/alpha/lib/csum_partial_copy.o
  CC      crypto/ablkcipher.o
  CC      fs/filesystems.o
  CC      mm/slub.o
  CC [M]  net/8021q/vlanproc.o
  CC      crypto/blkcipher.o
  CC      lib/string_helpers.o
  CC      crypto/ahash.o
  LD      net/8021q/built-in.o
  CC      block/genhd.o
  CC      kernel/kallsyms.o
  CC      mm/percpu_up.o
  CC      lib/gcd.o
  CC      net/core/sock.o
  CC      net/ethernet/eth.o
  CC      kernel/rcutiny.o
  CC      net/core/request_sock.o
  CC      net/ipv4/route.o
  CC      kernel/utsname_sysctl.o
  CC      net/ipv4/inetpeer.o
  CC      block/scsi_ioctl.o
  CC      net/core/skbuff.o
  CC      net/ipv4/protocol.o
  CC      block/bsg.o
  LD      net/key/built-in.o
  CC      kernel/elfcore.o
  CC      kernel/irq/manage.o
  CC [M]  net/key/af_key.o
  CC      kernel/time/clocksource.o
  CC      lib/lcm.o
  CC      drivers/char/mem.o
  CC      block/noop-iosched.o
  CC      kernel/perf_event.o
  CC      fs/namespace.o
  CC      kernel/time.o
  CC      lib/list_sort.o
  CC      fs/seq_file.o
  CC      lib/uuid.o
  CC      kernel/irq/spurious.o
  LD      drivers/clocksource/built-in.o
  CC      block/deadline-iosched.o
  CC      block/cfq-iosched.o
  CC      fs/xattr.o
  LD      drivers/crypto/built-in.o
  CC      arch/alpha/lib/fls.o
  CC      fs/libfs.o
  CC      fs/fs-writeback.o
  GEN     drivers/eisa/devlist.h
  LD      drivers/firmware/built-in.o
  CC      drivers/eisa/pci_eisa.o
  CC      net/core/iovec.o
  CC      kernel/irq/resend.o
  CC      arch/alpha/lib/fpreg.o
  CC      lib/iomap_copy.o
  CC      drivers/eisa/virtual_root.o
  CC      drivers/base/init.o
  CC      kernel/irq/chip.o
  CC      net/ipv4/ip_input.o
  CC      kernel/irq/devres.o
  CC      net/ipv4/ip_fragment.o
  CC      net/netfilter/core.o
  CC      crypto/shash.o
  CC      drivers/base/map.o
  CC      fs/pnode.o
  CC      drivers/char/random.o
  CC      net/netfilter/nf_log.o
/home/caritas/projects/mce/kernel/linux-mce.git/kernel/perf_event.c:92: warning: 'perf_pmu_rotate_stop' defined but not used
  CC      drivers/base/devres.o
  CC      net/ipv4/ip_forward.o
  AS      arch/alpha/lib/memchr.o
  CC      fs/drop_caches.o
  CC      drivers/base/attribute_container.o
  CC      kernel/time/jiffies.o
  CC      kernel/time/timer_list.o
  CC      lib/devres.o
  CC      net/core/datagram.o
  CC      net/ipv4/ip_options.o
  CC      kernel/irq/autoprobe.o
  CC      arch/alpha/lib/memcpy.o
  CC      drivers/eisa/eisa-bus.o
  CC      drivers/char/tty_io.o
  CC      drivers/base/transport_class.o
  CC      lib/find_last_bit.o
  LD      drivers/gpio/built-in.o
  CC      kernel/irq/proc.o
  CC      fs/splice.o
  CC      drivers/char/n_tty.o
  CC      lib/hweight.o
  CC      net/ipv4/ip_output.o
  CC      kernel/time/timecompare.o
  LD      drivers/base/power/built-in.o
  AS      arch/alpha/lib/memmove.o
  LD      net/ethernet/built-in.o
  CC      crypto/algboss.o
  LD      ipc/built-in.o
  CC      net/netlink/af_netlink.o
  AS      arch/alpha/lib/memset.o
  CC      crypto/testmgr.o
  CC      drivers/base/dma-mapping.o
  LD      drivers/gpu/drm/i2c/built-in.o
  CC      net/core/stream.o
  CC      net/packet/af_packet.o
  CC      lib/bitrev.o
  CC      drivers/char/tty_ioctl.o
  CC      arch/alpha/lib/srm_printk.o
  CC      crypto/crypto_wq.o
  LD [M]  net/8021q/8021q.o
  CC      fs/sync.o
  CC      drivers/char/tty_ldisc.o
  HOSTCC  lib/gen_crc32table
  LD      drivers/gpu/drm/built-in.o
  CC      net/ipv4/ip_sockglue.o
  CC      net/netfilter/nf_queue.o
  CC      kernel/time/timeconv.o
  CC      drivers/base/isa.o
  CC      net/core/scm.o
  CC      drivers/base/firmware_class.o
  CC      arch/alpha/lib/srm_puts.o
  CC      net/netfilter/nf_sockopt.o
  CC      drivers/gpu/vga/vgaarb.o
  CC      net/sched/sch_generic.o
  CC      crypto/aead.o
  CC      drivers/base/module.o
  LD      kernel/irq/built-in.o
  CC      lib/iommu-helper.o
  CC      fs/utimes.o
  AS      arch/alpha/lib/strcat.o
  CC      net/ipv4/inet_hashtables.o
  CC      net/core/gen_stats.o
  CC      net/netlink/genetlink.o
  CC      crypto/chainiv.o
  CC      lib/nlattr.o
  AS      arch/alpha/lib/strchr.o
  CC      drivers/hwmon/hwmon.o
  CC      drivers/hid/hid-core.o
  CC      drivers/hid/hid-input.o
  AS      arch/alpha/lib/strcpy.o
  CC      crypto/eseqiv.o
  CC      net/core/gen_estimator.o
  CC      fs/stack.o
  LD      drivers/i2c/algos/built-in.o
  CC      crypto/pcompress.o
  CC      crypto/hmac.o
  AS      arch/alpha/lib/strlen.o
  CC      net/sched/sch_mq.o
  CC      fs/fs_struct.o
  LD      drivers/i2c/busses/built-in.o
  AS      arch/alpha/lib/strlen_user.o
  LD      drivers/i2c/muxes/built-in.o
  LD      kernel/time/built-in.o
  CC [M]  net/netfilter/x_tables.o
  CC [M]  net/netfilter/xt_tcpudp.o
  AS      arch/alpha/lib/strncat.o
  CC      net/core/net_namespace.o
  LD      drivers/i2c/built-in.o
  CC      net/ipv4/inet_timewait_sock.o
  AS      arch/alpha/lib/strncpy.o
  CC      net/ipv4/inet_connection_sock.o
  CC      crypto/rng.o
  LD      drivers/hwmon/built-in.o
  LD      drivers/eisa/built-in.o
  LD      drivers/idle/built-in.o
  LD      drivers/ieee1394/built-in.o
  LD      net/sunrpc/built-in.o
  CC      fs/statfs.o
  CC [M]  net/sunrpc/clnt.o
  AS      arch/alpha/lib/strncpy_from_user.o
  LD      drivers/ieee802154/built-in.o
  CC [M]  net/sunrpc/xprt.o
  CC      crypto/krng.o
  CC      fs/buffer.o
  CC      net/core/sysctl_net_core.o
  CC [M]  crypto/md5.o
  CC      net/core/dev.o
  AS      arch/alpha/lib/strrchr.o
  CC      net/core/ethtool.o
  CC      drivers/input/serio/serio.o
  LD      drivers/lguest/built-in.o
  AS      arch/alpha/lib/stxcpy.o
  CC      drivers/input/input.o
  LD      net/netfilter/netfilter.o
  CC      net/ipv4/tcp.o
  CC      lib/argv_split.o
  LD      drivers/cdrom/built-in.o
  LD      drivers/macintosh/built-in.o
  LD      net/netfilter/built-in.o
  AS      arch/alpha/lib/stxncpy.o
  CC [M]  net/sunrpc/socklib.o
  CC      arch/alpha/lib/udelay.o
  CC      drivers/ide/ide-cd.o
  CC      drivers/char/tty_buffer.o
  CC [M]  crypto/sha1_generic.o
  CC      net/ipv4/tcp_input.o
  CC      lib/cmdline.o
  CC      drivers/input/serio/i8042.o
  CC [M]  crypto/cbc.o
  LD      drivers/mfd/built-in.o
  LD      net/wireless/built-in.o
  CC      net/ipv4/tcp_output.o
  CC      net/core/dev_addr_lists.o
  LD      drivers/media/IR/keymaps/built-in.o
  CC      net/ipv4/tcp_timer.o
  CC      net/xfrm/xfrm_policy.o
  LD      drivers/gpu/vga/built-in.o
  LD      drivers/media/IR/built-in.o
  LD      drivers/gpu/built-in.o
  LD      drivers/misc/cb710/built-in.o
  LD      mm/built-in.o
  LD      drivers/misc/eeprom/built-in.o
  CC      net/sysctl_net.o
  CC      lib/ctype.o
  LD      drivers/misc/built-in.o
  CC [M]  crypto/des_generic.o
  LD      drivers/media/common/tuners/built-in.o
  CC      lib/dec_and_lock.o
  CC      drivers/net/mii.o
  CC      drivers/ide/ide-cd_ioctl.o
  AR      arch/alpha/lib/lib.a
  CC      drivers/ide/ide-cd_verbose.o
  CC [M]  crypto/aes_generic.o
  CC      lib/decompress.o
  LD      drivers/base/built-in.o
  CC      net/core/dst.o
  CC      net/xfrm/xfrm_state.o
  LD      drivers/media/common/built-in.o
  CC      net/core/netevent.o
  CC [M]  crypto/authenc.o
  CC      drivers/input/input-compat.o
  CC [M]  net/sunrpc/xprtsock.o
  CC      net/core/neighbour.o
  CC      drivers/pci/access.o
  CC      net/xfrm/xfrm_hash.o
  LD      drivers/media/video/davinci/built-in.o
  CC      lib/dump_stack.o
  CC      drivers/char/tty_port.o
  CC      drivers/ide/ide.o
  CC      net/ipv4/tcp_ipv4.o
  LD      drivers/media/video/built-in.o
  CC      lib/extable.o
  CC [M]  crypto/ansi_cprng.o
  CC      drivers/ide/ide-ioctls.o
  LD      net/sched/built-in.o
  LD      drivers/media/built-in.o
  CC      net/core/rtnetlink.o
  LD      drivers/platform/built-in.o
  CC      fs/bio.o
  CC      lib/find_next_bit.o
  CC      drivers/char/tty_mutex.o
  CC      drivers/input/ff-core.o
  CC      drivers/char/pty.o
  CC      fs/block_dev.o
  CC      drivers/ide/ide-io.o
  CC      drivers/net/3c59x.o
  CC      net/unix/af_unix.o
  LD      drivers/block/built-in.o
  CC      net/xfrm/xfrm_input.o
  CC      lib/flex_array.o
  CC      net/core/utils.o
  LD      net/packet/built-in.o
  CC      drivers/input/serio/serport.o
  CC      drivers/pnp/core.o
  CC      net/unix/garbage.o
  CC      drivers/pnp/card.o
  CC      net/ipv4/tcp_minisocks.o
  CC      net/ipv4/tcp_cong.o
  LD      net/netlink/built-in.o
  CC      drivers/ide/ide-iops.o
  CC      drivers/input/mousedev.o
  CC      net/core/link_watch.o
  CC      drivers/pnp/driver.o
  CC      net/core/filter.o
  CC      drivers/input/keyboard/atkbd.o
  CC      net/ipv4/datagram.o
  CC      net/ipv4/raw.o
  CC      drivers/pnp/resource.o
  CC      drivers/pci/bus.o
  LD      kernel/built-in.o
  CC      drivers/input/mouse/psmouse-base.o
  CC      net/ipv4/udp.o
  CC      drivers/ide/ide-lib.o
  CC      lib/idr.o
  CC      drivers/ide/ide-probe.o
  CC      drivers/ide/ide-taskfile.o
  CC      fs/direct-io.o
  CC      net/core/flow.o
  CC      drivers/ide/ide-pm.o
  CC      lib/int_sqrt.o
  CC [M]  net/sunrpc/sched.o
  CC      net/core/net-sysfs.o
  CC [M]  net/sunrpc/auth.o
  LD      block/built-in.o
  CC      drivers/input/serio/libps2.o
  CC      drivers/char/misc.o
  CC      drivers/char/vt_ioctl.o
  CC      drivers/pci/probe.o
  LD      crypto/crypto.o
  CC      drivers/pci/remove.o
  CC      drivers/net/yellowfin.o
  CC      drivers/pci/pci.o
  LD      drivers/hid/hid.o
  CC      drivers/input/mouse/synaptics.o
  LD      drivers/hid/built-in.o
  CC      drivers/scsi/scsi.o
  CC      net/xfrm/xfrm_output.o
  CC      drivers/serial/serial_core.o
  CC      drivers/pnp/manager.o
  CC      drivers/ide/ide-park.o
  CC      fs/mpage.o
  CC      drivers/char/vc_screen.o
  CC      drivers/net/Space.o
  CC      drivers/ide/ide-sysfs.o
  LD      crypto/crypto_algapi.o
  CC      lib/ioremap.o
  LD      crypto/crypto_blkcipher.o
  CC      drivers/scsi/hosts.o
  LD      crypto/crypto_hash.o
  LD      crypto/cryptomgr.o
  CC      drivers/ide/ide-devsets.o
  CC      drivers/scsi/scsi_ioctl.o
  LD      crypto/built-in.o
  CC      lib/irq_regs.o
  CC [M]  net/sunrpc/auth_null.o
  CC      fs/ioprio.o
  CC      drivers/ide/ide-io-std.o
  CC      fs/devpts/inode.o
  CC      drivers/usb/host/pci-quirks.o
  LD      fs/autofs/built-in.o
  CC      lib/is_single_threaded.o
  CC      drivers/video/fb_notify.o
  CC [M]  fs/autofs/dirhash.o
  CC      drivers/input/mouse/alps.o
  LD      drivers/input/serio/built-in.o
  LD      drivers/input/keyboard/built-in.o
  CC      drivers/ide/ide-eh.o
  CC [M]  fs/autofs/init.o
  LD      drivers/video/backlight/built-in.o
  CC      drivers/input/mouse/logips2pp.o
  CC      drivers/video/console/dummycon.o
  CC      lib/klist.o
  CC      drivers/net/loopback.o
  CC      drivers/pci/pci-driver.o
  CC      drivers/pnp/support.o
  LD      drivers/net/wireless/built-in.o
  CC      lib/kobject.o
  CC      drivers/ide/ide-pio-blacklist.o
  CC [M]  drivers/net/dummy.o
  CC      drivers/net/tulip/eeprom.o
  CC      drivers/pnp/interface.o
  CC      lib/kobject_uevent.o
  CC      net/unix/sysctl_net_unix.o
  CC      net/xfrm/xfrm_algo.o
  CC      drivers/pnp/quirks.o
  CC      drivers/ide/ide-xfer-mode.o
  CC      drivers/input/mouse/trackpoint.o
  CC      net/ipv4/udplite.o
  CC      drivers/char/selection.o
  LD      drivers/input/input-core.o
  CC      net/ipv4/arp.o
  CC      drivers/char/keyboard.o
  CC      drivers/net/tulip/interrupt.o
  CC [M]  net/sunrpc/auth_unix.o
  LD      fs/devpts/devpts.o
  CC      lib/kref.o
  CC      drivers/video/console/vgacon.o
  LD      fs/devpts/built-in.o
  CC      drivers/serial/8250.o
  CC      drivers/net/tulip/media.o
  CC      drivers/char/consolemap.o
  LD      drivers/video/display/built-in.o
  CC      drivers/serial/8250_pnp.o
  CC [M]  net/sunrpc/auth_generic.o
  LD      fs/exportfs/built-in.o
  CC [M]  fs/autofs/inode.o
  CC [M]  fs/exportfs/expfs.o
  CC      drivers/ide/ide-timings.o
  CC      net/ipv4/icmp.o
  CC [M]  net/sunrpc/svc.o
  CC      drivers/scsi/constants.o
  CC      fs/fat/cache.o
  CC      drivers/scsi/scsicam.o
  CC      fs/ext2/balloc.o
  LD      drivers/video/omap2/displays/built-in.o
  CC      fs/isofs/namei.o
  CC [M]  net/sunrpc/svcsock.o
  LD      drivers/video/omap2/dss/built-in.o
  CC      net/xfrm/xfrm_sysctl.o
  LD      drivers/usb/host/built-in.o
  CC [M]  net/xfrm/xfrm_user.o
  CC      lib/plist.o
  LD      drivers/usb/built-in.o
  CC      lib/prio_heap.o
  LD      drivers/video/omap2/omapfb/built-in.o
  CC      drivers/pci/search.o
  CC      drivers/pnp/isapnp/core.o
  CC [M]  net/sunrpc/svcauth.o
  CC      drivers/scsi/scsi_error.o
  CC [M]  fs/autofs/root.o
  CC      drivers/ide/ide-atapi.o
  LD      fs/lockd/built-in.o
  CC      fs/isofs/inode.o
  LD      drivers/video/omap2/built-in.o
  CC [M]  net/sunrpc/svcauth_unix.o
  CC      drivers/pci/pci-sysfs.o
  CC      drivers/pnp/system.o
  CC      fs/ext2/dir.o
  CC [M]  fs/lockd/clntlock.o
  CC      fs/ext2/file.o
  CC      drivers/pci/rom.o
  LD      drivers/input/mouse/psmouse.o
  CC [M]  net/sunrpc/addr.o
  CC      fs/ext2/ialloc.o
  CC      fs/ext2/inode.o
  LD      drivers/input/mouse/built-in.o
  CC [M]  fs/lockd/clntproc.o
  LD      drivers/input/built-in.o
  CC [M]  fs/autofs/symlink.o
  CC      drivers/scsi/scsi_lib.o
  CC [M]  fs/autofs/waitq.o
  LD [M]  fs/exportfs/exportfs.o
  CC      drivers/pci/setup-res.o
  CC [M]  net/sunrpc/rpcb_clnt.o
  CC      drivers/serial/8250_pci.o
  CC [M]  fs/lockd/host.o
/home/caritas/projects/mce/kernel/linux-mce.git/fs/autofs/root.c:30: warning: 'autofs_root_compat_ioctl' declared 'static' but never defined
  CC      net/ipv4/devinet.o
  CONMK   drivers/char/consolemap_deftbl.c
  CC [M]  net/sunrpc/timer.o
  CC      lib/prio_tree.o
  CC      fs/fat/dir.o
  CC      drivers/scsi/scsi_lib_dma.o
  CC      drivers/serial/8250_early.o
  LD      net/unix/unix.o
  LD      net/unix/built-in.o
  CC      fs/fat/fatent.o
  CC [M]  net/sunrpc/xdr.o
  CC      drivers/net/tulip/timer.o
  CC      drivers/ide/setup-pci.o
  CC      drivers/char/vt.o
  CC      drivers/pci/irq.o
  CC      drivers/scsi/scsi_scan.o
  CC      drivers/pnp/isapnp/compat.o
  CC      drivers/net/tulip/tulip_core.o
  CC      drivers/net/tulip/21142.o
  CC      lib/proportions.o
  CC      drivers/scsi/scsi_sysfs.o
  CC      fs/isofs/dir.o
  CC [M]  fs/lockd/svc.o
  CC      drivers/net/tulip/pnic.o
  CC [M]  net/sunrpc/sunrpc_syms.o
  CC [M]  net/sunrpc/cache.o
  CC      fs/isofs/util.o
  CC      net/ipv4/af_inet.o
  CC      drivers/pnp/isapnp/proc.o
  CC      lib/radix-tree.o
  LD      net/xfrm/built-in.o
  CC [M]  fs/lockd/svclock.o
  CC      drivers/ide/ide-dma.o
  CC      drivers/pci/vpd.o
  CC      fs/fat/file.o
  CC      drivers/ide/ide-dma-sff.o
  CC [M]  net/sunrpc/rpc_pipe.o
  CC      drivers/ide/ide-proc.o
  CC      fs/isofs/rock.o
  CC      net/ipv4/igmp.o
  LD      net/core/built-in.o
  CC [M]  net/sunrpc/svc_xprt.o
  CC [M]  net/sunrpc/stats.o
  SHIPPED drivers/char/defkeymap.c
  CC      fs/ext2/ioctl.o
  CC      drivers/pci/proc.o
  LD      drivers/video/console/built-in.o
  CC [M]  net/sunrpc/sysctl.o
  LD      drivers/video/built-in.o
  CC      drivers/char/sysrq.o
  LD [M]  fs/autofs/autofs.o
  CC      drivers/ide/ide-gd.o
  CC      fs/ext2/namei.o
  CC      drivers/char/rtc.o
  CC      drivers/scsi/scsi_devinfo.o
  CC      fs/ext2/super.o
  LD      drivers/char/hw_random/built-in.o
  CC [M]  fs/lockd/svcshare.o
  CC      drivers/pci/slot.o
  CC      drivers/net/tulip/pnic2.o
  CC [M]  drivers/char/hw_random/core.o
  CC      fs/isofs/export.o
  CC      fs/ext2/symlink.o
  CC [M]  fs/lockd/svcproc.o
  CC      drivers/ide/ide-disk.o
  CC [M]  fs/lockd/svcsubs.o
  CC [M]  drivers/net/tulip/de2104x.o
  CC      lib/ratelimit.o
  CC      lib/rbtree.o
  CC [M]  fs/lockd/mon.o
  LD      drivers/pnp/isapnp/built-in.o
  CC      net/ipv4/fib_frontend.o
  CC      drivers/ide/ide-disk_ioctl.o
  LD      net/sunrpc/auth_gss/built-in.o
  CC      drivers/pci/quirks.o
  CC [M]  fs/lockd/xdr.o
  LD      drivers/pnp/built-in.o
  CC [M]  net/sunrpc/auth_gss/auth_gss.o
  CC [M]  fs/lockd/grace.o
  CC      net/ipv4/fib_semantics.o
  CC      drivers/scsi/scsi_sysctl.o
  LD      fs/nfs_common/built-in.o
  CC      fs/fat/inode.o
  CC [M]  net/sunrpc/auth_gss/gss_generic_token.o
  CC      drivers/pci/hotplug.o
  CC      drivers/ide/ide-disk_proc.o
  CC [M]  fs/lockd/xdr4.o
  CC      net/ipv4/inet_fragment.o
  LD      fs/nfs/built-in.o
  LD      drivers/serial/built-in.o
  CC      fs/fat/misc.o
  CC      drivers/pci/setup-bus.o
  CC [M]  fs/nfs/client.o
  CC [M]  fs/lockd/svc4proc.o
  CC      fs/fat/namei_msdos.o
  LD [M]  drivers/char/hw_random/rng-core.o
  CC [M]  net/sunrpc/auth_gss/gss_mech_switch.o
  CC      lib/reciprocal_div.o
  CC [M]  net/sunrpc/auth_gss/svcauth_gss.o
  CC      net/ipv4/sysctl_net_ipv4.o
  CC      drivers/ide/alim15x3.o
  CC      lib/rwsem.o
  CC      drivers/scsi/scsi_proc.o
  CC      drivers/char/consolemap_deftbl.o
  CC      net/ipv4/fib_hash.o
  CC      lib/sha1.o
  CC      drivers/char/defkeymap.o
  CC      net/ipv4/proc.o
  CC      drivers/scsi/scsi_trace.o
  CC      net/ipv4/xfrm4_mode_beet.o
  CC      fs/fat/namei_vfat.o
  CC      drivers/pci/setup-irq.o
  CC      drivers/ide/cmd64x.o
  CC      drivers/pci/syscall.o
  CC      drivers/scsi/sd.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_mech.o
  CC      lib/show_mem.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_seal.o
  CC      lib/string.o
  LD      fs/nfsd/built-in.o
  CC [M]  fs/nfs/dir.o
  CC      drivers/ide/cy82c693.o
  CC [M]  fs/nfsd/nfssvc.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_unseal.o
  CC [M]  fs/nfs/file.o
  CC [M]  fs/nfsd/nfsctl.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_seqnum.o
  CC      lib/vsprintf.o
  CC      drivers/ide/ide-pci-generic.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_wrap.o
  LD      fs/isofs/isofs.o
  CC      drivers/scsi/sr.o
  GEN     lib/crc32table.h
  LD      fs/isofs/built-in.o
  CC      drivers/scsi/sr_ioctl.o
  CC [M]  fs/nfsd/nfsproc.o
  CC      drivers/scsi/sr_vendor.o
  CC [M]  fs/nfs/getroot.o
  CC [M]  fs/nfsd/nfsfh.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_crypto.o
  LD      drivers/net/tulip/tulip.o
  CC      lib/crc32.o
  CC      drivers/ide/ide-scan-pci.o
  CC      drivers/ide/ide-generic.o
  CC [M]  net/sunrpc/auth_gss/gss_krb5_keys.o
  LD      drivers/net/tulip/built-in.o
  CC      net/ipv4/inet_lro.o
  CC [M]  fs/nfs/inode.o
  CC [M]  drivers/scsi/scsi_transport_spi.o
  CC      net/ipv4/xfrm4_mode_transport.o
  CC      fs/nls/nls_base.o
  CC [M]  drivers/scsi/scsi_wait_scan.o
  CC      fs/notify/fsnotify.o
  LD      drivers/pci/built-in.o
  CC      fs/partitions/check.o
  CC      fs/notify/notification.o
  CC      fs/notify/group.o
  CC      net/ipv4/xfrm4_mode_tunnel.o
  CC      fs/partitions/msdos.o
  CC      fs/notify/inode_mark.o
  CC      fs/nls/nls_cp437.o
  CC      net/ipv4/netfilter.o
  CC [M]  fs/nfs/super.o
  CC      fs/notify/mark.o
  LD      fs/quota/built-in.o
  LD      net/ipv4/netfilter/built-in.o
  CC      fs/ramfs/inode.o
  CC      net/ipv4/inet_diag.o
  LD      lib/built-in.o
  CC      fs/partitions/osf.o
  CC [M]  net/ipv4/netfilter/ip_tables.o
  CC [M]  fs/nfsd/vfs.o
  CC [M]  fs/nfs/nfs2xdr.o
  CC      fs/ramfs/file-mmu.o
  CC [M]  fs/nfs/direct.o
  CC      fs/notify/vfsmount_mark.o
  LD [M]  fs/lockd/lockd.o
  CC      net/ipv4/tcp_diag.o
  LD      fs/ext2/ext2.o
  CC      fs/proc/mmu.o
  CC      fs/proc/task_mmu.o
  CC      net/ipv4/tcp_cubic.o
  LD      fs/ext2/built-in.o
  CC      fs/sysfs/inode.o
  CC      fs/eventpoll.o
  CC      net/ipv4/xfrm4_policy.o
  LD [M]  net/sunrpc/sunrpc.o
  CC      net/ipv4/xfrm4_state.o
  CC      fs/notify/dnotify/dnotify.o
  LD      drivers/scsi/aic7xxx/built-in.o
  CC      fs/anon_inodes.o
  SHIPPED drivers/scsi/aic7xxx/aic7xxx_seq.h
  LD      fs/reiserfs/built-in.o
  CC      fs/sysfs/file.o
  CC [M]  fs/reiserfs/bitmap.o
  LD      drivers/net/built-in.o
  SHIPPED drivers/scsi/aic7xxx/aic7xxx_reg.h
  CC [M]  fs/nfs/pagelist.o
  SHIPPED drivers/scsi/aic7xxx/aic7xxx_reg_print.c
  CC      fs/signalfd.o
  LD      fs/notify/fanotify/built-in.o
  CC [M]  net/ipv4/netfilter/iptable_filter.o
  CC [M]  fs/nfs/proc.o
  CC      fs/notify/inotify/inotify_fsnotify.o
  CC      net/ipv4/xfrm4_input.o
  CC [M]  drivers/scsi/aic7xxx/aic7xxx_osm.o
  LD      fs/nls/built-in.o
  CC [M]  net/ipv4/netfilter/ip_queue.o
  CC      fs/timerfd.o
  CC [M]  fs/reiserfs/do_balan.o
  CC [M]  fs/nfs/read.o
  CC      fs/eventfd.o
  CC      net/ipv4/xfrm4_output.o
  CC      fs/aio.o
  CC [M]  fs/nfsd/export.o
  CC [M]  net/ipv4/ah4.o
  CC [M]  drivers/scsi/aic7xxx/aic7xxx_proc.o
  CC [M]  fs/nfsd/auth.o
  CC [M]  drivers/scsi/aic7xxx/aic7770_osm.o
  LD      fs/ramfs/ramfs.o
  LD      drivers/ide/ide-core.o
  CC      fs/locks.o
  LD      fs/ramfs/built-in.o
  CC      fs/nfsctl.o
  CC      fs/proc/inode.o
  CC [M]  fs/reiserfs/namei.o
  LD      drivers/ide/ide-gd_mod.o
  CC [M]  fs/reiserfs/inode.o
  LD      drivers/ide/ide-cd_mod.o
  CC [M]  drivers/scsi/aic7xxx/aic7xxx_osm_pci.o
  CC      fs/binfmt_script.o
  CC      fs/proc/root.o
  LD      drivers/ide/built-in.o
  CC [M]  fs/reiserfs/file.o
  CC      fs/proc/base.o
  CC      fs/binfmt_elf.o
  CC      fs/notify/inotify/inotify_user.o
  CC [M]  fs/nfsd/lockd.o
  CC [M]  net/ipv4/esp4.o
  CC [M]  fs/nfsd/nfscache.o
  CC      fs/proc/generic.o
  CC [M]  drivers/scsi/aic7xxx/aic7xxx_core.o
  CC [M]  fs/nfsd/nfsxdr.o
  LD      fs/fat/fat.o
  CC      fs/sysfs/dir.o
  CC      fs/proc/array.o
  CC [M]  fs/nfs/symlink.o
  LD      drivers/char/built-in.o
  LD      fs/fat/vfat.o
  LD      fs/fat/msdos.o
  CC      fs/proc/proc_tty.o
  LD      fs/fat/built-in.o
  CC      fs/proc/cmdline.o
  CC [M]  fs/nfsd/stats.o
  LD      fs/notify/dnotify/built-in.o
  LD      fs/partitions/built-in.o
  CC [M]  drivers/scsi/aic7xxx/aic7xxx_93cx6.o
  CC [M]  fs/reiserfs/dir.o
  CC [M]  fs/nfs/unlink.o
  CC      fs/sysfs/symlink.o
  CC [M]  drivers/scsi/aic7xxx/aic7770.o
  CC      fs/sysfs/mount.o
  LD [M]  net/sunrpc/auth_gss/auth_rpcgss.o
  CC [M]  drivers/scsi/aic7xxx/aic7xxx_pci.o
  CC [M]  fs/nfsd/nfs3proc.o
  LD [M]  net/sunrpc/auth_gss/rpcsec_gss_krb5.o
  CC [M]  fs/nfs/write.o
  CC [M]  drivers/scsi/aic7xxx/aic7xxx_reg_print.o
  CC [M]  fs/nfs/namespace.o
  CC [M]  fs/nfsd/nfs3xdr.o
  CC      fs/proc/cpuinfo.o
  CC      fs/sysfs/bin.o
  CC      fs/sysfs/group.o
  CC [M]  fs/reiserfs/fix_node.o
  CC [M]  fs/nfs/mount_clnt.o
  CC [M]  fs/nfs/dns_resolve.o
  CC      fs/proc/devices.o
  CC [M]  fs/nfs/cache_lib.o
  CC [M]  fs/nfs/nfs3proc.o
  CC      fs/proc/interrupts.o
  CC [M]  fs/nfs/nfs3xdr.o
  LD      drivers/scsi/scsi_mod.o
  CC      fs/proc/loadavg.o
  CC [M]  fs/reiserfs/super.o
  CC      fs/proc/meminfo.o
  LD      drivers/scsi/sd_mod.o
  LD      drivers/scsi/sr_mod.o
  CC [M]  fs/nfs/sysctl.o
  CC      fs/proc/stat.o
  LD      drivers/scsi/built-in.o
  CC      fs/proc/uptime.o
  CC [M]  fs/reiserfs/prints.o
  CC      fs/proc/version.o
  CC [M]  fs/reiserfs/objectid.o
  CC      fs/proc/softirqs.o
  CC [M]  fs/reiserfs/lbalance.o
  LD      net/ipv4/built-in.o
  CC [M]  fs/reiserfs/ibalance.o
  CC      fs/proc/proc_sysctl.o
  CC [M]  fs/reiserfs/stree.o
  CC      fs/proc/proc_net.o
  CC [M]  fs/reiserfs/hashes.o
  CC      fs/proc/kcore.o
  CC [M]  fs/reiserfs/tail_conversion.o
  CC [M]  fs/reiserfs/journal.o
  CC      fs/proc/kmsg.o
  CC      fs/proc/page.o
  CC [M]  fs/reiserfs/resize.o
  CC [M]  fs/reiserfs/item_ops.o
  CC [M]  fs/reiserfs/ioctl.o
  CC [M]  fs/reiserfs/xattr.o
  CC [M]  fs/reiserfs/lock.o
  LD      net/built-in.o
  LD      fs/notify/inotify/built-in.o
  LD      fs/notify/built-in.o
  LD      fs/sysfs/built-in.o
  AR      lib/lib.a
  LD      fs/proc/proc.o
  LD      fs/proc/built-in.o
  LD [M]  fs/nfsd/nfsd.o
  LD [M]  fs/nfs/nfs.o
  LD [M]  fs/reiserfs/reiserfs.o
  LD      fs/built-in.o
  LD [M]  drivers/scsi/aic7xxx/aic7xxx.o
  LD      drivers/built-in.o
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

--=-uw8yNIShdlaInceUaAzx
Content-Disposition: attachment; filename="log_s390"
Content-Type: text/plain; name="log_s390"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

make -C /home/caritas/projects/mce/kernel/linux-mce.git O=/home/caritas/projects/mce/kernel/build-cross/obj-s390/. 
  HOSTCC  scripts/basic/fixdep
  GEN     /home/caritas/projects/mce/kernel/build-cross/obj-s390/Makefile
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/basic/hash
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --silentoldconfig arch/s390/Kconfig
  GEN     /home/caritas/projects/mce/kernel/build-cross/obj-s390/Makefile
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  Using /home/caritas/projects/mce/kernel/linux-mce.git as source for kernel
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/bin2c
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  CC      kernel/bounds.s
  HOSTCC  scripts/genksyms/genksyms.o
  SHIPPED scripts/genksyms/lex.c
  SHIPPED scripts/genksyms/parse.h
  SHIPPED scripts/genksyms/keywords.c
  SHIPPED scripts/genksyms/parse.c
  HOSTCC  scripts/genksyms/lex.o
  HOSTCC  scripts/genksyms/parse.o
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  GEN     include/generated/bounds.h
  CC      arch/s390/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    /home/caritas/projects/mce/kernel/linux-mce.git/scripts/checksyscalls.sh
  HOSTLD  scripts/genksyms/genksyms
  HOSTLD  scripts/mod/modpost
  HOSTCC  usr/gen_init_cpio
  CHK     include/generated/compile.h
  CC      init/main.o
  CC      init/do_mounts.o
  CC      init/do_mounts_rd.o
  CC      arch/s390/mm/init.o
  CC      init/do_mounts_initrd.o
  CC      init/do_mounts_md.o
  CC      arch/s390/mm/fault.o
  CC      init/initramfs.o
  CC      arch/s390/mm/extmem.o
  CC      arch/s390/mm/mmap.o
  LD      arch/s390/crypto/built-in.o
  CC      arch/s390/mm/vmem.o
  CC [M]  arch/s390/crypto/sha512_s390.o
  CC      arch/s390/mm/pgtable.o
  CC [M]  arch/s390/crypto/sha_common.o
  CC [M]  arch/s390/crypto/prng.o
  CC      arch/s390/mm/maccess.o
  CC      arch/s390/mm/page-states.o
  CC      arch/s390/kernel/bitmap.o
  CC      arch/s390/kernel/traps.o
  LD      arch/s390/appldata/built-in.o
  CC      arch/s390/kernel/time.o
  CC      arch/s390/kernel/process.o
  AS      arch/s390/kernel/base.o
  CC      arch/s390/hypfs/inode.o
  CC      arch/s390/kernel/early.o
  CC      arch/s390/hypfs/hypfs_diag.o
  CC      arch/s390/kernel/setup.o
  CC      arch/s390/hypfs/hypfs_vm.o
  CC      arch/s390/kernel/processor.o
  CC      arch/s390/kernel/sys_s390.o
  UPD     include/generated/compile.h
  CC      arch/s390/kernel/ptrace.o
  CC      arch/s390/kernel/signal.o
  CC      init/version.o
  CC      arch/s390/kernel/cpcmd.o
  LD      arch/s390/kvm/built-in.o
  CC      arch/s390/kernel/ebcdic.o
  CC [M]  arch/s390/kvm/../../../virt/kvm/kvm_main.o
  CC      arch/s390/kernel/s390_ext.o
  CC [M]  arch/s390/kvm/kvm-s390.o
  CC      mm/bootmem.o
  CC      arch/s390/kernel/debug.o
  AS [M]  arch/s390/kvm/sie64a.o
  CC      mm/filemap.o
  CC      kernel/sched.o
  CC      arch/s390/kernel/irq.o
  CC      mm/mempool.o
  CC      arch/s390/kernel/ipl.o
  CC      kernel/fork.o
  CC [M]  arch/s390/kvm/intercept.o
  CC      kernel/exec_domain.o
  CC      mm/oom_kill.o
  CC      arch/s390/kernel/dis.o
  CC [M]  arch/s390/kvm/interrupt.o
  CC      kernel/panic.o
  CC      mm/fadvise.o
  CC      arch/s390/kernel/diag.o
  CC      kernel/printk.o
  CC [M]  arch/s390/kvm/priv.o
  CC      mm/maccess.o
  CC      arch/s390/kernel/mem_detect.o
  CC      mm/page_alloc.o
  CC      kernel/cpu.o
  CC [M]  arch/s390/kvm/sigp.o
  CC      arch/s390/kernel/vdso.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/init/initramfs.c:9:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      ipc/compat.o
  CC      mm/page-writeback.o
  GEN     usr/initramfs_data.cpio
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/mm/pgtable.c:14:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/init/do_mounts.h:2,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/init/do_mounts_initrd.c:11:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/irq.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/irqnr.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/random.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/crypto/prng.c:12:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/init/main.c:16:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      mm/readahead.o
make[3]: *** [arch/s390/mm/pgtable.o] Error 1
make[3]: *** Waiting for unfinished jobs....
  CC      fs/open.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/init/do_mounts.c:20:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      fs/read_write.o
make[3]: *** [init/initramfs.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[3]: *** [arch/s390/crypto/prng.o] Error 1
make[3]: *** Waiting for unfinished jobs....
  CC      kernel/exit.o
  CC      ipc/util.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/init/do_mounts.h:2,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/init/do_mounts_rd.c:12:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [init/do_mounts_initrd.o] Error 1
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/kernel/sys_s390.c:25:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      ipc/msgutil.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/kvm_host.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/kvm/intercept.c:14:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      kernel/itimer.o
  AS      usr/initramfs_data.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/kvm_host.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/kvm/kvm-s390.c:22:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/kvm_host.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/kvm/sigp.c:16:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [arch/s390/kernel/sys_s390.o] Error 1
make[3]: *** Waiting for unfinished jobs....
  TIMEC   kernel/timeconst.h
  CC      kernel/softirq.o
make[3]: *** [init/main.o] Error 1
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/irq.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nmi.h:8,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/kernel/sched.c:31:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/mm/init.c:24:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/kernel/signal.c:28:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment

/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/kernel/exec_domain.c:18:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [init/do_mounts_rd.o] Error 1
  LD      usr/built-in.o
make[3]: *** [arch/s390/mm/init.o] Error 1
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/mempolicy.h:70,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/kernel/fork.c:21:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/init/do_mounts.h:2,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/init/do_mounts_md.c:5:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/fadvise.c:14:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/hypfs/inode.c:18:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      ipc/msg.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/irq.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nmi.h:8,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/kernel/printk.c:26:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      ipc/sem.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/kvm_host.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/kvm/../../../virt/kvm/kvm_main.c:21:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      mm/swap.o
  CC      fs/file_table.o
make[3]: *** [kernel/exec_domain.o] Error 1
make[3]: *** Waiting for unfinished jobs....
  CC      fs/super.o
  CC      ipc/shm.o
  CC [M]  arch/s390/kvm/diag.o
  CC      mm/truncate.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/mempool.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/mempolicy.h:70,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/oom_kill.c:32:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/mm/fault.c:29:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/ipc/compat.c:29:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [mm/fadvise.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[3]: *** [arch/s390/kernel/signal.o] Error 1
  CC      security/commoncap.o
make[3]: *** [arch/s390/kvm/intercept.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[3]: *** [arch/s390/kvm/sigp.o] Error 1
make[3]: *** [arch/s390/kvm/kvm-s390.o] Error 1
  CC      ipc/ipcns_notifier.o
  CC      fs/char_dev.o
  CC      security/min_addr.o
make[3]: *** [init/do_mounts_md.o] Error 1
make[3]: *** [arch/s390/mm/fault.o] Error 1
make[3]: *** [mm/oom_kill.o] Error 1
  CC      fs/stat.o
  CC      security/lsm_audit.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/kernel/ptrace.c:39:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [mm/mempool.o] Error 1
  CC      ipc/syscall.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/page-writeback.c:21:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [arch/s390/hypfs/inode.o] Error 1
  CC      fs/exec.o
make[2]: *** [arch/s390/hypfs] Error 2
make[2]: *** Waiting for unfinished jobs....
  CC      ipc/ipc_sysctl.o
make[3]: *** [init/do_mounts.o] Error 1
  CC      ipc/mqueue.o
make[3]: *** [ipc/compat.o] Error 1
make[3]: *** Waiting for unfinished jobs....
  CC      fs/pipe.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/read_write.c:16:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      fs/namei.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/readahead.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      fs/fcntl.o
make[3]: *** [kernel/printk.o] Error 1
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/kvm_host.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/kvm/gaccess.h:17,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/kvm/priv.c:21:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      fs/ioctl.o
  CC      fs/readdir.o
  CC      fs/select.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/kvm_host.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/kvm/diag.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/ipc/msg.c:34:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/ipc/sem.c:82:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/super.c:26:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [mm/readahead.o] Error 1
  CC      crypto/api.o
make[3]: *** [mm/page-writeback.o] Error 1
  CC      fs/fifo.o
make[3]: *** [fs/read_write.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[3]: *** [arch/s390/kvm/priv.o] Error 1
make[3]: *** [arch/s390/kvm/diag.o] Error 1
make[3]: *** [kernel/fork.o] Error 1
make[3]: *** [ipc/msg.o] Error 1
  CC      crypto/cipher.o
make[3]: *** [arch/s390/kernel/ptrace.o] Error 1
make[2]: *** [init] Error 2
make[3]: *** [ipc/sem.o] Error 1
  CC      crypto/compress.o
  CC      crypto/algapi.o
  CC      crypto/scatterwalk.o
  CC      crypto/proc.o
  CC      crypto/ablkcipher.o
  CC      crypto/blkcipher.o
  CC      crypto/ahash.o
  CC      crypto/shash.o
  CC      crypto/algboss.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/stat.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      crypto/testmgr.o
  CC      crypto/crypto_wq.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/open.c:25:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [kernel/sched.o] Error 1
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/irq.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/irqnr.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/random.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/net.h:58,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/skbuff.h:26,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/if_ether.h:125,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/netdevice.h:29,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/net/sock.h:50,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/security/lsm_audit.c:20:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [fs/super.o] Error 1
make[3]: *** [fs/stat.o] Error 1
  CC      crypto/fips.o
  CC      crypto/aead.o
  CC      crypto/chainiv.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/security/commoncap.c:19:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
/home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_dev_ioctl_create_vm':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/kvm/../../../virt/kvm/kvm_main.c:1781: warning: unused variable 'r'
make[2]: *** [arch/s390/crypto] Error 2
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/mempolicy.h:70,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/shmem_fs.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/ipc/shm.c:31:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/exec.c:34:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [arch/s390/kvm/../../../virt/kvm/kvm_main.o] Error 1
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/truncate.c:16:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      crypto/eseqiv.o
  CC      crypto/pcompress.o
  CC      crypto/md5.o
make[3]: *** [mm/truncate.o] Error 1
  CC      crypto/cbc.o
make[3]: *** [fs/open.o] Error 1
  CC      crypto/des_generic.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/readdir.c:18:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [security/commoncap.o] Error 1
make[3]: *** Waiting for unfinished jobs....
  CC      crypto/rng.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/select.c:19:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC      crypto/krng.o
  CC [M]  crypto/seqiv.o
make[3]: *** [ipc/shm.o] Error 1
make[3]: *** [fs/exec.o] Error 1
  CC [M]  crypto/hmac.o
make[3]: *** [fs/readdir.o] Error 1
  CC [M]  crypto/vmac.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/fcntl.c:7:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC [M]  crypto/rmd128.o
  CC [M]  crypto/rmd160.o
  CC [M]  crypto/rmd256.o
make[3]: *** [security/lsm_audit.o] Error 1
make[2]: *** [security] Error 2
  CC [M]  crypto/rmd320.o
  CC [M]  crypto/sha1_generic.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/ipc/mqueue.c:18:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [fs/select.o] Error 1
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/namei.c:22:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC [M]  crypto/gf128mul.o
  CC [M]  crypto/ecb.o
  CC [M]  crypto/pcbc.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ftrace_event.h:7,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/trace/syscall.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/syscalls.h:76,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/ioctl.c:7:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC [M]  crypto/cts.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:15,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/pipe.c:19:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [fs/fcntl.o] Error 1
  CC [M]  crypto/ctr.o
  CC [M]  crypto/gcm.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/irq.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/irqnr.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/random.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/net.h:58,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/skbuff.h:26,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/netlink.h:152,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/rtnetlink.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/algapi.c:19:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/irq.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/irqnr.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/random.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/net.h:58,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/skbuff.h:26,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/netlink.h:152,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/rtnetlink.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/aead.c:20:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:21,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/shash.c:13:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC [M]  crypto/ccm.o
make[2]: *** [arch/s390/mm] Error 2
  CC [M]  crypto/fcrypt.o
  CC [M]  crypto/aes_generic.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/irq.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/irqnr.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/random.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/net.h:58,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/skbuff.h:26,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/netlink.h:152,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/rtnetlink.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/ablkcipher.c:22:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC [M]  crypto/camellia.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:21,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/scatterwalk.c:17:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC [M]  crypto/seed.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:21,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/ahash.c:17:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [fs/pipe.o] Error 1
  CC [M]  crypto/salsa20_generic.o
  CC [M]  crypto/zlib.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/irq.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/irqnr.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/random.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/rng.c:20:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC [M]  crypto/crc32c.o
make[3]: *** [fs/namei.o] Error 1
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/irq.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/irqnr.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/random.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/net.h:58,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/skbuff.h:26,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/netlink.h:152,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/rtnetlink.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/algboss.c:20:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
  CC [M]  crypto/authenc.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/irq.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/irqnr.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/random.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/krng.c:17:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':make[3]: *** [crypto/shash.o] Error 1
make[3]: *** Waiting for unfinished jobs....
  CC [M]  crypto/lzo.o
make[3]: *** [crypto/rng.o] Error 1

/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [crypto/scatterwalk.o] Error 1
make[3]: *** [crypto/aead.o] Error 1
make[3]: *** [crypto/ahash.o] Error 1
make[3]: *** [crypto/krng.o] Error 1
make[3]: *** [crypto/algapi.o] Error 1
make[3]: *** [crypto/ablkcipher.o] Error 1
make[3]: *** [crypto/algboss.o] Error 1
make[3]: *** [fs/ioctl.o] Error 1
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/irq.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/irqnr.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/random.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/ctr.c:19:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:21,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/cts.c:50:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [crypto/ctr.o] Error 1
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:21,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/hmac.c:20:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [crypto/cts.o] Error 1
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:21,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/eseqiv.c:20:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:21,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/blkcipher.c:18:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:21,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/vmac.c:32:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [crypto/hmac.o] Error 1
make[3]: *** [ipc/mqueue.o] Error 1
make[2]: *** [ipc] Error 2
make[3]: *** [crypto/eseqiv.o] Error 1
make[3]: *** [crypto/blkcipher.o] Error 1
make[3]: *** [crypto/vmac.o] Error 1
make[2]: *** [fs] Error 2
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:21,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/gcm.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:21,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/authenc.c:17:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/arch/s390/include/asm/hardirq.h:18,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/hardirq.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:21,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/ccm.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/caritas/projects/mce/kernel/linux-mce.git/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[3]: *** [crypto/gcm.o] Error 1
make[3]: *** [crypto/ccm.o] Error 1
make[3]: *** [crypto/authenc.o] Error 1
make[2]: *** [kernel] Error 2
make[2]: *** [arch/s390/kvm] Error 2
make[2]: *** [arch/s390/kernel] Error 2
make[2]: *** [crypto] Error 2
make[2]: *** [mm] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

--=-uw8yNIShdlaInceUaAzx--

