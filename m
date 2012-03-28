Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab2C1Qe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:34:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41582 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507Ab2C1QeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:34:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120328111957.GA6765@x1.osrc.amd.com>
References: <CANYHJ6jjuO7yV_kbPsnJ6X+KXrsz2PRPPXHN4Rkr-vgoSG-E4A@mail.gmail.com>
 <20120328111957.GA6765@x1.osrc.amd.com>
From: Trevor Turner <turn3r.tr3v0r@gmail.com>
Date: Wed, 28 Mar 2012 09:33:35 -0700
X-Google-Sender-Auth: 9Ys3sZo4LALZXLC8-2K27bm_I4c
Message-ID: <CANYHJ6j6cxz47TGk8kdU58eau17Fi1K=fH2icmd=v19VjNggKw@mail.gmail.com>
Subject: Re: K7/Athlon Optimization Causes Build Fail on Kernel 3.3 i686
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 04:19, Borislav Petkov <bp@alien8.de> wrote:
> Right, can you try this with the upstream kernel, i.e.
>
> 1. get one from kernel.org
> 2. copy the .config into the directory where you've unpacked the sources
> 3. do 'make oldconfig' and then 'make menuconfig' and go and select Athlon build
> 4. do 'make -j3 > w.log 2>&1' so that you can catch the build output into w.log
> which you can send later
>
> Also, which build tools are you using, simply do
>
> ./scripts/ver_linux
>
> in the kernel source directory, catch the output and send it on pls.

Here's the output of ver_linux:
Linux Dark-Server 3.3.0-1-ck #1 SMP Mon Mar 26 07:53:51 PDT 2012 i686
AMD Athlon(TM) MP 2000+ AuthenticAMD GNU/Linux

Gnu C                  4.6.3
Gnu make               3.82
binutils               2.22.0.20111227
util-linux             2.21
mount                  support
module-init-tools      7
e2fsprogs              1.42.1
jfsutils               1.1.15
reiserfsprogs          3.6.21
xfsprogs               3.1.7
pcmciautils            018
quota-tools            4.00-pre1.
PPP                    2.4.5
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Linux C++ Library      6.0.16
Procps                 3.2.8
Kbd                    1.15.3
Sh-utils               8.15
Modules Loaded         vgastate vfat usb_storage uas loop isofs
i2c_algo_bit fuse fb_ddc fat dm_mod cifs fscache btrfs crc32c
libcrc32c zlib_deflate w83781d hwmon_vid xt_multiport xt_recent
ipt_REJECT xt_conntrack iptable_filter ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack xt_tcpudp xt_dscp
xt_mark iptable_mangle ip_tables x_tables snd_cmipci gameport
snd_mpu401_uart snd_rawmidi snd_pcm snd_page_alloc snd_opl3_lib
snd_hwdep nouveau video mxm_wmi snd_timer snd_seq_device snd wmi
drm_kms_helper ttm drm e100 soundcore amd76x_edac i2c_amd756 serio_raw
i2c_core psmouse mii floppy edac_core shpchp processor evdev
pci_hotplug button amd_rng amd_k7_agp agpgart pcspkr usbhid hid sd_mod
pata_acpi uhci_hcd ohci_hcd ehci_hcd pata_amd usbcore ata_generic
usb_common libata scsi_mod xfs exportfs reiserfs ext4 crc16 jbd2
mbcache

and here's the build output:
scripts/kconfig/conf --silentoldconfig Kconfig
  SYSHDR  arch/x86/syscalls/../include/generated/asm/unistd_32.h
  SYSHDR  arch/x86/syscalls/../include/generated/asm/unistd_64.h
  SYSTBL  arch/x86/syscalls/../include/generated/asm/syscalls_32.h
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  HOSTCC  scripts/genksyms/genksyms.o
  SHIPPED scripts/genksyms/lex.lex.c
  SHIPPED scripts/genksyms/keywords.hash.c
  SHIPPED scripts/genksyms/parse.tab.h
  SHIPPED scripts/genksyms/parse.tab.c
  HOSTCC  scripts/genksyms/lex.lex.o
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/genksyms/parse.tab.o
  GEN     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  HOSTCC  scripts/kallsyms
  HOSTLD  scripts/genksyms/genksyms
  HOSTCC  scripts/conmakehash
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/bin2c
  HOSTCC  scripts/recordmcount
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/mod/modpost
  CHK     include/generated/compile.h
  CC      init/main.o
  HOSTCC  usr/gen_init_cpio
  UPD     include/generated/compile.h
  CC      init/do_mounts.o
  GEN     usr/initramfs_data.cpio
  AS      usr/initramfs_data.o
  LD      usr/built-in.o
  LD      arch/x86/crypto/built-in.o
  CC      arch/x86/kernel/process_32.o
  CC      init/do_mounts_initrd.o
  CC      init/initramfs.o
  CC      arch/x86/kernel/signal.o
  CC      init/calibrate.o
  CC      init/version.o
  CC      kernel/fork.o
  AS      arch/x86/kernel/entry_32.o
  CC      arch/x86/kernel/traps.o
  LD      init/mounts.o
  LD      init/built-in.o
  CC      mm/filemap.o
  CC      arch/x86/kernel/irq.o
  CC      kernel/exec_domain.o
  CC      arch/x86/kernel/irq_32.o
  CC      mm/mempool.o
  CC      kernel/panic.o
  CC      arch/x86/kernel/dumpstack_32.o
  CC      kernel/printk.o
  CC      mm/oom_kill.o
  CC      arch/x86/kernel/time.o
  CC      arch/x86/kernel/ioport.o
  CC      mm/fadvise.o
  CC      arch/x86/kernel/ldt.o
  CC      kernel/cpu.o
  CC      mm/maccess.o
  CC      arch/x86/kernel/dumpstack.o
  CC      kernel/exit.o
  CC      mm/page_alloc.o
  CC      arch/x86/kernel/nmi.o
  CC      arch/x86/kernel/setup.o
  CC      kernel/itimer.o
  CC      arch/x86/kernel/x86_init.o
  TIMEC   kernel/timeconst.h
  CC      kernel/softirq.o
  CC      mm/page-writeback.o
  CC      arch/x86/kernel/i8259.o
  CC      arch/x86/kernel/irqinit.o
  CC      kernel/resource.o
  CC      arch/x86/kernel/jump_label.o
  CC      arch/x86/kernel/irq_work.o
  CC      mm/readahead.o
  CC      arch/x86/kernel/probe_roms.o
  CC      kernel/sysctl.o
  CC      mm/swap.o
  CC      arch/x86/kernel/sys_i386_32.o
  CC      arch/x86/kernel/i386_ksyms_32.o
  CC      arch/x86/kernel/syscall_32.o
  CC      arch/x86/kernel/bootflag.o
  CC      mm/truncate.o
  CC      kernel/sysctl_binary.o
  CC      arch/x86/kernel/e820.o
  CC      kernel/capability.o
  CC      mm/vmscan.o
  CC      arch/x86/kernel/pci-dma.o
  CC      kernel/ptrace.o
  CC      arch/x86/kernel/quirks.o
  CC      kernel/timer.o
  CC      arch/x86/kernel/topology.o
  CC      arch/x86/kernel/kdebugfs.o
  CC      arch/x86/kernel/alternative.o
  CC      mm/shmem.o
  CC      arch/x86/kernel/i8253.o
  CC      kernel/user.o
  CC      arch/x86/kernel/pci-nommu.o
  CC      kernel/signal.o
  CC      arch/x86/kernel/hw_breakpoint.o
  CC      mm/prio_tree.o
  CC      arch/x86/kernel/tsc.o
  CC      mm/util.o
  CC      arch/x86/kernel/io_delay.o
  CC      mm/mmzone.o
  CC      kernel/sys.o
  CC      arch/x86/kernel/rtc.o
  CC      mm/vmstat.o
  CC      arch/x86/kernel/pci-iommu_table.o
  CC      arch/x86/kernel/resource.o
  CC      arch/x86/kernel/trampoline.o
  CC      mm/backing-dev.o
  CC      kernel/kmod.o
  AS      arch/x86/kernel/trampoline_32.o
  CC      arch/x86/kernel/process.o
  CC      kernel/workqueue.o
  CC      mm/page_isolation.o
  CC      arch/x86/kernel/i387.o
  CC      mm/mm_init.o
  CC      mm/mmu_context.o
  CC      arch/x86/kernel/xsave.o
  CC      mm/percpu.o
  CC      arch/x86/kernel/ptrace.o
  CC      kernel/pid.o
  CC      arch/x86/kernel/tls.o
  CC      mm/fremap.o
  CC      arch/x86/kernel/step.o
  CC      kernel/rcupdate.o
  CC      mm/highmem.o
  CC      arch/x86/kernel/i8237.o
  CC      kernel/extable.o
  CC      arch/x86/kernel/stacktrace.o
  CC      kernel/params.o
  CC      mm/madvise.o
  CC      arch/x86/kernel/acpi/boot.o
  CC      mm/memory.o
  CC      kernel/posix-timers.o
  CC      arch/x86/kernel/acpi/sleep.o
  CC      kernel/kthread.o
  LDS     arch/x86/kernel/acpi/realmode/wakeup.lds
  AS      arch/x86/kernel/acpi/realmode/wakeup.o
  CC      arch/x86/kernel/acpi/realmode/wakemain.o
  CC      arch/x86/kernel/acpi/realmode/video-mode.o
  AS      arch/x86/kernel/acpi/realmode/copy.o
  CC      kernel/wait.o
  AS      arch/x86/kernel/acpi/realmode/bioscall.o
  CC      arch/x86/kernel/acpi/realmode/regs.o
  CC      arch/x86/kernel/acpi/realmode/video-vga.o
  CC      arch/x86/kernel/acpi/realmode/video-vesa.o
  CC      mm/mincore.o
  CC      arch/x86/kernel/acpi/realmode/video-bios.o
  CC      kernel/kfifo.o
  LD      arch/x86/kernel/acpi/realmode/wakeup.elf
  OBJCOPY arch/x86/kernel/acpi/realmode/wakeup.bin
  AS      arch/x86/kernel/acpi/wakeup_32.o
  CC      arch/x86/kernel/acpi/cstate.o
  CC      mm/mlock.o
  CC      kernel/sys_ni.o
  AS      arch/x86/kernel/acpi/wakeup_rm.o
  CC      kernel/posix-cpu-timers.o
  LD      arch/x86/kernel/acpi/built-in.o
  CC      arch/x86/kernel/apic/apic.o
  CC      mm/mmap.o
  CC      kernel/mutex.o
  CC      arch/x86/kernel/apic/apic_noop.o
  CC      kernel/hrtimer.o
  CC      mm/mprotect.o
  CC      arch/x86/kernel/apic/ipi.o
  CC      mm/mremap.o
  CC      arch/x86/kernel/apic/hw_nmi.o
  CC      kernel/rwsem.o
  CC      arch/x86/kernel/apic/io_apic.o
  CC      mm/msync.o
  CC      kernel/nsproxy.o
  CC      mm/rmap.o
  CC      kernel/srcu.o
  CC      kernel/semaphore.o
  CC      kernel/notifier.o
  CC      arch/x86/kernel/apic/probe_32.o
  CC      mm/vmalloc.o
  CC      kernel/ksysfs.o
  LD      arch/x86/kernel/apic/built-in.o
  CC      arch/x86/kernel/cpu/intel_cacheinfo.o
  CC      kernel/cred.o
  CC      arch/x86/kernel/cpu/scattered.o
  CC      arch/x86/kernel/cpu/topology.o
  CC      mm/pagewalk.o
  CC      kernel/async.o
  CC      arch/x86/kernel/cpu/proc.o
  MKCAP   arch/x86/kernel/cpu/capflags.c
  CC      mm/pgtable-generic.o
  CC      arch/x86/kernel/cpu/powerflags.o
  CC      arch/x86/kernel/cpu/common.o
  CC      kernel/range.o
  CC      kernel/groups.o
  CC      mm/process_vm_access.o
  CC      mm/init-mm.o
  CC      kernel/events/core.o
  CC      arch/x86/kernel/cpu/vmware.o
  CC      mm/nobootmem.o
  CC      arch/x86/kernel/cpu/hypervisor.o
  CC      mm/memblock.o
  CC      arch/x86/kernel/cpu/sched.o
  CC      arch/x86/kernel/cpu/mshyperv.o
  CC      mm/bounce.o
  CC      arch/x86/kernel/cpu/rdrand.o
  CC      arch/x86/kernel/cpu/bugs.o
  CC      mm/page_io.o
  CC      arch/x86/kernel/cpu/intel.o
  CC      mm/swap_state.o
  CC      arch/x86/kernel/cpu/amd.o
  CC      kernel/events/ring_buffer.o
  CC      mm/swapfile.o
  CC      arch/x86/kernel/cpu/cyrix.o
  CC      kernel/events/callchain.o
  CC      arch/x86/kernel/cpu/centaur.o
  CC      arch/x86/kernel/cpu/transmeta.o
  CC      kernel/events/hw_breakpoint.o
  CC      arch/x86/kernel/cpu/umc.o
  CC      arch/x86/kernel/cpu/perf_event.o
  CC      mm/thrash.o
  LD      kernel/events/built-in.o
  CC      kernel/irq/irqdesc.o
  CC      mm/dmapool.o
  CC      kernel/irq/handle.o
  CC      arch/x86/kernel/cpu/perf_event_amd.o
  CC      mm/hugetlb.o
  CC      kernel/irq/manage.o
  CC      arch/x86/kernel/cpu/perf_event_p6.o
  CC      arch/x86/kernel/cpu/perf_event_p4.o
  CC      kernel/irq/spurious.o
  CC      kernel/irq/resend.o
  CC      arch/x86/kernel/cpu/perf_event_intel_lbr.o
  CC      mm/compaction.o
  CC      kernel/irq/chip.o
  CC      arch/x86/kernel/cpu/perf_event_intel_ds.o
  CC      mm/ksm.o
  CC      kernel/irq/dummychip.o
  CC      arch/x86/kernel/cpu/perf_event_intel.o
  CC      kernel/irq/devres.o
  CC      kernel/irq/autoprobe.o
  CC      mm/slub.o
  CC      kernel/irq/proc.o
  CC      arch/x86/kernel/cpu/mcheck/mce.o
  CC      kernel/irq/migration.o
  CC      kernel/irq/pm.o
  LD      kernel/irq/built-in.o
  CC      kernel/power/main.o
  CC      arch/x86/kernel/cpu/mcheck/mce-severity.o
  CC      arch/x86/kernel/cpu/mcheck/mce_intel.o
  CC      kernel/power/qos.o
  CC      mm/migrate.o
  CC      arch/x86/kernel/cpu/mcheck/mce_amd.o
  CC      kernel/power/console.o
  CC      arch/x86/kernel/cpu/mcheck/threshold.o
  CC      kernel/power/process.o
  CC      arch/x86/kernel/cpu/mcheck/therm_throt.o
  CC      mm/huge_memory.o
  CC      kernel/power/suspend.o
  CC      arch/x86/kernel/cpu/mcheck/mce-apei.o
  LD      arch/x86/kernel/cpu/mcheck/built-in.o
  CC      arch/x86/kernel/cpu/mtrr/main.o
  CC      kernel/power/hibernate.o
  CC      arch/x86/kernel/cpu/mtrr/if.o
  CC      mm/memcontrol.o
  CC      kernel/power/snapshot.o
  CC      arch/x86/kernel/cpu/mtrr/generic.o
  CC      arch/x86/kernel/cpu/mtrr/cleanup.o
  CC      kernel/power/swap.o
  CC      arch/x86/kernel/cpu/mtrr/amd.o
  CC      arch/x86/kernel/cpu/mtrr/cyrix.o
  CC      arch/x86/kernel/cpu/mtrr/centaur.o
  CC      kernel/power/user.o
  CC      mm/page_cgroup.o
  LD      arch/x86/kernel/cpu/mtrr/built-in.o
  CC      arch/x86/kernel/cpu/perfctr-watchdog.o
  CC      kernel/power/block_io.o
  CC      mm/memory-failure.o
  CC      arch/x86/kernel/cpu/perf_event_amd_ibs.o
  CC      kernel/power/poweroff.o
  LD      kernel/power/built-in.o
  CC      kernel/sched/core.o
  CC      arch/x86/kernel/cpu/capflags.o
  LD      arch/x86/kernel/cpu/built-in.o
  CC      arch/x86/kernel/reboot.o
  CC      mm/cleancache.o
  AS      arch/x86/kernel/reboot_32.o
arch/x86/kernel/reboot_32.S: Assembler messages:
arch/x86/kernel/reboot_32.S:134: Warning: shift count out of range (32
is not between 0 and 31)
arch/x86/kernel/reboot_32.S:134: Warning: shift count out of range (40
is not between 0 and 31)
arch/x86/kernel/reboot_32.S:134: Warning: shift count out of range (32
is not between 0 and 31)
  CC      arch/x86/kernel/early-quirks.o
  LD      mm/built-in.o
  CC      fs/open.o
  CC      arch/x86/kernel/apm_32.o
  CC      fs/read_write.o
  CC      arch/x86/kernel/smp.o
  CC      arch/x86/kernel/smpboot.o
  CC      fs/file_table.o
  CC      kernel/sched/clock.o
  CC      arch/x86/kernel/tsc_sync.o
  CC      fs/super.o
  CC      arch/x86/kernel/setup_percpu.o
  CC      kernel/sched/idle_task.o
  CC      kernel/sched/fair.o
  CC      arch/x86/kernel/mpparse.o
  CC      fs/char_dev.o
  CC      arch/x86/kernel/reboot_fixups_32.o
  CC      arch/x86/kernel/ftrace.o
  CC      fs/stat.o
  CC      kernel/sched/rt.o
  CC      arch/x86/kernel/machine_kexec_32.o
  AS      arch/x86/kernel/relocate_kernel_32.o
  CC      arch/x86/kernel/crash.o
  CC      fs/exec.o
  CC      kernel/sched/stop_task.o
  CC      arch/x86/kernel/module.o
  CC      kernel/sched/cpupri.o
  CC      arch/x86/kernel/doublefault_32.o
  CC      kernel/sched/stats.o
  CC      arch/x86/kernel/vm86_32.o
  CC      kernel/sched/debug.o
  CC      fs/pipe.o
  CC      arch/x86/kernel/early_printk.o
  CC      arch/x86/kernel/hpet.o
  LD      kernel/sched/built-in.o
  CC      kernel/time/timekeeping.o
  CC      fs/namei.o
  CC      arch/x86/kernel/amd_nb.o
  CC      kernel/time/ntp.o
  CC      arch/x86/kernel/kvm.o
  CC      kernel/time/clocksource.o
  CC      arch/x86/kernel/kvmclock.o
  CC      arch/x86/kernel/paravirt.o
  CC      fs/fcntl.o
  CC      kernel/time/jiffies.o
  CC      kernel/time/timer_list.o
  CC      arch/x86/kernel/paravirt_patch_32.o
  CC      fs/ioctl.o
  CC      kernel/time/timecompare.o
  CC      arch/x86/kernel/pvclock.o
  CC      arch/x86/kernel/pcspeaker.o
  CC      kernel/time/timeconv.o
  CC      arch/x86/kernel/check.o
  CC      fs/readdir.o
  CC      kernel/time/posix-clock.o
  CC      arch/x86/kernel/devicetree.o
  CC      fs/select.o
  AS      arch/x86/kernel/head_32.o
arch/x86/kernel/head_32.S: Assembler messages:
arch/x86/kernel/head_32.S:64: Warning: shift count out of range (32 is
not between 0 and 31)
  CC      arch/x86/kernel/head32.o
  CC      kernel/time/alarmtimer.o
  CC      arch/x86/kernel/head.o
  CC      arch/x86/kernel/init_task.o
  CC      kernel/time/clockevents.o
  CC      fs/fifo.o
  CC      kernel/time/tick-common.o
  LDS     arch/x86/kernel/vmlinux.lds
  LD      arch/x86/kernel/apm.o
  LD      arch/x86/kernel/built-in.o
  CC      fs/dcache.o
  AS      arch/x86/lguest/i386_head.o
  CC      kernel/time/tick-broadcast.o
  CC      arch/x86/lguest/boot.o
  CC      kernel/time/tick-oneshot.o
  LD      arch/x86/lguest/built-in.o
  CC      arch/x86/mm/init.o
  CC      kernel/time/tick-sched.o
  CC      arch/x86/mm/init_32.o
  CC      fs/inode.o
  CC      kernel/time/timer_stats.o
  LD      kernel/time/built-in.o
  CC      kernel/trace/trace_selftest_dynamic.o
  CC      arch/x86/mm/fault.o
  CC      kernel/trace/trace_clock.o
  CC      fs/attr.o
  CC      kernel/trace/ftrace.o
  CC      arch/x86/mm/ioremap.o
  CC      fs/bad_inode.o
  CC      arch/x86/mm/extable.o
  CC      fs/file.o
  CC      arch/x86/mm/pageattr.o
  CC      fs/filesystems.o
  CC      kernel/trace/ring_buffer.o
  CC      arch/x86/mm/mmap.o
  CC      fs/namespace.o
  CC      arch/x86/mm/pat.o
  CC      arch/x86/mm/pgtable.o
  CC      kernel/trace/trace.o
  CC      arch/x86/mm/physaddr.o
  CC      fs/seq_file.o
  CC      arch/x86/mm/gup.o
  CC      arch/x86/mm/setup_nx.o
  CC      fs/xattr.o
  CC      arch/x86/mm/pat_rbtree.o
  CC      arch/x86/mm/tlb.o
  CC      fs/libfs.o
  CC      kernel/trace/trace_output.o
  CC      arch/x86/mm/pgtable_32.o
  CC      arch/x86/mm/iomap_32.o
  CC      fs/fs-writeback.o
  CC      kernel/trace/trace_stat.o
  CC      arch/x86/mm/hugetlbpage.o
  CC      kernel/trace/trace_printk.o
  CC      arch/x86/mm/highmem_32.o
  CC      arch/x86/mm/kmmio.o
  CC      kernel/trace/trace_sched_switch.o
  CC      fs/pnode.o
  CC      kernel/trace/trace_functions.o
  CC      arch/x86/mm/pf_in.o
  CC      fs/drop_caches.o
  CC      arch/x86/mm/mmio-mod.o
  CC      kernel/trace/trace_sched_wakeup.o
  CC      fs/splice.o
  LD      arch/x86/mm/mmiotrace.o
  LD      arch/x86/mm/built-in.o
  CC      kernel/trace/trace_nop.o
  LD      arch/x86/net/built-in.o
  LD      arch/x86/platform/ce4100/built-in.o
  CC      arch/x86/platform/efi/efi.o
  CC      kernel/trace/trace_stack.o
  CC      fs/sync.o
  CC      arch/x86/platform/efi/efi_32.o
  CC      kernel/trace/trace_mmiotrace.o
  AS      arch/x86/platform/efi/efi_stub_32.o
  LD      arch/x86/platform/efi/built-in.o
  CC      arch/x86/platform/geode/alix.o
  CC      kernel/trace/trace_functions_graph.o
  CC      fs/utimes.o
  LD      arch/x86/platform/geode/built-in.o
  LD      arch/x86/platform/iris/built-in.o
  LD      arch/x86/platform/mrst/built-in.o
  CC      arch/x86/platform/olpc/olpc.o
  CC      fs/stack.o
  CC      arch/x86/platform/olpc/olpc_ofw.o
  CC      kernel/trace/blktrace.o
  CC      fs/fs_struct.o
  CC      arch/x86/platform/olpc/olpc_dt.o
  CC      fs/statfs.o
  CC      arch/x86/platform/olpc/olpc-xo15-sci.o
  LD      arch/x86/platform/olpc/built-in.o
  LD      arch/x86/platform/scx200/built-in.o
  CC      arch/x86/platform/sfi/sfi.o
  CC      fs/buffer.o
  CC      kernel/trace/trace_events.o
  LD      arch/x86/platform/sfi/built-in.o
  LD      arch/x86/platform/uv/built-in.o
  LD      arch/x86/platform/visws/built-in.o
  LD      arch/x86/platform/built-in.o
  LDS     arch/x86/vdso/vdso32/vdso32.lds
  AS      arch/x86/vdso/vdso32/note.o
  AS      arch/x86/vdso/vdso32/int80.o
  AS      arch/x86/vdso/vdso32/sysenter.o
  CC      arch/x86/vdso/vdso32-setup.o
  CC      kernel/trace/trace_export.o
  VDSO    arch/x86/vdso/vdso32-int80.so.dbg
  VDSO    arch/x86/vdso/vdso32-sysenter.so.dbg
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  OBJCOPY arch/x86/vdso/vdso32-int80.so
  OBJCOPY arch/x86/vdso/vdso32-sysenter.so
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  AS      arch/x86/vdso/vdso32.o
  LD      arch/x86/vdso/built-in.o
  LD      arch/x86/built-in.o
  CC      ipc/util.o
  CC      kernel/trace/trace_syscalls.o
  CC      fs/bio.o
  CC      ipc/msgutil.o
  CC      kernel/trace/trace_event_perf.o
  CC      ipc/msg.o
  CC      kernel/trace/trace_events_filter.o
  CC      fs/block_dev.o
  CC      ipc/sem.o
  CC      kernel/trace/power-traces.o
  CC      ipc/shm.o
  CC      fs/direct-io.o
  CC      kernel/trace/rpm-traces.o
  CC      ipc/ipcns_notifier.o
  CC      ipc/syscall.o
  LD      kernel/trace/libftrace.o
  LD      kernel/trace/built-in.o
  CC      kernel/freezer.o
  CC      ipc/ipc_sysctl.o
  CC      ipc/mqueue.o
  CC      kernel/profile.o
  CC      fs/mpage.o
  CC      ipc/namespace.o
  CC      kernel/sysctl_check.o
  CC      ipc/mq_sysctl.o
  CC      fs/ioprio.o
  CC      kernel/stacktrace.o
  LD      ipc/built-in.o
  CC      security/apparmor/apparmorfs.o
  CC      kernel/mutex-debug.o
  CC      fs/proc_namespace.o
  CC      security/apparmor/audit.o
  CC      kernel/futex.o
  GEN     security/apparmor/capability_names.h
  CC      security/apparmor/context.o
  LD      fs/btrfs/built-in.o
  CC [M]  fs/btrfs/super.o
  CC      security/apparmor/ipc.o
  CC      security/apparmor/lib.o
  CC      kernel/rtmutex.o
  CC      security/apparmor/match.o
  CC      kernel/dma.o
  CC      security/apparmor/path.o
  CC      kernel/smp.o
  CC [M]  fs/btrfs/ctree.o
  CC      security/apparmor/domain.o
  CC      kernel/spinlock.o
  CC      security/apparmor/policy.o
  CC      kernel/uid16.o
  CC      kernel/module.o
  CC      security/apparmor/policy_unpack.o
  CC [M]  fs/btrfs/extent-tree.o
  CC      security/apparmor/procattr.o
  CC      security/apparmor/lsm.o
  GEN     security/apparmor/rlim_names.h
  CC      security/apparmor/sid.o
  CC      kernel/kallsyms.o
  CC      security/apparmor/file.o
  CC      kernel/acct.o
  CC      security/apparmor/capability.o
  CC      security/apparmor/resource.o
  CC      kernel/kexec.o
  LD      security/apparmor/apparmor.o
  LD      security/apparmor/built-in.o
  CC      security/keys/gc.o
  CC      security/keys/key.o
  CC      kernel/cgroup.o
  CC [M]  fs/btrfs/print-tree.o
  CC      security/keys/keyring.o
  CC [M]  fs/btrfs/root-tree.o
  CC [M]  fs/btrfs/dir-item.o
  CC      security/keys/keyctl.o
  CC [M]  fs/btrfs/file-item.o
  CC      security/keys/permission.o
  CC      kernel/cgroup_freezer.o
  CC [M]  fs/btrfs/inode-item.o
  CC      kernel/cpuset.o
  CC      security/keys/process_keys.o
  CC [M]  fs/btrfs/inode-map.o
  CC      security/keys/request_key.o
  CC [M]  fs/btrfs/disk-io.o
  CC      kernel/utsname.o
  CC      security/keys/request_key_auth.o
  CC      kernel/user_namespace.o
  CC      security/keys/user_defined.o
  CC      kernel/pid_namespace.o
  CC      security/keys/proc.o
  CC      security/keys/sysctl.o
  GZIP    kernel/config_data.gz
  CC      kernel/res_counter.o
  LD      security/keys/built-in.o
  CC      security/tomoyo/audit.o
  CC      kernel/stop_machine.o
  CC [M]  fs/btrfs/transaction.o
  CC      kernel/audit.o
Creating an empty policy/profile.conf
Creating a default policy/exception_policy.conf
Creating an empty policy/domain_policy.conf
Creating an empty policy/manager.conf
Creating an empty policy/stat.conf
  CC      security/tomoyo/condition.o
  CC [M]  fs/btrfs/inode.o
  CC      security/tomoyo/domain.o
  CC      kernel/auditfilter.o
  CC      security/tomoyo/environ.o
  CC      kernel/auditsc.o
  CC      security/tomoyo/file.o
  CC      security/tomoyo/gc.o
  CC      kernel/audit_watch.o
  CC [M]  fs/btrfs/file.o
  CC      security/tomoyo/group.o
  CC      kernel/audit_tree.o
  CC      security/tomoyo/load_policy.o
  CC      security/tomoyo/memory.o
  CC      kernel/hung_task.o
  CC [M]  fs/btrfs/tree-defrag.o
  CC      kernel/watchdog.o
  CC [M]  fs/btrfs/extent_map.o
  CC      security/tomoyo/mount.o
  CC      kernel/seccomp.o
  CC [M]  fs/btrfs/sysfs.o
  CC      security/tomoyo/network.o
  CC      kernel/rcutree.o
  CC [M]  fs/btrfs/struct-funcs.o
  CC      security/tomoyo/realpath.o
  CC      kernel/relay.o
  CC      security/tomoyo/securityfs_if.o
  CC      security/tomoyo/tomoyo.o
  CC [M]  fs/btrfs/xattr.o
  CC      kernel/utsname_sysctl.o
  CC      kernel/delayacct.o
  CC [M]  fs/btrfs/ordered-data.o
  CC      security/tomoyo/util.o
  CC      kernel/taskstats.o
  CC      kernel/tsacct.o
  CC [M]  fs/btrfs/extent_io.o
Generating built-in policy for TOMOYO 2.5.x.
  CC      security/tomoyo/common.o
  CC      kernel/tracepoint.o
  CC      kernel/elfcore.o
  CC      kernel/irq_work.o
  LD      security/tomoyo/built-in.o
  CC      security/commoncap.o
  CC      kernel/jump_label.o
  CC [M]  fs/btrfs/volumes.o
  CC      kernel/time.o
  CC      security/min_addr.o
  CC      security/security.o
  CHK     kernel/config_data.h
  UPD     kernel/config_data.h
  CC      kernel/configs.o
  LD      kernel/built-in.o
  CC      crypto/api.o
  CC      security/capability.o
  CC      crypto/cipher.o
  CC      crypto/compress.o
  CC [M]  fs/btrfs/async-thread.o
  CC      security/inode.o
  CC      crypto/algapi.o
  CC [M]  fs/btrfs/ioctl.o
  CC      security/lsm_audit.o
  CC      crypto/scatterwalk.o
  CC      security/device_cgroup.o
  LD      security/built-in.o
  CC      block/elevator.o
  CC      crypto/proc.o
  CC [M]  fs/btrfs/locking.o
  CC      crypto/ablkcipher.o
  CC [M]  fs/btrfs/orphan.o
  CC      block/blk-core.o
  CC [M]  fs/btrfs/export.o
  CC      crypto/blkcipher.o
  CC [M]  fs/btrfs/tree-log.o
  CC      crypto/ahash.o
  CC      crypto/shash.o
  CC [M]  fs/btrfs/free-space-cache.o
  CC      block/blk-tag.o
  CC      crypto/algboss.o
  CC      block/blk-sysfs.o
  CC      crypto/testmgr.o
  CC      block/blk-flush.o
  CC [M]  fs/btrfs/zlib.o
  CC      crypto/crypto_wq.o
  CC [M]  fs/btrfs/lzo.o
  CC      block/blk-settings.o
  LD      crypto/crypto_algapi.o
  CC      crypto/aead.o
  CC [M]  fs/btrfs/compression.o
  CC      block/blk-ioc.o
  LD      crypto/crypto_blkcipher.o
  CC [M]  fs/btrfs/delayed-ref.o
  CC      crypto/chainiv.o
  CC      block/blk-map.o
  CC      crypto/eseqiv.o
  CC [M]  fs/btrfs/relocation.o
  CC      block/blk-exec.o
  LD      crypto/crypto_hash.o
  CC      crypto/pcompress.o
  CC      block/blk-merge.o
  LD      crypto/cryptomgr.o
  CC      crypto/rng.o
  CC      crypto/krng.o
  CC      block/blk-softirq.o
  CC [M]  crypto/hmac.o
  CC      block/blk-timeout.o
  CC [M]  fs/btrfs/delayed-inode.o
  CC [M]  crypto/md4.o
  CC      block/blk-iopoll.o
  CC [M]  crypto/md5.o
  CC      block/blk-lib.o
  CC [M]  crypto/sha1_generic.o
  CC [M]  fs/btrfs/scrub.o
  CC [M]  crypto/ecb.o
  CC      block/ioctl.o
  CC [M]  crypto/des_generic.o
  CC [M]  fs/btrfs/reada.o
  CC      block/genhd.o
  CC [M]  crypto/arc4.o
  CC [M]  fs/btrfs/backref.o
  CC [M]  crypto/deflate.o
  CC      block/scsi_ioctl.o
  CC [M]  crypto/zlib.o
  CC [M]  fs/btrfs/ulist.o
  CC [M]  crypto/crc32c.o
  CC [M]  fs/btrfs/acl.o
  CC      block/partition-generic.o
  LD      crypto/crypto.o
  LD      crypto/built-in.o
  CC      drivers/accessibility/braille/braille_console.o
  LD [M]  fs/btrfs/btrfs.o
  LD      fs/cifs/built-in.o
  CC [M]  fs/cifs/cifsfs.o
  LD      drivers/accessibility/braille/built-in.o
  LD      drivers/accessibility/built-in.o
  CC      drivers/acpi/tables.o
  CC      block/partitions/check.o
  CC      drivers/acpi/blacklist.o
  CC      block/partitions/mac.o
  CC      drivers/acpi/osl.o
  CC [M]  fs/cifs/cifssmb.o
  CC      block/partitions/ldm.o
  CC      drivers/acpi/utils.o
  CC      block/partitions/msdos.o
  CC      drivers/acpi/reboot.o
  CC      block/partitions/efi.o
  CC      drivers/acpi/nvs.o
  CC      drivers/acpi/wakeup.o
  CC      block/partitions/karma.o
  CC      drivers/acpi/sleep.o
  LD      block/partitions/built-in.o
  CC [M]  fs/cifs/cifs_debug.o
  CC      block/bsg.o
  CC      drivers/acpi/proc.o
  CC      drivers/acpi/bus.o
  CC [M]  fs/cifs/connect.o
  CC      block/bsg-lib.o
  CC      drivers/acpi/glue.o
  CC      block/blk-cgroup.o
  CC      drivers/acpi/scan.o
  CC      block/blk-throttle.o
  CC      drivers/acpi/processor_core.o
  CC [M]  fs/cifs/dir.o
  CC      drivers/acpi/ec.o
  CC      block/noop-iosched.o
  CC [M]  fs/cifs/file.o
  CC      block/deadline-iosched.o
  CC      drivers/acpi/dock.o
  CC      block/cfq-iosched.o
  CC      drivers/acpi/pci_root.o
  CC      drivers/acpi/pci_link.o
  CC [M]  fs/cifs/inode.o
  CC      drivers/acpi/pci_irq.o
  LD      block/built-in.o
  LD      sound/built-in.o
  CC [M]  sound/sound_core.o
  CC      drivers/acpi/pci_bind.o
  CC [M]  sound/ac97_bus.o
  CC      drivers/acpi/power.o
  CC [M]  fs/cifs/link.o
  LD      sound/arm/built-in.o
  CC      drivers/acpi/event.o
  LD      sound/atmel/built-in.o
  LD      sound/core/oss/built-in.o
  CC [M]  sound/core/oss/pcm_oss.o
  CC [M]  fs/cifs/misc.o
  CC      drivers/acpi/sysfs.o
  CC [M]  fs/cifs/netmisc.o
  CC      drivers/acpi/debugfs.o
  CC      drivers/acpi/video_detect.o
  CC [M]  sound/core/oss/pcm_plugin.o
  CC [M]  fs/cifs/smbencrypt.o
  CC      drivers/acpi/acpica/dsargs.o
  CC [M]  sound/core/oss/io.o
  CC      drivers/acpi/acpica/dscontrol.o
  CC [M]  fs/cifs/transport.o
  CC [M]  sound/core/oss/copy.o
  CC      drivers/acpi/acpica/dsfield.o
  CC      drivers/acpi/acpica/dsinit.o
  CC [M]  sound/core/oss/linear.o
  CC [M]  fs/cifs/asn1.o
  CC      drivers/acpi/acpica/dsmethod.o
  CC [M]  sound/core/oss/mulaw.o
  CC      drivers/acpi/acpica/dsmthdat.o
  CC [M]  sound/core/oss/route.o
  CC [M]  fs/cifs/cifs_unicode.o
  CC      drivers/acpi/acpica/dsobject.o
  CC [M]  sound/core/oss/rate.o
  CC      drivers/acpi/acpica/dsopcode.o
  CC [M]  fs/cifs/nterr.o
  LD [M]  sound/core/oss/snd-pcm-oss.o
  LD      sound/core/seq/built-in.o
  CC [M]  sound/core/seq/seq_device.o
  CC [M]  fs/cifs/xattr.o
  CC      drivers/acpi/acpica/dsutils.o
  CC      drivers/acpi/acpica/dswexec.o
  CC [M]  sound/core/seq/seq_midi_emul.o
  CC [M]  fs/cifs/cifsencrypt.o
  CC      drivers/acpi/acpica/dswload.o
  CC [M]  sound/core/seq/seq_midi_event.o
  CC      drivers/acpi/acpica/dswload2.o
  CC      drivers/acpi/acpica/dswscope.o
  CC [M]  fs/cifs/readdir.o
  CC [M]  sound/core/seq/seq_midi.o
  CC      drivers/acpi/acpica/dswstate.o
  CC [M]  sound/core/seq/seq_virmidi.o
  CC      drivers/acpi/acpica/evevent.o
  CC [M]  fs/cifs/ioctl.o
  CC      drivers/acpi/acpica/evgpe.o
  CC [M]  fs/cifs/sess.o
  CC [M]  sound/core/seq/seq.o
  CC      drivers/acpi/acpica/evgpeblk.o
  CC [M]  sound/core/seq/seq_lock.o
  CC      drivers/acpi/acpica/evgpeinit.o
  CC [M]  sound/core/seq/seq_clientmgr.o
  CC      drivers/acpi/acpica/evgpeutil.o
  CC [M]  fs/cifs/export.o
  CC      drivers/acpi/acpica/evglock.o
  CC      drivers/acpi/acpica/evmisc.o
  CC [M]  fs/cifs/cifsacl.o
  CC      drivers/acpi/acpica/evregion.o
  CC [M]  sound/core/seq/seq_memory.o
  CC      drivers/acpi/acpica/evrgnini.o
  CC [M]  sound/core/seq/seq_queue.o
  CC [M]  fs/cifs/cifs_spnego.o
  CC      drivers/acpi/acpica/evsci.o
  CC      drivers/acpi/acpica/evxface.o
  CC [M]  sound/core/seq/seq_fifo.o
  CC [M]  fs/cifs/dns_resolve.o
  CC      drivers/acpi/acpica/evxfevnt.o
  CC [M]  sound/core/seq/seq_prioq.o
  CC [M]  fs/cifs/cifs_dfs_ref.o
  CC      drivers/acpi/acpica/evxfgpe.o
  CC [M]  sound/core/seq/seq_timer.o
  CC [M]  fs/cifs/fscache.o
  CC      drivers/acpi/acpica/evxfregn.o
  CC [M]  sound/core/seq/seq_system.o
  CC [M]  sound/core/seq/seq_ports.o
  CC      drivers/acpi/acpica/exconfig.o
  CC [M]  fs/cifs/cache.o
  CC      drivers/acpi/acpica/exconvrt.o
  LD [M]  fs/cifs/cifs.o
  CC [M]  sound/core/seq/seq_info.o
  LD      fs/configfs/built-in.o
  CC [M]  fs/configfs/inode.o
  CC      drivers/acpi/acpica/excreate.o
  LD      sound/core/seq/oss/built-in.o
  CC [M]  sound/core/seq/oss/seq_oss.o
  CC      drivers/acpi/acpica/exdebug.o
  CC [M]  fs/configfs/file.o
  CC      drivers/acpi/acpica/exdump.o
  CC [M]  sound/core/seq/oss/seq_oss_init.o
  CC [M]  fs/configfs/dir.o
  CC      drivers/acpi/acpica/exfield.o
  CC [M]  sound/core/seq/oss/seq_oss_timer.o
  CC      drivers/acpi/acpica/exfldio.o
  CC [M]  sound/core/seq/oss/seq_oss_ioctl.o
  CC      drivers/acpi/acpica/exmutex.o
  CC [M]  fs/configfs/symlink.o
  CC [M]  sound/core/seq/oss/seq_oss_event.o
  CC      drivers/acpi/acpica/exnames.o
  CC [M]  fs/configfs/mount.o
  CC      drivers/acpi/acpica/exoparg1.o
  CC [M]  sound/core/seq/oss/seq_oss_rw.o
  CC [M]  fs/configfs/item.o
  CC      drivers/acpi/acpica/exoparg2.o
  CC [M]  sound/core/seq/oss/seq_oss_synth.o
  LD [M]  fs/configfs/configfs.o
  CC      fs/debugfs/inode.o
  CC      drivers/acpi/acpica/exoparg3.o
  CC [M]  sound/core/seq/oss/seq_oss_midi.o
  CC      drivers/acpi/acpica/exoparg6.o
  CC      fs/debugfs/file.o
  CC      drivers/acpi/acpica/exprep.o
  CC [M]  sound/core/seq/oss/seq_oss_readq.o
  CC      drivers/acpi/acpica/exmisc.o
  CC [M]  sound/core/seq/oss/seq_oss_writeq.o
  LD      fs/debugfs/debugfs.o
  LD      fs/debugfs/built-in.o
  CC      fs/devpts/inode.o
  CC      drivers/acpi/acpica/exregion.o
  LD [M]  sound/core/seq/oss/snd-seq-oss.o
  LD [M]  sound/core/seq/snd-seq.o
  LD [M]  sound/core/seq/snd-seq-device.o
  LD [M]  sound/core/seq/snd-seq-midi-event.o
  LD [M]  sound/core/seq/snd-seq-virmidi.o
  LD [M]  sound/core/seq/snd-seq-midi.o
  LD [M]  sound/core/seq/snd-seq-midi-emul.o
  CC [M]  sound/core/hrtimer.o
  CC      drivers/acpi/acpica/exresnte.o
  LD      fs/devpts/devpts.o
  LD      fs/devpts/built-in.o
  LD      fs/dlm/built-in.o
  CC [M]  fs/dlm/ast.o
  CC      drivers/acpi/acpica/exresolv.o
  CC [M]  sound/core/hwdep.o
  CC [M]  fs/dlm/config.o
  CC      drivers/acpi/acpica/exresop.o
  CC [M]  sound/core/memalloc.o
  CC      drivers/acpi/acpica/exstore.o
  CC      drivers/acpi/acpica/exstoren.o
  CC [M]  fs/dlm/dir.o
  CC      drivers/acpi/acpica/exstorob.o
  CC [M]  sound/core/sgbuf.o
  CC [M]  sound/core/pcm.o
  CC      drivers/acpi/acpica/exsystem.o
  CC [M]  fs/dlm/lock.o
  CC      drivers/acpi/acpica/exutils.o
  CC      drivers/acpi/acpica/hwacpi.o
  CC [M]  sound/core/pcm_native.o
  CC      drivers/acpi/acpica/hwgpe.o
  CC      drivers/acpi/acpica/hwpci.o
  CC      drivers/acpi/acpica/hwregs.o
  CC      drivers/acpi/acpica/hwsleep.o
  CC [M]  fs/dlm/lockspace.o
  CC      drivers/acpi/acpica/hwvalid.o
  CC [M]  sound/core/pcm_lib.o
  CC      drivers/acpi/acpica/hwxface.o
  CC [M]  fs/dlm/main.o
  CC      drivers/acpi/acpica/nsaccess.o
  CC [M]  fs/dlm/member.o
  CC      drivers/acpi/acpica/nsalloc.o
  CC [M]  fs/dlm/memory.o
  CC      drivers/acpi/acpica/nsdump.o
  CC [M]  sound/core/pcm_timer.o
  CC [M]  fs/dlm/midcomms.o
  CC      drivers/acpi/acpica/nseval.o
  CC [M]  sound/core/pcm_misc.o
  CC [M]  fs/dlm/netlink.o
  CC      drivers/acpi/acpica/nsinit.o
  CC      drivers/acpi/acpica/nsload.o
  CC [M]  sound/core/pcm_memory.o
  CC [M]  fs/dlm/lowcomms.o
  CC      drivers/acpi/acpica/nsnames.o
  CC [M]  sound/core/rawmidi.o
  CC      drivers/acpi/acpica/nsobject.o
  CC      drivers/acpi/acpica/nsparse.o
  CC [M]  fs/dlm/plock.o
  CC      drivers/acpi/acpica/nspredef.o
  CC [M]  fs/dlm/rcom.o
  CC      drivers/acpi/acpica/nsrepair.o
  CC [M]  sound/core/timer.o
  CC      drivers/acpi/acpica/nsrepair2.o
  CC [M]  fs/dlm/recover.o
  CC      drivers/acpi/acpica/nssearch.o
  CC      drivers/acpi/acpica/nsutils.o
  CC [M]  fs/dlm/recoverd.o
  CC [M]  sound/core/sound.o
  CC      drivers/acpi/acpica/nswalk.o
  CC [M]  fs/dlm/requestqueue.o
  CC      drivers/acpi/acpica/nsxfeval.o
  CC [M]  sound/core/init.o
  CC [M]  fs/dlm/user.o
  CC      drivers/acpi/acpica/nsxfname.o
  CC [M]  fs/dlm/util.o
  CC [M]  sound/core/memory.o
  LD [M]  fs/dlm/dlm.o
  LD      fs/exofs/built-in.o
  CC      drivers/acpi/acpica/nsxfobj.o
  LD      fs/exportfs/built-in.o
  CC [M]  fs/exportfs/expfs.o
  CC [M]  sound/core/info.o
  CC      drivers/acpi/acpica/psargs.o
  LD [M]  fs/exportfs/exportfs.o
  LD      fs/ext4/built-in.o
  CC [M]  fs/ext4/balloc.o
  CC      drivers/acpi/acpica/psloop.o
  CC [M]  sound/core/control.o
  CC      drivers/acpi/acpica/psopcode.o
  CC [M]  fs/ext4/bitmap.o
  CC      drivers/acpi/acpica/psparse.o
  CC [M]  fs/ext4/dir.o
  CC      drivers/acpi/acpica/psscope.o
  CC [M]  sound/core/misc.o
  CC      drivers/acpi/acpica/pstree.o
  CC [M]  fs/ext4/file.o
  CC      drivers/acpi/acpica/psutils.o
  CC [M]  sound/core/device.o
  CC      drivers/acpi/acpica/pswalk.o
  CC [M]  fs/ext4/fsync.o
  CC      drivers/acpi/acpica/psxface.o
  CC [M]  sound/core/isadma.o
  CC [M]  fs/ext4/ialloc.o
  CC      drivers/acpi/acpica/rsaddr.o
  CC [M]  sound/core/sound_oss.o
  CC      drivers/acpi/acpica/rscalc.o
  CC [M]  sound/core/info_oss.o
  CC      drivers/acpi/acpica/rscreate.o
  CC      drivers/acpi/acpica/rsinfo.o
  CC [M]  fs/ext4/inode.o
  CC [M]  sound/core/vmaster.o
  CC      drivers/acpi/acpica/rsio.o
  CC      drivers/acpi/acpica/rsirq.o
  CC [M]  sound/core/ctljack.o
  CC      drivers/acpi/acpica/rslist.o
  CC [M]  sound/core/jack.o
  CC      drivers/acpi/acpica/rsmemory.o
  CC      drivers/acpi/acpica/rsmisc.o
  LD      sound/core/built-in.o
  LD [M]  sound/core/snd.o
  LD [M]  sound/core/snd-hwdep.o
  LD [M]  sound/core/snd-timer.o
  LD [M]  sound/core/snd-hrtimer.o
  LD [M]  sound/core/snd-pcm.o
  LD [M]  sound/core/snd-page-alloc.o
  LD [M]  sound/core/snd-rawmidi.o
  LD      sound/drivers/built-in.o
  CC [M]  sound/drivers/aloop.o
  CC      drivers/acpi/acpica/rsserial.o
  CC      drivers/acpi/acpica/rsutils.o
  CC [M]  fs/ext4/page-io.o
  CC      drivers/acpi/acpica/rsxface.o
  CC [M]  sound/drivers/dummy.o
  CC      drivers/acpi/acpica/tbfadt.o
  CC [M]  fs/ext4/ioctl.o
  CC [M]  sound/drivers/mtpav.o
  CC      drivers/acpi/acpica/tbfind.o
  CC [M]  fs/ext4/namei.o
  CC      drivers/acpi/acpica/tbinstal.o
  CC [M]  sound/drivers/mts64.o
  CC      drivers/acpi/acpica/tbutils.o
  CC [M]  sound/drivers/portman2x4.o
  CC      drivers/acpi/acpica/tbxface.o
  CC      drivers/acpi/acpica/tbxfroot.o
  CC [M]  sound/drivers/serial-u16550.o
  CC [M]  fs/ext4/super.o
  CC      drivers/acpi/acpica/utaddress.o
  CC      drivers/acpi/acpica/utalloc.o
  CC [M]  sound/drivers/virmidi.o
  CC      drivers/acpi/acpica/utcopy.o
  LD      sound/drivers/mpu401/built-in.o
  CC [M]  sound/drivers/mpu401/mpu401_uart.o
  CC      drivers/acpi/acpica/utdebug.o
  CC      drivers/acpi/acpica/utdecode.o
  CC [M]  sound/drivers/mpu401/mpu401.o
  LD [M]  sound/drivers/mpu401/snd-mpu401-uart.o
  CC      drivers/acpi/acpica/utdelete.o
  LD [M]  sound/drivers/mpu401/snd-mpu401.o
  LD      sound/drivers/opl3/built-in.o
  CC [M]  sound/drivers/opl3/opl3_lib.o
  CC      drivers/acpi/acpica/uteval.o
  CC      drivers/acpi/acpica/utglobal.o
  CC [M]  sound/drivers/opl3/opl3_synth.o
  CC      drivers/acpi/acpica/utids.o
  CC [M]  sound/drivers/opl3/opl3_seq.o
  CC      drivers/acpi/acpica/utinit.o
  CC      drivers/acpi/acpica/utlock.o
  CC [M]  sound/drivers/opl3/opl3_midi.o
  CC      drivers/acpi/acpica/utmath.o
  CC      drivers/acpi/acpica/utmisc.o
  CC [M]  sound/drivers/opl3/opl3_drums.o
  CC [M]  sound/drivers/opl3/opl3_oss.o
  CC      drivers/acpi/acpica/utmutex.o
  LD [M]  sound/drivers/opl3/snd-opl3-lib.o
  CC      drivers/acpi/acpica/utobject.o
  LD [M]  sound/drivers/opl3/snd-opl3-synth.o
  LD      sound/drivers/opl4/built-in.o
  CC [M]  sound/drivers/opl4/opl4_lib.o
  CC      drivers/acpi/acpica/utosi.o
  CC [M]  fs/ext4/symlink.o
  CC [M]  sound/drivers/opl4/opl4_mixer.o
  CC      drivers/acpi/acpica/utresrc.o
  CC [M]  sound/drivers/opl4/opl4_proc.o
  CC [M]  fs/ext4/hash.o
  CC      drivers/acpi/acpica/utstate.o
  CC [M]  sound/drivers/opl4/opl4_seq.o
  CC      drivers/acpi/acpica/utxface.o
  CC [M]  fs/ext4/resize.o
  CC [M]  sound/drivers/opl4/opl4_synth.o
  CC      drivers/acpi/acpica/utxferror.o
  CC      drivers/acpi/acpica/utxfmutex.o
  CC [M]  sound/drivers/opl4/yrw801.o
  LD      drivers/acpi/acpica/acpi.o
  LD      drivers/acpi/acpica/built-in.o
  CC      drivers/acpi/apei/apei-base.o
  LD [M]  sound/drivers/opl4/snd-opl4-lib.o
  LD [M]  sound/drivers/opl4/snd-opl4-synth.o
  LD      sound/drivers/pcsp/built-in.o
  CC [M]  fs/ext4/extents.o
  LD      sound/drivers/vx/built-in.o
  CC [M]  sound/drivers/vx/vx_core.o
  CC      drivers/acpi/apei/hest.o
  CC [M]  sound/drivers/vx/vx_hwdep.o
  CC      drivers/acpi/apei/cper.o
  CC [M]  sound/drivers/vx/vx_pcm.o
  CC      drivers/acpi/apei/erst.o
  CC [M]  sound/drivers/vx/vx_mixer.o
  CC [M]  fs/ext4/ext4_jbd2.o
  CC      drivers/acpi/apei/ghes.o
  CC [M]  sound/drivers/vx/vx_cmd.o
  CC [M]  fs/ext4/migrate.o
  CC [M]  sound/drivers/vx/vx_uer.o
  CC [M]  fs/ext4/mballoc.o
  LD      drivers/acpi/apei/apei.o
  LD      drivers/acpi/apei/built-in.o
  CC      drivers/acpi/hed.o
  LD [M]  sound/drivers/vx/snd-vx-lib.o
  LD [M]  sound/drivers/snd-dummy.o
  LD [M]  sound/drivers/snd-aloop.o
  LD [M]  sound/drivers/snd-virmidi.o
  LD [M]  sound/drivers/snd-serial-u16550.o
  LD [M]  sound/drivers/snd-mtpav.o
  LD [M]  sound/drivers/snd-mts64.o
  LD [M]  sound/drivers/snd-portman2x4.o
  LD      sound/firewire/built-in.o
  CC [M]  sound/firewire/lib.o
  CC [M]  drivers/acpi/button.o
  CC [M]  sound/firewire/iso-resources.o
  CC [M]  drivers/acpi/video.o
  CC [M]  sound/firewire/packets-buffer.o
  CC [M]  sound/firewire/fcp.o
  CC [M]  sound/firewire/cmp.o
  CC [M]  drivers/acpi/processor_driver.o
  CC [M]  sound/firewire/amdtp.o
  CC [M]  fs/ext4/block_validity.o
  CC [M]  drivers/acpi/processor_throttling.o
  CC [M]  fs/ext4/move_extent.o
  CC [M]  sound/firewire/speakers.o
  CC [M]  drivers/acpi/processor_idle.o
  CC [M]  sound/firewire/isight.o
  CC [M]  fs/ext4/mmp.o
  CC [M]  drivers/acpi/processor_thermal.o
  CC [M]  drivers/acpi/processor_perflib.o
  LD [M]  sound/firewire/snd-firewire-lib.o
  LD [M]  sound/firewire/snd-firewire-speakers.o
  CC [M]  fs/ext4/indirect.o
  LD [M]  sound/firewire/snd-isight.o
  LD      sound/i2c/built-in.o
  CC [M]  sound/i2c/cs8427.o
  CC [M]  drivers/acpi/container.o
  CC [M]  sound/i2c/i2c.o
  LD      drivers/acpi/acpi.o
  LD [M]  drivers/acpi/processor.o
  LD      drivers/acpi/built-in.o
  CC [M]  fs/ext4/xattr.o
  LD      drivers/ata/built-in.o
  CC [M]  drivers/ata/libata-core.o
  CC [M]  sound/i2c/tea6330t.o
  LD      sound/i2c/other/built-in.o
  CC [M]  sound/i2c/other/ak4113.o
  CC [M]  fs/ext4/xattr_user.o
  CC [M]  fs/ext4/xattr_trusted.o
  CC [M]  sound/i2c/other/ak4114.o
  CC [M]  fs/ext4/acl.o
  CC [M]  sound/i2c/other/ak4117.o
  CC [M]  fs/ext4/xattr_security.o
  CC [M]  drivers/ata/libata-scsi.o
  CC [M]  sound/i2c/other/ak4xxx-adda.o
  LD [M]  fs/ext4/ext4.o
  LD      fs/fat/built-in.o
  CC [M]  fs/fat/cache.o
  CC [M]  fs/fat/dir.o
  CC [M]  sound/i2c/other/pt2258.o
  CC [M]  sound/i2c/other/tea575x-tuner.o
  CC [M]  drivers/ata/libata-eh.o
  LD [M]  sound/i2c/other/snd-ak4117.o
  LD [M]  sound/i2c/other/snd-ak4xxx-adda.o
  LD [M]  sound/i2c/other/snd-ak4114.o
  LD [M]  sound/i2c/other/snd-ak4113.o
  LD [M]  sound/i2c/other/snd-pt2258.o
  LD [M]  sound/i2c/other/snd-tea575x-tuner.o
  LD [M]  sound/i2c/snd-tea6330t.o
  LD [M]  sound/i2c/snd-i2c.o
  LD [M]  sound/i2c/snd-cs8427.o
  LD      sound/isa/built-in.o
  CC [M]  sound/isa/adlib.o
  CC [M]  fs/fat/fatent.o
  CC [M]  sound/isa/als100.o
  CC [M]  sound/isa/azt2320.o
  CC [M]  fs/fat/file.o
  CC [M]  sound/isa/cmi8330.o
  CC [M]  fs/fat/inode.o
  CC [M]  drivers/ata/libata-transport.o
  CC [M]  sound/isa/es18xx.o
  CC [M]  drivers/ata/libata-sff.o
  CC [M]  fs/fat/misc.o
  CC [M]  sound/isa/opl3sa2.o
  CC [M]  fs/fat/namei_msdos.o
  CC [M]  sound/isa/sc6000.o
  CC [M]  drivers/ata/libata-pmp.o
  CC [M]  fs/fat/namei_vfat.o
  CC [M]  sound/isa/sscape.o
  CC [M]  drivers/ata/libata-acpi.o
  LD [M]  fs/fat/fat.o
  LD [M]  fs/fat/vfat.o
  LD [M]  fs/fat/msdos.o
  LD      fs/fscache/built-in.o
  CC [M]  fs/fscache/cache.o
  LD      sound/isa/ad1816a/built-in.o
  CC [M]  sound/isa/ad1816a/ad1816a.o
  CC [M]  sound/isa/ad1816a/ad1816a_lib.o
  CC [M]  fs/fscache/cookie.o
  CC [M]  drivers/ata/pata_arasan_cf.o
  CC [M]  fs/fscache/fsdef.o
  LD [M]  sound/isa/ad1816a/snd-ad1816a.o
  LD      sound/isa/ad1848/built-in.o
  CC [M]  sound/isa/ad1848/ad1848.o
  CC [M]  drivers/ata/pata_amd.o
  LD [M]  sound/isa/ad1848/snd-ad1848.o
  LD      sound/isa/cs423x/built-in.o
  CC [M]  sound/isa/cs423x/cs4231.o
  CC [M]  fs/fscache/main.o
  CC [M]  drivers/ata/pata_acpi.o
  CC [M]  sound/isa/cs423x/cs4236.o
  CC [M]  fs/fscache/netfs.o
  CC [M]  drivers/ata/ata_generic.o
  CC [M]  sound/isa/cs423x/cs4236_lib.o
  CC [M]  fs/fscache/object.o
  LD [M]  drivers/ata/libata.o
  LD      drivers/auxdisplay/built-in.o
  CC      drivers/base/core.o
  LD [M]  sound/isa/cs423x/snd-cs4231.o
  LD [M]  sound/isa/cs423x/snd-cs4236.o
  LD      sound/isa/es1688/built-in.o
  CC [M]  sound/isa/es1688/es1688_lib.o
  CC [M]  fs/fscache/operation.o
  CC      drivers/base/bus.o
  CC [M]  sound/isa/es1688/es1688.o
  CC [M]  fs/fscache/page.o
  LD [M]  sound/isa/es1688/snd-es1688.o
  LD [M]  sound/isa/es1688/snd-es1688-lib.o
  LD      sound/isa/galaxy/built-in.o
  CC [M]  sound/isa/galaxy/azt1605.o
  CC      drivers/base/dd.o
  CC [M]  fs/fscache/proc.o
  CC [M]  sound/isa/galaxy/azt2316.o
  CC      drivers/base/syscore.o
  CC [M]  fs/fscache/stats.o
  CC      drivers/base/driver.o
  LD [M]  sound/isa/galaxy/snd-azt1605.o
  CC [M]  fs/fscache/histogram.o
  LD [M]  sound/isa/galaxy/snd-azt2316.o
  LD      sound/isa/gus/built-in.o
  CC [M]  sound/isa/gus/gus_main.o
  CC      drivers/base/class.o
  LD [M]  fs/fscache/fscache.o
  LD      fs/fuse/built-in.o
  CC [M]  fs/fuse/dev.o
  CC [M]  sound/isa/gus/gus_io.o
  CC      drivers/base/platform.o
  CC [M]  sound/isa/gus/gus_irq.o
  CC [M]  sound/isa/gus/gus_timer.o
  CC      drivers/base/cpu.o
  CC [M]  fs/fuse/dir.o
  CC [M]  sound/isa/gus/gus_mem.o
  CC      drivers/base/firmware.o
  CC      drivers/base/init.o
  CC [M]  sound/isa/gus/gus_mem_proc.o
  CC [M]  fs/fuse/file.o
  CC      drivers/base/map.o
  CC [M]  sound/isa/gus/gus_dram.o
  CC      drivers/base/devres.o
  CC [M]  sound/isa/gus/gus_dma.o
  CC      drivers/base/attribute_container.o
  CC [M]  sound/isa/gus/gus_volume.o
  CC [M]  fs/fuse/inode.o
  CC      drivers/base/transport_class.o
  CC [M]  sound/isa/gus/gus_pcm.o
  CC      drivers/base/topology.o
  CC      drivers/base/devtmpfs.o
  CC [M]  fs/fuse/control.o
  CC [M]  sound/isa/gus/gus_mixer.o
  CC      drivers/base/power/sysfs.o
  LD [M]  fs/fuse/fuse.o
  LD      fs/gfs2/built-in.o
  CC [M]  fs/gfs2/acl.o
  CC [M]  sound/isa/gus/gus_uart.o
  CC      drivers/base/power/generic_ops.o
  CC [M]  fs/gfs2/bmap.o
  CC [M]  sound/isa/gus/gus_reset.o
  CC      drivers/base/power/common.o
  CC      drivers/base/power/qos.o
  CC [M]  sound/isa/gus/gusclassic.o
  CC      drivers/base/power/main.o
  CC [M]  sound/isa/gus/gusextreme.o
  CC [M]  fs/gfs2/dir.o
  CC [M]  sound/isa/gus/gusmax.o
  CC      drivers/base/power/wakeup.o
  CC [M]  sound/isa/gus/interwave-stb.o
  CC      drivers/base/power/runtime.o
  CC [M]  fs/gfs2/xattr.o
  CC [M]  sound/isa/gus/interwave.o
  LD      drivers/base/power/built-in.o
  CC      drivers/base/regmap/regmap.o
  LD [M]  sound/isa/gus/snd-gusclassic.o
  LD [M]  sound/isa/gus/snd-gus-lib.o
  LD [M]  sound/isa/gus/snd-gusmax.o
  LD [M]  sound/isa/gus/snd-gusextreme.o
  LD [M]  sound/isa/gus/snd-interwave.o
  LD [M]  sound/isa/gus/snd-interwave-stb.o
  CC [M]  fs/gfs2/glock.o
  LD      sound/isa/msnd/built-in.o
  CC [M]  sound/isa/msnd/msnd_classic.o
  CC      drivers/base/regmap/regcache.o
  CC [M]  sound/isa/msnd/msnd.o
  CC      drivers/base/regmap/regcache-rbtree.o
  CC      drivers/base/regmap/regcache-lzo.o
  CC [M]  sound/isa/msnd/msnd_midi.o
  CC      drivers/base/regmap/regmap-debugfs.o
  CC [M]  fs/gfs2/glops.o
  CC [M]  sound/isa/msnd/msnd_pinnacle_mixer.o
  CC      drivers/base/regmap/regmap-spi.o
  CC      drivers/base/regmap/regmap-irq.o
  CC [M]  fs/gfs2/log.o
  CC [M]  sound/isa/msnd/msnd_pinnacle.o
  CC [M]  drivers/base/regmap/regmap-i2c.o
  CC [M]  fs/gfs2/lops.o
  LD [M]  sound/isa/msnd/snd-msnd-pinnacle.o
  LD [M]  sound/isa/msnd/snd-msnd-lib.o
  LD [M]  sound/isa/msnd/snd-msnd-classic.o
  LD      sound/isa/opti9xx/built-in.o
  CC [M]  sound/isa/opti9xx/miro.o
  LD      drivers/base/regmap/built-in.o
  CC      drivers/base/dma-mapping.o
  CC      drivers/base/dma-coherent.o
  CC [M]  fs/gfs2/main.o
  CC [M]  sound/isa/opti9xx/opti92x-ad1848.o
  CC      drivers/base/isa.o
  CC [M]  fs/gfs2/meta_io.o
sound/isa/opti9xx/opti92x-ad1848.c: In function ‘__check_isapnp’:
sound/isa/opti9xx/opti92x-ad1848.c:87:1: warning: return from
incompatible pointer type [enabled by default]
  CC      drivers/base/firmware_class.o
  CC [M]  sound/isa/opti9xx/opti92x-cs4231.o
  CC [M]  fs/gfs2/aops.o
In file included from sound/isa/opti9xx/opti92x-cs4231.c:2:0:
sound/isa/opti9xx/opti92x-ad1848.c: In function ‘__check_isapnp’:
sound/isa/opti9xx/opti92x-ad1848.c:87:1: warning: return from
incompatible pointer type [enabled by default]
  CC [M]  sound/isa/opti9xx/opti93x.o
  CC      drivers/base/module.o
  CC [M]  fs/gfs2/dentry.o
  LD      drivers/base/built-in.o
In file included from sound/isa/opti9xx/opti93x.c:2:0:
sound/isa/opti9xx/opti92x-ad1848.c: In function ‘__check_isapnp’:
sound/isa/opti9xx/opti92x-ad1848.c:87:1: warning: return from
incompatible pointer type [enabled by default]
  LD      drivers/block/built-in.o
  CC [M]  drivers/block/floppy.o
  LD [M]  sound/isa/opti9xx/snd-opti92x-ad1848.o
  LD [M]  sound/isa/opti9xx/snd-opti92x-cs4231.o
  LD [M]  sound/isa/opti9xx/snd-opti93x.o
  LD [M]  sound/isa/opti9xx/snd-miro.o
  LD      sound/isa/sb/built-in.o
  CC [M]  sound/isa/sb/emu8000_synth.o
  CC [M]  fs/gfs2/export.o
  CC [M]  sound/isa/sb/emu8000_callback.o
  CC [M]  fs/gfs2/file.o
  CC [M]  sound/isa/sb/emu8000_patch.o
  CC [M]  sound/isa/sb/emu8000_pcm.o
  CC [M]  fs/gfs2/ops_fstype.o
  CC [M]  sound/isa/sb/jazz16.o
  CC [M]  drivers/block/loop.o
  CC [M]  sound/isa/sb/sb_common.o
  CC [M]  fs/gfs2/inode.o
  CC [M]  sound/isa/sb/sb_mixer.o
  LD      drivers/cdrom/built-in.o
  CC      drivers/char/mem.o
  CC [M]  fs/gfs2/quota.o
  CC [M]  sound/isa/sb/sb16_csp.o
  CC      drivers/char/random.o
  CC [M]  sound/isa/sb/sb16_main.o
  CC [M]  fs/gfs2/recovery.o
  CC      drivers/char/misc.o
  CC [M]  sound/isa/sb/sb16.o
  CC      drivers/char/virtio_console.o
  CC [M]  fs/gfs2/rgrp.o
  CC [M]  sound/isa/sb/sb8_main.o
  CC      drivers/char/hpet.o
  CC [M]  fs/gfs2/super.o
  CC [M]  sound/isa/sb/sb8_midi.o
  CC [M]  sound/isa/sb/sb8.o
  LD      drivers/char/agp/built-in.o
  CC [M]  drivers/char/agp/backend.o
  CC [M]  fs/gfs2/sys.o
  CC [M]  sound/isa/sb/sbawe.o
  CC [M]  drivers/char/agp/frontend.o
  CC [M]  sound/isa/sb/emu8000.o
  CC [M]  fs/gfs2/trans.o
  CC [M]  drivers/char/agp/generic.o
  CC [M]  fs/gfs2/util.o
  LD [M]  sound/isa/sb/snd-sb-common.o
  LD [M]  sound/isa/sb/snd-sb16-dsp.o
  LD [M]  sound/isa/sb/snd-sb8-dsp.o
  LD [M]  sound/isa/sb/snd-sb8.o
  LD [M]  sound/isa/sb/snd-sb16.o
  LD [M]  sound/isa/sb/snd-sbawe.o
  LD [M]  sound/isa/sb/snd-jazz16.o
  LD [M]  sound/isa/sb/snd-sb16-csp.o
  LD [M]  sound/isa/sb/snd-emu8000-synth.o
  LD      sound/isa/wavefront/built-in.o
  CC [M]  sound/isa/wavefront/wavefront.o
  CC [M]  fs/gfs2/lock_dlm.o
  CC [M]  sound/isa/wavefront/wavefront_fx.o
  CC [M]  drivers/char/agp/isoch.o
  LD [M]  fs/gfs2/gfs2.o
  CC      fs/hugetlbfs/inode.o
  CC [M]  sound/isa/wavefront/wavefront_synth.o
  CC [M]  drivers/char/agp/amd-k7-agp.o
  CC [M]  drivers/char/agp/intel-agp.o
  LD      fs/hugetlbfs/hugetlbfs.o
  LD      fs/hugetlbfs/built-in.o
  LD      fs/isofs/built-in.o
  CC [M]  fs/isofs/namei.o
  CC [M]  sound/isa/wavefront/wavefront_midi.o
  CC [M]  fs/isofs/inode.o
  CC [M]  drivers/char/agp/intel-gtt.o
  LD [M]  sound/isa/wavefront/snd-wavefront.o
  LD      sound/isa/wss/built-in.o
  CC [M]  sound/isa/wss/wss_lib.o
  CC [M]  fs/isofs/dir.o
  LD [M]  drivers/char/agp/agpgart.o
  CC      drivers/char/hw_random/core.o
  CC [M]  fs/isofs/util.o
  LD [M]  sound/isa/wss/snd-wss-lib.o
  LD [M]  sound/isa/snd-adlib.o
  LD [M]  sound/isa/snd-als100.o
  LD [M]  sound/isa/snd-azt2320.o
  LD [M]  sound/isa/snd-cmi8330.o
  CC [M]  drivers/char/hw_random/amd-rng.o
  LD [M]  sound/isa/snd-es18xx.o
  LD [M]  sound/isa/snd-opl3sa2.o
  LD [M]  sound/isa/snd-sc6000.o
  CC [M]  fs/isofs/rock.o
  LD [M]  sound/isa/snd-sscape.o
  LD      sound/mips/built-in.o
  LD      sound/parisc/built-in.o
  LD      sound/pci/built-in.o
  CC [M]  sound/pci/ad1889.o
  LD      drivers/char/hw_random/rng-core.o
  LD      drivers/char/hw_random/built-in.o
  LD      drivers/char/pcmcia/built-in.o
  CC [M]  drivers/char/nvram.o
  CC [M]  fs/isofs/export.o
  CC [M]  sound/pci/als300.o
  LD      drivers/char/built-in.o
  LD      drivers/clk/built-in.o
  CC      drivers/clocksource/acpi_pm.o
  CC [M]  fs/isofs/joliet.o
  CC      drivers/clocksource/i8253.o
  CC [M]  fs/isofs/compress.o
  CC [M]  sound/pci/als4000.o
  LD      drivers/clocksource/built-in.o
  CC      drivers/connector/cn_queue.o
  LD [M]  fs/isofs/isofs.o
  LD      fs/jbd2/built-in.o
  CC [M]  fs/jbd2/transaction.o
  CC [M]  sound/pci/atiixp_modem.o
  CC      drivers/connector/connector.o
  CC [M]  sound/pci/atiixp.o
  CC      drivers/connector/cn_proc.o
  CC [M]  fs/jbd2/commit.o
  LD      drivers/connector/cn.o
  LD      drivers/connector/built-in.o
  CC      drivers/cpufreq/cpufreq.o
  CC [M]  sound/pci/azt3328.o
  CC [M]  fs/jbd2/recovery.o
  CC [M]  fs/jbd2/checkpoint.o
  CC      drivers/cpufreq/cpufreq_performance.o
  CC [M]  sound/pci/bt87x.o
  CC      drivers/cpufreq/cpufreq_ondemand.o
  CC [M]  fs/jbd2/revoke.o
  CC [M]  sound/pci/cmipci.o
  CC      drivers/cpufreq/freq_table.o
  CC [M]  fs/jbd2/journal.o
  LD      drivers/cpufreq/built-in.o
  CC      drivers/cpuidle/cpuidle.o
  CC      drivers/cpuidle/driver.o
  CC [M]  sound/pci/cs4281.o
  CC      drivers/cpuidle/governor.o
  CC      drivers/cpuidle/sysfs.o
  CC      drivers/cpuidle/governors/ladder.o
  LD [M]  fs/jbd2/jbd2.o
  CC [M]  sound/pci/cs5530.o
  LD      fs/jffs2/built-in.o
  CC [M]  fs/jffs2/compr.o
  CC      drivers/cpuidle/governors/menu.o
  CC [M]  fs/jffs2/dir.o
  CC [M]  sound/pci/ens1370.o
  LD      drivers/cpuidle/governors/built-in.o
  LD      drivers/cpuidle/built-in.o
  LD      drivers/crypto/built-in.o
  LD      drivers/dca/built-in.o
  CC [M]  drivers/dca/dca-core.o
  CC [M]  fs/jffs2/file.o
  CC [M]  drivers/dca/dca-sysfs.o
  CC [M]  sound/pci/ak4531_codec.o
  CC [M]  fs/jffs2/ioctl.o
  LD [M]  drivers/dca/dca.o
  CC      drivers/dma/dmaengine.o
  CC [M]  fs/jffs2/nodelist.o
  CC [M]  sound/pci/ens1371.o
  CC [M]  fs/jffs2/malloc.o
  CC      drivers/dma/iovlock.o
  CC [M]  fs/jffs2/read.o
  CC [M]  sound/pci/es1938.o
  CC [M]  drivers/dma/intel_mid_dma.o
  CC [M]  fs/jffs2/nodemgmt.o
  CC [M]  fs/jffs2/readinode.o
  CC [M]  sound/pci/es1968.o
  CC [M]  drivers/dma/timb_dma.o
  CC [M]  fs/jffs2/write.o
  CC [M]  drivers/dma/pch_dma.o
  CC [M]  sound/pci/fm801.o
  CC [M]  fs/jffs2/scan.o
  LD      drivers/dma/ioat/built-in.o
  CC [M]  drivers/dma/ioat/pci.o
  CC [M]  fs/jffs2/gc.o
  CC [M]  drivers/dma/ioat/dma.o
  CC [M]  sound/pci/intel8x0.o
  CC [M]  fs/jffs2/symlink.o
  CC [M]  fs/jffs2/build.o
  CC [M]  drivers/dma/ioat/dma_v2.o
  CC [M]  sound/pci/intel8x0m.o
  CC [M]  fs/jffs2/erase.o
  CC [M]  fs/jffs2/background.o
  CC [M]  sound/pci/maestro3.o
  CC [M]  drivers/dma/ioat/dma_v3.o
  CC [M]  fs/jffs2/fs.o
  CC [M]  fs/jffs2/writev.o
  CC [M]  sound/pci/rme32.o
  CC [M]  drivers/dma/ioat/dca.o
  CC [M]  fs/jffs2/super.o
  CC [M]  fs/jffs2/debug.o
  CC [M]  sound/pci/rme96.o
  LD [M]  drivers/dma/ioat/ioatdma.o
  LD      drivers/dma/built-in.o
  CC      drivers/edac/edac_stub.o
  CC [M]  fs/jffs2/wbuf.o
  CC [M]  drivers/edac/edac_mc.o
  CC [M]  fs/jffs2/compr_rtime.o
  CC [M]  sound/pci/sis7019.o
  CC [M]  drivers/edac/edac_device.o
  CC [M]  fs/jffs2/compr_zlib.o
  LD [M]  fs/jffs2/jffs2.o
  LD      fs/lockd/built-in.o
  CC [M]  fs/lockd/clntlock.o
  CC [M]  sound/pci/sonicvibes.o
  CC [M]  drivers/edac/edac_mc_sysfs.o
  CC [M]  fs/lockd/clntproc.o
  CC [M]  drivers/edac/edac_pci_sysfs.o
  CC [M]  sound/pci/via82xx_modem.o
  CC [M]  drivers/edac/edac_module.o
  CC [M]  sound/pci/via82xx.o
  CC [M]  fs/lockd/clntxdr.o
  CC [M]  drivers/edac/edac_device_sysfs.o
  CC [M]  drivers/edac/edac_pci.o
  CC [M]  fs/lockd/host.o
  LD      sound/pci/ac97/built-in.o
  CC [M]  sound/pci/ac97/ac97_codec.o
  CC [M]  drivers/edac/amd76x_edac.o
  CC [M]  fs/lockd/svc.o
  LD      drivers/edac/built-in.o
  LD [M]  drivers/edac/edac_core.o
  LD      drivers/firewire/built-in.o
  CC [M]  drivers/firewire/core-card.o
  CC [M]  drivers/firewire/core-cdev.o
  CC [M]  fs/lockd/svclock.o
  CC [M]  fs/lockd/svcshare.o
  CC [M]  drivers/firewire/core-device.o
  CC [M]  fs/lockd/svcproc.o
  CC [M]  sound/pci/ac97/ac97_pcm.o
  CC [M]  drivers/firewire/core-iso.o
  CC [M]  fs/lockd/svcsubs.o
  CC [M]  sound/pci/ac97/ac97_proc.o
  CC [M]  drivers/firewire/core-topology.o
  LD [M]  sound/pci/ac97/snd-ac97-codec.o
  LD      sound/pci/ali5451/built-in.o
  CC [M]  sound/pci/ali5451/ali5451.o
  CC [M]  fs/lockd/mon.o
  CC [M]  drivers/firewire/core-transaction.o
  CC [M]  fs/lockd/xdr.o
  LD [M]  drivers/firewire/firewire-core.o
  CC      drivers/firmware/dmi_scan.o
  LD [M]  sound/pci/ali5451/snd-ali5451.o
  LD      sound/pci/asihpi/built-in.o
  CC [M]  sound/pci/asihpi/asihpi.o
  CC [M]  fs/lockd/grace.o
  CC      drivers/firmware/dmi-id.o
  CC [M]  fs/lockd/clnt4xdr.o
  CC      drivers/firmware/memmap.o
  CC [M]  sound/pci/asihpi/hpioctl.o
  LD      drivers/firmware/built-in.o
  CC      drivers/gpio/gpiolib.o
  CC [M]  fs/lockd/xdr4.o
  CC [M]  sound/pci/asihpi/hpimsginit.o
  CC [M]  sound/pci/asihpi/hpicmn.o
  CC [M]  fs/lockd/svc4proc.o
  CC      drivers/gpio/devres.o
  CC [M]  sound/pci/asihpi/hpifunc.o
  CC      drivers/gpio/gpio-langwell.o
  LD [M]  fs/lockd/lockd.o
  LD      fs/logfs/built-in.o
  CC [M]  fs/logfs/compr.o
  CC      drivers/gpio/gpio-stmpe.o
  CC [M]  fs/logfs/dir.o
  CC      drivers/gpio/gpio-timberdale.o
  CC [M]  sound/pci/asihpi/hpidebug.o
  CC [M]  fs/logfs/file.o
  LD      drivers/gpio/built-in.o
  CC [M]  sound/pci/asihpi/hpidspcd.o
  LD      drivers/gpu/drm/gma500/built-in.o
  CC [M]  drivers/gpu/drm/gma500/gem_glue.o
  CC [M]  fs/logfs/gc.o
  CC [M]  sound/pci/asihpi/hpios.o
  CC [M]  drivers/gpu/drm/gma500/accel_2d.o
  CC [M]  sound/pci/asihpi/hpi6000.o
  CC [M]  fs/logfs/inode.o
  CC [M]  drivers/gpu/drm/gma500/backlight.o
  CC [M]  fs/logfs/journal.o
  CC [M]  sound/pci/asihpi/hpi6205.o
  CC [M]  drivers/gpu/drm/gma500/framebuffer.o
  CC [M]  fs/logfs/readwrite.o
  CC [M]  drivers/gpu/drm/gma500/gem.o
  CC [M]  sound/pci/asihpi/hpimsgx.o
  CC [M]  drivers/gpu/drm/gma500/gtt.o
  LD [M]  sound/pci/asihpi/snd-asihpi.o
  LD      sound/pci/au88x0/built-in.o
  CC [M]  sound/pci/au88x0/au8810.o
  CC [M]  drivers/gpu/drm/gma500/intel_bios.o
  CC [M]  fs/logfs/segment.o
  CC [M]  drivers/gpu/drm/gma500/intel_i2c.o
  CC [M]  fs/logfs/super.o
  CC [M]  drivers/gpu/drm/gma500/intel_gmbus.o
  CC [M]  fs/logfs/dev_bdev.o
  CC [M]  drivers/gpu/drm/gma500/intel_opregion.o
  CC [M]  sound/pci/au88x0/au8820.o
  CC [M]  drivers/gpu/drm/gma500/mmu.o
  LD [M]  fs/logfs/logfs.o
  LD      fs/nfs_common/built-in.o
  CC [M]  fs/nfs_common/nfsacl.o
  LD [M]  fs/nfs_common/nfs_acl.o
  CC [M]  drivers/gpu/drm/gma500/power.o
  LD      fs/nfsd/built-in.o
  CC [M]  fs/nfsd/nfssvc.o
  CC [M]  sound/pci/au88x0/au8830.o
  CC [M]  drivers/gpu/drm/gma500/psb_drv.o
  CC [M]  fs/nfsd/nfsctl.o
  CC [M]  drivers/gpu/drm/gma500/psb_intel_display.o
  CC [M]  fs/nfsd/nfsproc.o
  CC [M]  fs/nfsd/nfsfh.o
  CC [M]  drivers/gpu/drm/gma500/psb_intel_lvds.o
  CC [M]  fs/nfsd/vfs.o
  LD [M]  sound/pci/au88x0/snd-au8810.o
  LD [M]  sound/pci/au88x0/snd-au8820.o
  LD [M]  sound/pci/au88x0/snd-au8830.o
  LD      sound/pci/aw2/built-in.o
  CC [M]  drivers/gpu/drm/gma500/psb_intel_modes.o
  LD      sound/pci/ca0106/built-in.o
  CC [M]  sound/pci/ca0106/ca0106_main.o
  CC [M]  drivers/gpu/drm/gma500/psb_intel_sdvo.o
  CC [M]  sound/pci/ca0106/ca0106_proc.o
  CC [M]  fs/nfsd/export.o
  CC [M]  sound/pci/ca0106/ca0106_mixer.o
  CC [M]  drivers/gpu/drm/gma500/psb_lid.o
  CC [M]  sound/pci/ca0106/ca_midi.o
  CC [M]  drivers/gpu/drm/gma500/psb_irq.o
  CC [M]  fs/nfsd/auth.o
  LD [M]  sound/pci/ca0106/snd-ca0106.o
  LD      sound/pci/cs46xx/built-in.o
  CC [M]  sound/pci/cs46xx/cs46xx.o
  CC [M]  fs/nfsd/lockd.o
  CC [M]  drivers/gpu/drm/gma500/psb_device.o
  CC [M]  fs/nfsd/nfscache.o
  CC [M]  sound/pci/cs46xx/cs46xx_lib.o
  CC [M]  drivers/gpu/drm/gma500/mid_bios.o
  CC [M]  fs/nfsd/nfsxdr.o
  CC [M]  drivers/gpu/drm/gma500/cdv_device.o
  CC [M]  fs/nfsd/stats.o
  CC [M]  fs/nfsd/nfs2acl.o
  CC [M]  drivers/gpu/drm/gma500/cdv_intel_crt.o
  CC [M]  sound/pci/cs46xx/dsp_spos.o
  CC [M]  fs/nfsd/nfs3proc.o
  CC [M]  drivers/gpu/drm/gma500/cdv_intel_display.o
  CC [M]  sound/pci/cs46xx/dsp_spos_scb_lib.o
  CC [M]  fs/nfsd/nfs3xdr.o
  CC [M]  drivers/gpu/drm/gma500/cdv_intel_hdmi.o
  LD [M]  sound/pci/cs46xx/snd-cs46xx.o
  LD      sound/pci/cs5535audio/built-in.o
  CC [M]  sound/pci/cs5535audio/cs5535audio.o
  CC [M]  fs/nfsd/nfs3acl.o
  CC [M]  drivers/gpu/drm/gma500/cdv_intel_lvds.o
  CC [M]  sound/pci/cs5535audio/cs5535audio_pcm.o
  CC [M]  fs/nfsd/nfs4proc.o
  CC [M]  drivers/gpu/drm/gma500/oaktrail_device.o
  CC [M]  sound/pci/cs5535audio/cs5535audio_pm.o
  CC [M]  sound/pci/cs5535audio/cs5535audio_olpc.o
  CC [M]  fs/nfsd/nfs4xdr.o
  CC [M]  drivers/gpu/drm/gma500/oaktrail_crtc.o
  LD [M]  sound/pci/cs5535audio/snd-cs5535audio.o
  LD      sound/pci/ctxfi/built-in.o
  CC [M]  sound/pci/ctxfi/xfi.o
  CC [M]  drivers/gpu/drm/gma500/oaktrail_lvds.o
  CC [M]  sound/pci/ctxfi/ctatc.o
  CC [M]  drivers/gpu/drm/gma500/oaktrail_hdmi.o
  CC [M]  sound/pci/ctxfi/ctvmem.o
  CC [M]  drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.o
  CC [M]  sound/pci/ctxfi/ctpcm.o
  LD [M]  drivers/gpu/drm/gma500/gma500_gfx.o
  LD      drivers/gpu/drm/i2c/built-in.o
  LD      drivers/gpu/drm/i915/built-in.o
  CC [M]  drivers/gpu/drm/i915/i915_drv.o
  CC [M]  sound/pci/ctxfi/ctmixer.o
  CC [M]  fs/nfsd/nfs4state.o
  CC [M]  sound/pci/ctxfi/ctresource.o
  CC [M]  drivers/gpu/drm/i915/i915_dma.o
  CC [M]  sound/pci/ctxfi/ctsrc.o
  CC [M]  sound/pci/ctxfi/ctamixer.o
  CC [M]  sound/pci/ctxfi/ctdaio.o
  CC [M]  drivers/gpu/drm/i915/i915_irq.o
  CC [M]  fs/nfsd/nfs4idmap.o
  CC [M]  sound/pci/ctxfi/ctimap.o
  CC [M]  sound/pci/ctxfi/cthardware.o
  CC [M]  fs/nfsd/nfs4acl.o
  CC [M]  sound/pci/ctxfi/cttimer.o
  CC [M]  drivers/gpu/drm/i915/i915_mem.o
  CC [M]  sound/pci/ctxfi/cthw20k2.o
  CC [M]  fs/nfsd/nfs4callback.o
  CC [M]  drivers/gpu/drm/i915/i915_debugfs.o
  CC [M]  fs/nfsd/nfs4recover.o
  CC [M]  sound/pci/ctxfi/cthw20k1.o
  LD [M]  fs/nfsd/nfsd.o
  CC [M]  drivers/gpu/drm/i915/i915_suspend.o
  CC      fs/nls/nls_base.o
  LD [M]  sound/pci/ctxfi/snd-ctxfi.o
  LD      sound/pci/echoaudio/built-in.o
  CC [M]  sound/pci/echoaudio/darla20.o
  CC      fs/nls/nls_iso8859-1.o
  LD      fs/nls/built-in.o
  CC      fs/notify/fsnotify.o
  CC [M]  drivers/gpu/drm/i915/i915_gem.o
  CC      fs/notify/notification.o
  CC [M]  sound/pci/echoaudio/darla24.o
  CC      fs/notify/group.o
  CC      fs/notify/inode_mark.o
  CC      fs/notify/mark.o
  CC [M]  sound/pci/echoaudio/echo3g.o
  CC      fs/notify/vfsmount_mark.o
  CC [M]  drivers/gpu/drm/i915/i915_gem_debug.o
  CC      fs/notify/dnotify/dnotify.o
  CC [M]  drivers/gpu/drm/i915/i915_gem_evict.o
  LD      fs/notify/dnotify/built-in.o
  CC      fs/notify/fanotify/fanotify.o
  CC [M]  drivers/gpu/drm/i915/i915_gem_execbuffer.o
  CC      fs/notify/fanotify/fanotify_user.o
  CC [M]  sound/pci/echoaudio/gina20.o
  LD      fs/notify/fanotify/built-in.o
  CC      fs/notify/inotify/inotify_fsnotify.o
  CC      fs/notify/inotify/inotify_user.o
  CC [M]  drivers/gpu/drm/i915/i915_gem_gtt.o
  CC [M]  sound/pci/echoaudio/gina24.o
  LD      fs/notify/inotify/built-in.o
  LD      fs/notify/built-in.o
  LD      fs/ocfs2/built-in.o
  CC [M]  fs/ocfs2/alloc.o
  CC [M]  drivers/gpu/drm/i915/i915_gem_tiling.o
  CC [M]  drivers/gpu/drm/i915/i915_trace_points.o
  CC [M]  sound/pci/echoaudio/indigo.o
  CC [M]  drivers/gpu/drm/i915/intel_display.o
  CC [M]  sound/pci/echoaudio/indigodj.o
  CC [M]  sound/pci/echoaudio/indigodjx.o
  CC [M]  sound/pci/echoaudio/indigoio.o
  CC [M]  fs/ocfs2/aops.o
  CC [M]  drivers/gpu/drm/i915/intel_crt.o
  CC [M]  sound/pci/echoaudio/indigoiox.o
  CC [M]  drivers/gpu/drm/i915/intel_lvds.o
  CC [M]  sound/pci/echoaudio/layla20.o
  CC [M]  fs/ocfs2/blockcheck.o
  CC [M]  drivers/gpu/drm/i915/intel_bios.o
  CC [M]  fs/ocfs2/buffer_head_io.o
  CC [M]  drivers/gpu/drm/i915/intel_dp.o
  CC [M]  fs/ocfs2/dcache.o
  CC [M]  sound/pci/echoaudio/layla24.o
  CC [M]  drivers/gpu/drm/i915/intel_hdmi.o
  CC [M]  fs/ocfs2/dir.o
  CC [M]  drivers/gpu/drm/i915/intel_sdvo.o
  CC [M]  sound/pci/echoaudio/mia.o
  CC [M]  drivers/gpu/drm/i915/intel_modes.o
  CC [M]  sound/pci/echoaudio/mona.o
  CC [M]  drivers/gpu/drm/i915/intel_panel.o
  CC [M]  drivers/gpu/drm/i915/intel_i2c.o
  LD [M]  sound/pci/echoaudio/snd-darla20.o
  LD [M]  sound/pci/echoaudio/snd-gina20.o
  LD [M]  sound/pci/echoaudio/snd-layla20.o
  LD [M]  sound/pci/echoaudio/snd-darla24.o
  LD [M]  sound/pci/echoaudio/snd-gina24.o
  LD [M]  sound/pci/echoaudio/snd-layla24.o
  LD [M]  sound/pci/echoaudio/snd-mona.o
  LD [M]  sound/pci/echoaudio/snd-mia.o
  LD [M]  sound/pci/echoaudio/snd-echo3g.o
  LD [M]  sound/pci/echoaudio/snd-indigo.o
  LD [M]  sound/pci/echoaudio/snd-indigoio.o
  LD [M]  sound/pci/echoaudio/snd-indigodj.o
  LD [M]  sound/pci/echoaudio/snd-indigoiox.o
  CC [M]  fs/ocfs2/dlmglue.o
  CC [M]  drivers/gpu/drm/i915/intel_fb.o
  LD [M]  sound/pci/echoaudio/snd-indigodjx.o
  LD      sound/pci/emu10k1/built-in.o
  CC [M]  sound/pci/emu10k1/emu10k1_synth.o
  CC [M]  sound/pci/emu10k1/emu10k1_callback.o
  CC [M]  drivers/gpu/drm/i915/intel_tv.o
  CC [M]  sound/pci/emu10k1/emu10k1_patch.o
  CC [M]  drivers/gpu/drm/i915/intel_dvo.o
  CC [M]  sound/pci/emu10k1/emu10k1.o
  CC [M]  sound/pci/emu10k1/emu10k1_main.o
  CC [M]  drivers/gpu/drm/i915/intel_ringbuffer.o
  CC [M]  fs/ocfs2/export.o
  CC [M]  sound/pci/emu10k1/irq.o
  CC [M]  drivers/gpu/drm/i915/intel_overlay.o
  CC [M]  fs/ocfs2/extent_map.o
  CC [M]  sound/pci/emu10k1/memory.o
  CC [M]  sound/pci/emu10k1/voice.o
  CC [M]  drivers/gpu/drm/i915/intel_sprite.o
  CC [M]  fs/ocfs2/file.o
  CC [M]  sound/pci/emu10k1/emumpu401.o
  CC [M]  drivers/gpu/drm/i915/intel_opregion.o
  CC [M]  sound/pci/emu10k1/emupcm.o
  CC [M]  drivers/gpu/drm/i915/dvo_ch7xxx.o
  CC [M]  drivers/gpu/drm/i915/dvo_ch7017.o
  CC [M]  sound/pci/emu10k1/io.o
  CC [M]  drivers/gpu/drm/i915/dvo_ivch.o
  CC [M]  fs/ocfs2/heartbeat.o
  CC [M]  sound/pci/emu10k1/emuproc.o
  CC [M]  drivers/gpu/drm/i915/dvo_tfp410.o
  CC [M]  fs/ocfs2/inode.o
  CC [M]  sound/pci/emu10k1/emumixer.o
  CC [M]  drivers/gpu/drm/i915/dvo_sil164.o
  CC [M]  drivers/gpu/drm/i915/intel_acpi.o
  CC [M]  sound/pci/emu10k1/emufx.o
  LD [M]  drivers/gpu/drm/i915/i915.o
  LD      drivers/gpu/drm/nouveau/built-in.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_drv.o
  CC [M]  fs/ocfs2/ioctl.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_state.o
  CC [M]  fs/ocfs2/journal.o
  CC [M]  sound/pci/emu10k1/timer.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_channel.o
  CC [M]  sound/pci/emu10k1/p16v.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_mem.o
  CC [M]  sound/pci/emu10k1/emu10k1x.o
  CC [M]  fs/ocfs2/localalloc.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_object.o
  LD [M]  sound/pci/emu10k1/snd-emu10k1.o
  LD [M]  sound/pci/emu10k1/snd-emu10k1-synth.o
  LD [M]  sound/pci/emu10k1/snd-emu10k1x.o
  LD      sound/pci/hda/built-in.o
  CC [M]  sound/pci/hda/patch_analog.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_irq.o
  CC [M]  fs/ocfs2/locks.o
  CC [M]  fs/ocfs2/mmap.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_notifier.o
  CC [M]  sound/pci/hda/patch_ca0110.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_sgdma.o
  CC [M]  fs/ocfs2/namei.o
  CC [M]  sound/pci/hda/patch_ca0132.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_dma.o
  CC [M]  sound/pci/hda/patch_cirrus.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_util.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_bo.o
  CC [M]  sound/pci/hda/patch_cmedia.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_fence.o
  CC [M]  sound/pci/hda/patch_conexant.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_gem.o
  CC [M]  fs/ocfs2/refcounttree.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_ttm.o
  CC [M]  sound/pci/hda/patch_hdmi.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_hw.o
  CC [M]  sound/pci/hda/hda_eld.o
  CC [M]  sound/pci/hda/patch_sigmatel.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_calc.o
  CC [M]  fs/ocfs2/reservations.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_bios.o
  CC [M]  sound/pci/hda/patch_realtek.o
  CC [M]  fs/ocfs2/move_extents.o
  CC [M]  fs/ocfs2/resize.o
  CC [M]  sound/pci/hda/patch_si3054.o
  CC [M]  fs/ocfs2/slot_map.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_i2c.o
  CC [M]  sound/pci/hda/patch_via.o
  CC [M]  fs/ocfs2/suballoc.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_display.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_connector.o
  CC [M]  sound/pci/hda/hda_codec.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_fbcon.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_hdmi.o
  CC [M]  fs/ocfs2/super.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_dp.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_ramht.o
  CC [M]  sound/pci/hda/hda_jack.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_pm.o
  CC [M]  sound/pci/hda/hda_generic.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_volt.o
  CC [M]  sound/pci/hda/hda_proc.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_perf.o
  CC [M]  sound/pci/hda/hda_hwdep.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_temp.o
  CC [M]  sound/pci/hda/hda_beep.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_mm.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_vm.o
  CC [M]  sound/pci/hda/hda_intel.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_mxm.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_gpio.o
  LD [M]  sound/pci/hda/snd-hda-codec.o
  LD [M]  sound/pci/hda/snd-hda-codec-realtek.o
  LD [M]  sound/pci/hda/snd-hda-codec-cmedia.o
  LD [M]  sound/pci/hda/snd-hda-codec-analog.o
  LD [M]  sound/pci/hda/snd-hda-codec-idt.o
  LD [M]  sound/pci/hda/snd-hda-codec-si3054.o
  LD [M]  sound/pci/hda/snd-hda-codec-cirrus.o
  LD [M]  sound/pci/hda/snd-hda-codec-ca0110.o
  LD [M]  sound/pci/hda/snd-hda-codec-ca0132.o
  LD [M]  sound/pci/hda/snd-hda-codec-conexant.o
  LD [M]  sound/pci/hda/snd-hda-codec-via.o
  LD [M]  sound/pci/hda/snd-hda-codec-hdmi.o
  LD [M]  sound/pci/hda/snd-hda-intel.o
  LD      sound/pci/ice1712/built-in.o
  CC [M]  sound/pci/ice1712/ice1712.o
  CC [M]  fs/ocfs2/symlink.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_timer.o
  CC [M]  fs/ocfs2/sysfile.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_mc.o
  CC [M]  drivers/gpu/drm/nouveau/nv40_mc.o
  CC [M]  fs/ocfs2/uptodate.o
  CC [M]  sound/pci/ice1712/delta.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_mc.o
  CC [M]  fs/ocfs2/ver.o
  CC [M]  sound/pci/ice1712/hoontech.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_fb.o
  CC [M]  fs/ocfs2/quota_local.o
  CC [M]  sound/pci/ice1712/ews.o
  CC [M]  drivers/gpu/drm/nouveau/nv10_fb.o
  CC [M]  drivers/gpu/drm/nouveau/nv30_fb.o
  CC [M]  sound/pci/ice1712/ice1724.o
  CC [M]  drivers/gpu/drm/nouveau/nv40_fb.o
  CC [M]  fs/ocfs2/quota_global.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_fb.o
  CC [M]  drivers/gpu/drm/nouveau/nvc0_fb.o
  CC [M]  sound/pci/ice1712/amp.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_fifo.o
  CC [M]  sound/pci/ice1712/revo.o
  CC [M]  fs/ocfs2/xattr.o
  CC [M]  sound/pci/ice1712/aureon.o
  CC [M]  drivers/gpu/drm/nouveau/nv10_fifo.o
  CC [M]  drivers/gpu/drm/nouveau/nv40_fifo.o
  CC [M]  sound/pci/ice1712/vt1720_mobo.o
  CC [M]  sound/pci/ice1712/pontis.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_fifo.o
  CC [M]  sound/pci/ice1712/prodigy192.o
  CC [M]  drivers/gpu/drm/nouveau/nvc0_fifo.o
  CC [M]  sound/pci/ice1712/prodigy_hifi.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_graph.o
  CC [M]  sound/pci/ice1712/juli.o
  CC [M]  drivers/gpu/drm/nouveau/nv10_graph.o
  CC [M]  sound/pci/ice1712/phase.o
  CC [M]  sound/pci/ice1712/wtm.o
  CC [M]  fs/ocfs2/acl.o
  CC [M]  drivers/gpu/drm/nouveau/nv20_graph.o
  CC [M]  sound/pci/ice1712/se.o
  CC [M]  fs/ocfs2/stackglue.o
  CC [M]  sound/pci/ice1712/maya44.o
  CC [M]  drivers/gpu/drm/nouveau/nv40_graph.o
  CC [M]  sound/pci/ice1712/quartet.o
  LD      fs/ocfs2/cluster/built-in.o
  CC [M]  fs/ocfs2/cluster/heartbeat.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_graph.o
  CC [M]  sound/pci/ice1712/ak4xxx.o
  LD [M]  sound/pci/ice1712/snd-ice1712.o
  LD [M]  sound/pci/ice1712/snd-ice17xx-ak4xxx.o
  LD [M]  sound/pci/ice1712/snd-ice1724.o
  LD      sound/pci/korg1212/built-in.o
  CC [M]  sound/pci/korg1212/korg1212.o
  CC [M]  drivers/gpu/drm/nouveau/nvc0_graph.o
  CC [M]  fs/ocfs2/cluster/masklog.o
  LD [M]  sound/pci/korg1212/snd-korg1212.o
  LD      sound/pci/lola/built-in.o
  CC [M]  sound/pci/lola/lola.o
  CC [M]  fs/ocfs2/cluster/sys.o
  CC [M]  drivers/gpu/drm/nouveau/nv40_grctx.o
  CC [M]  fs/ocfs2/cluster/nodemanager.o
  CC [M]  sound/pci/lola/lola_pcm.o
  CC [M]  sound/pci/lola/lola_clock.o
  CC [M]  fs/ocfs2/cluster/quorum.o
  CC [M]  sound/pci/lola/lola_mixer.o
  CC [M]  fs/ocfs2/cluster/tcp.o
  LD [M]  sound/pci/lola/snd-lola.o
  LD      sound/pci/lx6464es/built-in.o
  CC [M]  sound/pci/lx6464es/lx6464es.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_grctx.o
  CC [M]  sound/pci/lx6464es/lx_core.o
  CC [M]  fs/ocfs2/cluster/netdebug.o
  LD [M]  sound/pci/lx6464es/snd-lx6464es.o
  LD      sound/pci/mixart/built-in.o
  CC [M]  sound/pci/mixart/mixart.o
  CC [M]  fs/ocfs2/cluster/ver.o
  CC [M]  sound/pci/mixart/mixart_core.o
  LD [M]  fs/ocfs2/cluster/ocfs2_nodemanager.o
  LD      fs/ocfs2/dlmfs/built-in.o
  CC [M]  fs/ocfs2/dlmfs/userdlm.o
  CC [M]  sound/pci/mixart/mixart_hwdep.o
  CC [M]  fs/ocfs2/dlmfs/dlmfs.o
  CC [M]  sound/pci/mixart/mixart_mixer.o
  CC [M]  drivers/gpu/drm/nouveau/nvc0_grctx.o
  CC [M]  fs/ocfs2/dlmfs/dlmfsver.o
  LD [M]  sound/pci/mixart/snd-mixart.o
  LD      sound/pci/nm256/built-in.o
  CC [M]  sound/pci/nm256/nm256.o
  LD [M]  fs/ocfs2/dlmfs/ocfs2_dlmfs.o
  LD [M]  fs/ocfs2/ocfs2.o
  LD [M]  fs/ocfs2/ocfs2_stackglue.o
  CC      fs/proc/mmu.o
  CC      fs/proc/task_mmu.o
  LD [M]  sound/pci/nm256/snd-nm256.o
  LD      sound/pci/oxygen/built-in.o
  CC [M]  sound/pci/oxygen/oxygen_io.o
  CC      fs/proc/inode.o
  CC [M]  sound/pci/oxygen/oxygen_lib.o
  CC      fs/proc/root.o
  CC [M]  drivers/gpu/drm/nouveau/nv84_crypt.o
  CC      fs/proc/base.o
  CC [M]  sound/pci/oxygen/oxygen_mixer.o
  CC [M]  drivers/gpu/drm/nouveau/nv98_crypt.o
  CC [M]  sound/pci/oxygen/oxygen_pcm.o
  CC [M]  drivers/gpu/drm/nouveau/nva3_copy.o
  CC      fs/proc/generic.o
  CC [M]  sound/pci/oxygen/oxygen.o
  CC [M]  drivers/gpu/drm/nouveau/nvc0_copy.o
  CC [M]  drivers/gpu/drm/nouveau/nv31_mpeg.o
  CC      fs/proc/array.o
  CC [M]  sound/pci/oxygen/xonar_dg.o
  CC [M]  sound/pci/oxygen/virtuoso.o
  CC      fs/proc/proc_tty.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_mpeg.o
  CC      fs/proc/cmdline.o
  CC [M]  sound/pci/oxygen/xonar_lib.o
  CC      fs/proc/consoles.o
  CC [M]  drivers/gpu/drm/nouveau/nv84_bsp.o
  CC [M]  sound/pci/oxygen/xonar_pcm179x.o
  CC      fs/proc/cpuinfo.o
  CC      fs/proc/devices.o
  CC [M]  drivers/gpu/drm/nouveau/nv84_vp.o
  CC      fs/proc/interrupts.o
  CC [M]  sound/pci/oxygen/xonar_cs43xx.o
  CC [M]  drivers/gpu/drm/nouveau/nv98_ppp.o
  CC      fs/proc/loadavg.o
  CC [M]  sound/pci/oxygen/xonar_wm87x6.o
  CC      fs/proc/meminfo.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_instmem.o
  CC      fs/proc/stat.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_instmem.o
  CC [M]  sound/pci/oxygen/xonar_hdmi.o
  CC      fs/proc/uptime.o
  LD [M]  sound/pci/oxygen/snd-oxygen-lib.o
  CC      fs/proc/version.o
  LD [M]  sound/pci/oxygen/snd-oxygen.o
  LD [M]  sound/pci/oxygen/snd-virtuoso.o
  LD      sound/pci/pcxhr/built-in.o
  CC [M]  sound/pci/pcxhr/pcxhr.o
  CC [M]  drivers/gpu/drm/nouveau/nvc0_instmem.o
  CC      fs/proc/softirqs.o
  CC      fs/proc/namespaces.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_dac.o
  CC [M]  sound/pci/pcxhr/pcxhr_hwdep.o
  CC      fs/proc/proc_sysctl.o
  CC [M]  sound/pci/pcxhr/pcxhr_mixer.o
  CC      fs/proc/proc_net.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_dfp.o
  CC      fs/proc/kcore.o
  CC [M]  sound/pci/pcxhr/pcxhr_core.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_tv.o
  CC      fs/proc/proc_devtree.o
  CC [M]  sound/pci/pcxhr/pcxhr_mix22.o
  CC [M]  drivers/gpu/drm/nouveau/nv17_tv.o
  CC      fs/proc/kmsg.o
  CC      fs/proc/page.o
  LD [M]  sound/pci/pcxhr/snd-pcxhr.o
  LD      sound/pci/riptide/built-in.o
  CC [M]  sound/pci/riptide/riptide.o
  CC [M]  drivers/gpu/drm/nouveau/nv17_tv_modes.o
  LD      fs/proc/proc.o
  LD      fs/proc/built-in.o
  CC      fs/pstore/inode.o
  CC      fs/pstore/platform.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_crtc.o
  LD [M]  sound/pci/riptide/snd-riptide.o
  LD      sound/pci/rme9652/built-in.o
  CC [M]  sound/pci/rme9652/hdsp.o
  LD      fs/pstore/pstore.o
  LD      fs/pstore/built-in.o
  CC      fs/quota/dquot.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_display.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_cursor.o
  CC      fs/quota/quota.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_evo.o
  CC [M]  sound/pci/rme9652/hdspm.o
  CC      fs/quota/netlink.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_crtc.o
  CC [M]  fs/quota/quota_tree.o
  LD      fs/quota/built-in.o
  CC      fs/ramfs/inode.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_dac.o
  CC      fs/ramfs/file-mmu.o
  LD      fs/ramfs/ramfs.o
  LD      fs/ramfs/built-in.o
  LD      fs/reiserfs/built-in.o
  CC [M]  fs/reiserfs/bitmap.o
  CC [M]  sound/pci/rme9652/rme9652.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_sor.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_cursor.o
  CC [M]  fs/reiserfs/do_balan.o
  LD [M]  sound/pci/rme9652/snd-rme9652.o
  LD [M]  sound/pci/rme9652/snd-hdsp.o
  LD [M]  sound/pci/rme9652/snd-hdspm.o
  LD      sound/pci/trident/built-in.o
  CC [M]  sound/pci/trident/trident.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_display.o
  CC [M]  sound/pci/trident/trident_main.o
  CC [M]  fs/reiserfs/namei.o
  CC [M]  drivers/gpu/drm/nouveau/nvd0_display.o
  CC [M]  fs/reiserfs/inode.o
  CC [M]  sound/pci/trident/trident_memory.o
  LD [M]  sound/pci/trident/snd-trident.o
  LD      sound/pci/vx222/built-in.o
  CC [M]  sound/pci/vx222/vx222.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_fbcon.o
  CC [M]  sound/pci/vx222/vx222_ops.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_fbcon.o
  CC [M]  fs/reiserfs/file.o
  LD [M]  sound/pci/vx222/snd-vx222.o
  LD      sound/pci/ymfpci/built-in.o
  CC [M]  sound/pci/ymfpci/ymfpci.o
  CC [M]  drivers/gpu/drm/nouveau/nvc0_fbcon.o
  CC [M]  fs/reiserfs/dir.o
  CC [M]  sound/pci/ymfpci/ymfpci_main.o
  CC [M]  fs/reiserfs/fix_node.o
  CC [M]  drivers/gpu/drm/nouveau/nv10_gpio.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_gpio.o
  LD [M]  sound/pci/ymfpci/snd-ymfpci.o
  LD [M]  sound/pci/snd-ad1889.o
  LD [M]  sound/pci/snd-als300.o
  LD [M]  sound/pci/snd-als4000.o
  LD [M]  sound/pci/snd-atiixp.o
  LD [M]  sound/pci/snd-atiixp-modem.o
  LD [M]  sound/pci/snd-azt3328.o
  LD [M]  sound/pci/snd-bt87x.o
  LD [M]  sound/pci/snd-cmipci.o
  LD [M]  sound/pci/snd-cs4281.o
  LD [M]  sound/pci/snd-cs5530.o
  LD [M]  sound/pci/snd-ens1370.o
  LD [M]  sound/pci/snd-ens1371.o
  LD [M]  sound/pci/snd-es1938.o
  LD [M]  sound/pci/snd-es1968.o
  LD [M]  sound/pci/snd-fm801.o
  LD [M]  sound/pci/snd-intel8x0.o
  LD [M]  sound/pci/snd-intel8x0m.o
  LD [M]  sound/pci/snd-maestro3.o
  LD [M]  sound/pci/snd-rme32.o
  LD [M]  sound/pci/snd-rme96.o
  LD [M]  sound/pci/snd-sis7019.o
  LD [M]  sound/pci/snd-sonicvibes.o
  LD [M]  sound/pci/snd-via82xx.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_calc.o
  LD [M]  sound/pci/snd-via82xx-modem.o
  LD      sound/pcmcia/built-in.o
  LD      sound/pcmcia/pdaudiocf/built-in.o
  CC [M]  sound/pcmcia/pdaudiocf/pdaudiocf.o
  CC [M]  fs/reiserfs/super.o
  CC [M]  drivers/gpu/drm/nouveau/nv04_pm.o
  CC [M]  sound/pcmcia/pdaudiocf/pdaudiocf_core.o
  CC [M]  drivers/gpu/drm/nouveau/nv40_pm.o
  CC [M]  sound/pcmcia/pdaudiocf/pdaudiocf_irq.o
  CC [M]  sound/pcmcia/pdaudiocf/pdaudiocf_pcm.o
  CC [M]  fs/reiserfs/prints.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_pm.o
  LD [M]  sound/pcmcia/pdaudiocf/snd-pdaudiocf.o
  LD      sound/pcmcia/vx/built-in.o
  CC [M]  sound/pcmcia/vx/vxpocket.o
  CC [M]  fs/reiserfs/objectid.o
  CC [M]  sound/pcmcia/vx/vxp_ops.o
  CC [M]  drivers/gpu/drm/nouveau/nva3_pm.o
  CC [M]  fs/reiserfs/lbalance.o
  CC [M]  sound/pcmcia/vx/vxp_mixer.o
  CC [M]  drivers/gpu/drm/nouveau/nvc0_pm.o
  LD [M]  sound/pcmcia/vx/snd-vxpocket.o
  LD      sound/ppc/built-in.o
  LD      sound/sh/built-in.o
  LD      sound/soc/built-in.o
  CC [M]  sound/soc/soc-core.o
  CC [M]  fs/reiserfs/ibalance.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_vram.o
  CC [M]  fs/reiserfs/stree.o
  CC [M]  drivers/gpu/drm/nouveau/nvc0_vram.o
  CC [M]  drivers/gpu/drm/nouveau/nv50_vm.o
  CC [M]  drivers/gpu/drm/nouveau/nvc0_vm.o
  CC [M]  fs/reiserfs/hashes.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_debugfs.o
  CC [M]  sound/soc/soc-dapm.o
  CC [M]  fs/reiserfs/tail_conversion.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_backlight.o
  CC [M]  fs/reiserfs/journal.o
  CC [M]  drivers/gpu/drm/nouveau/nouveau_acpi.o
  LD [M]  drivers/gpu/drm/nouveau/nouveau.o
  CC [M]  sound/soc/soc-jack.o
  LD      drivers/gpu/drm/radeon/built-in.o
  CC [M]  drivers/gpu/drm/radeon/radeon_drv.o
  CC [M]  drivers/gpu/drm/radeon/radeon_cp.o
  CC [M]  sound/soc/soc-cache.o
  CC [M]  fs/reiserfs/resize.o
  CC [M]  fs/reiserfs/item_ops.o
  CC [M]  sound/soc/soc-utils.o
  CC [M]  sound/soc/soc-pcm.o
  CC [M]  fs/reiserfs/ioctl.o
  CC [M]  drivers/gpu/drm/radeon/radeon_state.o
  CC [M]  fs/reiserfs/xattr.o
  CC [M]  sound/soc/soc-io.o
  LD      sound/soc/atmel/built-in.o
  LD      sound/soc/au1x/built-in.o
  LD      sound/soc/blackfin/built-in.o
  LD      sound/soc/codecs/built-in.o
  LD      sound/soc/davinci/built-in.o
  CC [M]  fs/reiserfs/lock.o
  LD      sound/soc/ep93xx/built-in.o
  LD      sound/soc/fsl/built-in.o
  LD      sound/soc/imx/built-in.o
  LD      sound/soc/jz4740/built-in.o
  LD      sound/soc/kirkwood/built-in.o
  LD      sound/soc/mid-x86/built-in.o
  LD      sound/soc/mxs/built-in.o
  LD      sound/soc/nuc900/built-in.o
  LD      sound/soc/omap/built-in.o
  LD      sound/soc/pxa/built-in.o
  LD      sound/soc/s6000/built-in.o
  LD      sound/soc/samsung/built-in.o
  LD      sound/soc/sh/built-in.o
  LD      sound/soc/tegra/built-in.o
  LD      sound/soc/txx9/built-in.o
  LD [M]  sound/soc/snd-soc-core.o
  LD      sound/sparc/built-in.o
  CC [M]  fs/reiserfs/procfs.o
  LD      sound/spi/built-in.o
  LD      sound/synth/built-in.o
  CC [M]  sound/synth/util_mem.o
  CC [M]  fs/reiserfs/xattr_user.o
  LD      sound/synth/emux/built-in.o
  CC [M]  sound/synth/emux/emux.o
  CC [M]  fs/reiserfs/xattr_trusted.o
  CC [M]  sound/synth/emux/emux_synth.o
  CC [M]  fs/reiserfs/xattr_security.o
  CC [M]  sound/synth/emux/emux_seq.o
  CC [M]  drivers/gpu/drm/radeon/radeon_mem.o
  CC [M]  fs/reiserfs/xattr_acl.o
  CC [M]  sound/synth/emux/emux_nrpn.o
  CC [M]  drivers/gpu/drm/radeon/radeon_irq.o
  LD [M]  fs/reiserfs/reiserfs.o
  CC      fs/sysfs/inode.o
  CC [M]  sound/synth/emux/emux_effect.o
  CC      fs/sysfs/file.o
  CC [M]  drivers/gpu/drm/radeon/r300_cmdbuf.o
  CC [M]  sound/synth/emux/emux_proc.o
  CC [M]  sound/synth/emux/emux_hwdep.o
  CC      fs/sysfs/dir.o
  CC [M]  sound/synth/emux/soundfont.o
  CC      fs/sysfs/symlink.o
  CC [M]  sound/synth/emux/emux_oss.o
  CC [M]  drivers/gpu/drm/radeon/r600_cp.o
  CC      fs/sysfs/mount.o
  LD [M]  sound/synth/emux/snd-emux-synth.o
  LD [M]  sound/synth/snd-util-mem.o
  LD      sound/usb/built-in.o
  CC [M]  sound/usb/card.o
  CC      fs/sysfs/bin.o
  CC [M]  sound/usb/clock.o
  CC      fs/sysfs/group.o
  CC [M]  drivers/gpu/drm/radeon/radeon_device.o
  CC [M]  sound/usb/endpoint.o
  LD      fs/sysfs/built-in.o
  LD      fs/xfs/built-in.o
  CC [M]  fs/xfs/xfs_trace.o
  CC [M]  sound/usb/format.o
  CC [M]  drivers/gpu/drm/radeon/radeon_asic.o
  CC [M]  sound/usb/helper.o
  CC [M]  drivers/gpu/drm/radeon/radeon_kms.o
  CC [M]  sound/usb/mixer.o
  CC [M]  drivers/gpu/drm/radeon/radeon_atombios.o
  CC [M]  sound/usb/mixer_quirks.o
  CC [M]  fs/xfs/xfs_aops.o
  CC [M]  sound/usb/pcm.o
  CC [M]  drivers/gpu/drm/radeon/radeon_agp.o
  CC [M]  sound/usb/proc.o
  CC [M]  drivers/gpu/drm/radeon/atombios_crtc.o
  CC [M]  fs/xfs/xfs_bit.o
  CC [M]  sound/usb/quirks.o
  CC [M]  fs/xfs/xfs_buf.o
  CC [M]  sound/usb/stream.o
  CC [M]  drivers/gpu/drm/radeon/radeon_combios.o
  CC [M]  sound/usb/midi.o
  CC [M]  fs/xfs/xfs_dfrag.o
  CC [M]  fs/xfs/xfs_discard.o
  CC [M]  drivers/gpu/drm/radeon/atom.o
  LD      sound/usb/6fire/built-in.o
  CC [M]  sound/usb/6fire/chip.o
  CC [M]  sound/usb/6fire/comm.o
  CC [M]  fs/xfs/xfs_error.o
  CC [M]  sound/usb/6fire/midi.o
  CC [M]  fs/xfs/xfs_export.o
  CC [M]  drivers/gpu/drm/radeon/radeon_fence.o
  CC [M]  sound/usb/6fire/control.o
  CC [M]  sound/usb/6fire/firmware.o
  CC [M]  fs/xfs/xfs_file.o
  CC [M]  drivers/gpu/drm/radeon/radeon_ttm.o
  CC [M]  sound/usb/6fire/pcm.o
  CC [M]  fs/xfs/xfs_filestream.o
  CC [M]  drivers/gpu/drm/radeon/radeon_object.o
  LD [M]  sound/usb/6fire/snd-usb-6fire.o
  LD      sound/usb/caiaq/built-in.o
  CC [M]  sound/usb/caiaq/device.o
  CC [M]  fs/xfs/xfs_fsops.o
  CC [M]  sound/usb/caiaq/audio.o
  CC [M]  drivers/gpu/drm/radeon/radeon_gart.o
  CC [M]  sound/usb/caiaq/midi.o
  CC [M]  fs/xfs/xfs_fs_subr.o
  CC [M]  drivers/gpu/drm/radeon/radeon_legacy_crtc.o
  CC [M]  sound/usb/caiaq/control.o
  CC [M]  sound/usb/caiaq/input.o
  CC [M]  fs/xfs/xfs_globals.o
  CC [M]  drivers/gpu/drm/radeon/radeon_legacy_encoders.o
  CC [M]  fs/xfs/xfs_iget.o
  LD [M]  sound/usb/caiaq/snd-usb-caiaq.o
  LD      sound/usb/misc/built-in.o
  CC [M]  sound/usb/misc/ua101.o
  CC [M]  drivers/gpu/drm/radeon/radeon_connectors.o
  CC [M]  fs/xfs/xfs_ioctl.o
  LD [M]  sound/usb/misc/snd-ua101.o
  LD      sound/usb/usx2y/built-in.o
  CC [M]  sound/usb/usx2y/us122l.o
  CC [M]  drivers/gpu/drm/radeon/radeon_encoders.o
  CC [M]  fs/xfs/xfs_iomap.o
  CC [M]  sound/usb/usx2y/usbusx2y.o
  CC [M]  drivers/gpu/drm/radeon/radeon_display.o
  CC [M]  sound/usb/usx2y/usX2Yhwdep.o
  CC [M]  fs/xfs/xfs_iops.o
  CC [M]  sound/usb/usx2y/usx2yhwdeppcm.o
  CC [M]  drivers/gpu/drm/radeon/radeon_cursor.o
  CC [M]  fs/xfs/xfs_itable.o
  CC [M]  drivers/gpu/drm/radeon/radeon_i2c.o
  LD [M]  sound/usb/usx2y/snd-usb-usx2y.o
  LD [M]  sound/usb/usx2y/snd-usb-us122l.o
  LD [M]  sound/usb/snd-usb-audio.o
  LD [M]  sound/usb/snd-usbmidi-lib.o
  LD [M]  sound/soundcore.o
  MK_FW   firmware/sb16/mulaw_main.csp.gen.S
  IHEX    firmware/sb16/mulaw_main.csp
  MK_FW   firmware/sb16/alaw_main.csp.gen.S
  IHEX    firmware/sb16/alaw_main.csp
  MK_FW   firmware/sb16/ima_adpcm_init.csp.gen.S
  IHEX    firmware/sb16/ima_adpcm_init.csp
  MK_FW   firmware/sb16/ima_adpcm_playback.csp.gen.S
  IHEX    firmware/sb16/ima_adpcm_playback.csp
  MK_FW   firmware/sb16/ima_adpcm_capture.csp.gen.S
  IHEX    firmware/sb16/ima_adpcm_capture.csp
  AS      firmware/sb16/mulaw_main.csp.gen.o
  AS      firmware/sb16/alaw_main.csp.gen.o
  AS      firmware/sb16/ima_adpcm_init.csp.gen.o
  CC [M]  fs/xfs/xfs_message.o
  AS      firmware/sb16/ima_adpcm_playback.csp.gen.o
  AS      firmware/sb16/ima_adpcm_capture.csp.gen.o
  LD      firmware/built-in.o
  CC      arch/x86/pci/i386.o
  CC [M]  drivers/gpu/drm/radeon/radeon_clocks.o
  CC [M]  fs/xfs/xfs_mru_cache.o
  CC      arch/x86/pci/init.o
  CC      arch/x86/pci/pcbios.o
  CC [M]  drivers/gpu/drm/radeon/radeon_fb.o
  CC [M]  fs/xfs/xfs_super.o
  CC      arch/x86/pci/mmconfig_32.o
  CC [M]  drivers/gpu/drm/radeon/radeon_gem.o
  CC      arch/x86/pci/direct.o
  CC      arch/x86/pci/mmconfig-shared.o
  CC [M]  fs/xfs/xfs_sync.o
  CC [M]  drivers/gpu/drm/radeon/radeon_ring.o
  CC      arch/x86/pci/olpc.o
  CC [M]  fs/xfs/xfs_xattr.o
  CC      arch/x86/pci/fixup.o
  CC [M]  drivers/gpu/drm/radeon/radeon_irq_kms.o
  CC      arch/x86/pci/acpi.o
  CC [M]  fs/xfs/xfs_rename.o
  CC [M]  drivers/gpu/drm/radeon/radeon_cs.o
  CC      arch/x86/pci/legacy.o
  CC [M]  fs/xfs/xfs_rw.o
  CC [M]  drivers/gpu/drm/radeon/radeon_bios.o
  CC      arch/x86/pci/irq.o
  CC [M]  fs/xfs/xfs_utils.o
  CC [M]  fs/xfs/xfs_vnodeops.o
  CC [M]  drivers/gpu/drm/radeon/radeon_benchmark.o
  CC      arch/x86/pci/common.o
  HOSTCC  drivers/gpu/drm/radeon/mkregtable
  CC      arch/x86/pci/early.o
  CC [M]  drivers/gpu/drm/radeon/rs400.o
  CC      arch/x86/pci/bus_numa.o
  CC [M]  fs/xfs/kmem.o
  CC      arch/x86/pci/amd_bus.o
  MKREGTABLE drivers/gpu/drm/radeon/rs600_reg_safe.h
  CC [M]  drivers/gpu/drm/radeon/rs690.o
  CC [M]  fs/xfs/uuid.o
  LD      arch/x86/pci/built-in.o
  CC      arch/x86/power/cpu.o
  CC [M]  fs/xfs/xfs_alloc.o
  CC      arch/x86/power/hibernate_32.o
  MKREGTABLE drivers/gpu/drm/radeon/rv515_reg_safe.h
  CC [M]  drivers/gpu/drm/radeon/r520.o
  AS      arch/x86/power/hibernate_asm_32.o
  LD      arch/x86/power/built-in.o
  CC      arch/x86/video/fbdev.o
  CC [M]  drivers/gpu/drm/radeon/r600.o
  LD      arch/x86/video/built-in.o
  CC      net/socket.o
  CC [M]  fs/xfs/xfs_alloc_btree.o
  CC [M]  fs/xfs/xfs_attr.o
  CC [M]  drivers/gpu/drm/radeon/rv770.o
  LD      net/802/built-in.o
  CC      net/core/sock.o
  CC [M]  fs/xfs/xfs_attr_leaf.o
  CC [M]  drivers/gpu/drm/radeon/radeon_test.o
  MKREGTABLE drivers/gpu/drm/radeon/r200_reg_safe.h
  CC [M]  drivers/gpu/drm/radeon/radeon_legacy_tv.o
  CC      net/core/request_sock.o
  MKREGTABLE drivers/gpu/drm/radeon/r600_reg_safe.h
  CC [M]  drivers/gpu/drm/radeon/r600_blit.o
  CC [M]  fs/xfs/xfs_bmap.o
  CC      net/core/skbuff.o
  CC [M]  drivers/gpu/drm/radeon/r600_blit_shaders.o
  CC [M]  drivers/gpu/drm/radeon/r600_blit_kms.o
  CC [M]  drivers/gpu/drm/radeon/radeon_pm.o
  CC [M]  drivers/gpu/drm/radeon/atombios_dp.o
  CC      net/core/iovec.o
  CC [M]  drivers/gpu/drm/radeon/r600_audio.o
  CC [M]  fs/xfs/xfs_bmap_btree.o
  CC      net/core/datagram.o
  CC [M]  drivers/gpu/drm/radeon/r600_hdmi.o
  CC [M]  fs/xfs/xfs_btree.o
  CC [M]  drivers/gpu/drm/radeon/evergreen.o
  CC      net/core/stream.o
  CC      net/core/scm.o
  CC [M]  fs/xfs/xfs_da_btree.o
  MKREGTABLE drivers/gpu/drm/radeon/evergreen_reg_safe.h
  MKREGTABLE drivers/gpu/drm/radeon/cayman_reg_safe.h
  CC [M]  drivers/gpu/drm/radeon/evergreen_blit_shaders.o
  CC [M]  drivers/gpu/drm/radeon/evergreen_blit_kms.o
  CC      net/core/gen_stats.o
  CC [M]  drivers/gpu/drm/radeon/radeon_trace_points.o
  CC      net/core/gen_estimator.o
  CC [M]  drivers/gpu/drm/radeon/ni.o
  CC [M]  fs/xfs/xfs_dir2.o
  CC      net/core/net_namespace.o
  CC [M]  drivers/gpu/drm/radeon/cayman_blit_shaders.o
  CC [M]  fs/xfs/xfs_dir2_block.o
  CC [M]  drivers/gpu/drm/radeon/atombios_encoders.o
  CC      net/core/secure_seq.o
  CC      net/core/flow_dissector.o
  CC [M]  fs/xfs/xfs_dir2_data.o
  CC [M]  drivers/gpu/drm/radeon/radeon_semaphore.o
  CC      net/core/sysctl_net_core.o
  CC [M]  fs/xfs/xfs_dir2_leaf.o
  CC      net/core/dev.o
  CC [M]  drivers/gpu/drm/radeon/radeon_sa.o
  CC [M]  drivers/gpu/drm/radeon/radeon_atpx_handler.o
  CC [M]  drivers/gpu/drm/radeon/radeon_acpi.o
  CC [M]  fs/xfs/xfs_dir2_node.o
  MKREGTABLE drivers/gpu/drm/radeon/r100_reg_safe.h
  MKREGTABLE drivers/gpu/drm/radeon/rn50_reg_safe.h
  MKREGTABLE drivers/gpu/drm/radeon/r300_reg_safe.h
  MKREGTABLE drivers/gpu/drm/radeon/r420_reg_safe.h
  CC [M]  drivers/gpu/drm/radeon/rs600.o
  CC [M]  drivers/gpu/drm/radeon/rv515.o
  CC [M]  fs/xfs/xfs_dir2_sf.o
  CC      net/core/ethtool.o
  CC [M]  fs/xfs/xfs_ialloc.o
  CC [M]  drivers/gpu/drm/radeon/r200.o
  CC [M]  fs/xfs/xfs_ialloc_btree.o
  CC [M]  drivers/gpu/drm/radeon/r600_cs.o
  CC      net/core/dev_addr_lists.o
  CC [M]  fs/xfs/xfs_inode.o
  CC      net/core/dst.o
  CC [M]  drivers/gpu/drm/radeon/evergreen_cs.o
  CC      net/core/netevent.o
  CC [M]  fs/xfs/xfs_log_recover.o
  CC      net/core/neighbour.o
  CC [M]  drivers/gpu/drm/radeon/r100.o
  CC [M]  fs/xfs/xfs_mount.o
  CC      net/core/rtnetlink.o
  CC [M]  drivers/gpu/drm/radeon/r300.o
  CC [M]  fs/xfs/xfs_trans.o
  CC [M]  drivers/gpu/drm/radeon/r420.o
  CC      net/core/utils.o
  LD [M]  drivers/gpu/drm/radeon/radeon.o
  LD      drivers/gpu/drm/ttm/built-in.o
  CC [M]  drivers/gpu/drm/ttm/ttm_agp_backend.o
  CC [M]  fs/xfs/xfs_log.o
  CC      net/core/link_watch.o
  CC [M]  drivers/gpu/drm/ttm/ttm_memory.o
  CC      net/core/filter.o
  CC [M]  drivers/gpu/drm/ttm/ttm_tt.o
  CC [M]  fs/xfs/xfs_log_cil.o
  CC [M]  drivers/gpu/drm/ttm/ttm_bo.o
  CC      net/core/sock_diag.o
  CC [M]  fs/xfs/xfs_buf_item.o
  CC      net/core/net-sysfs.o
  CC [M]  drivers/gpu/drm/ttm/ttm_bo_util.o
  CC [M]  fs/xfs/xfs_extfree_item.o
  CC [M]  fs/xfs/xfs_inode_item.o
  CC [M]  drivers/gpu/drm/ttm/ttm_bo_vm.o
  CC      net/core/user_dma.o
  CC [M]  drivers/gpu/drm/ttm/ttm_module.o
  CC [M]  fs/xfs/xfs_trans_ail.o
  CC [M]  drivers/gpu/drm/ttm/ttm_object.o
  CC      net/core/fib_rules.o
  CC [M]  fs/xfs/xfs_trans_buf.o
  CC [M]  drivers/gpu/drm/ttm/ttm_lock.o
  CC      net/core/net-traces.o
  CC [M]  drivers/gpu/drm/ttm/ttm_execbuf_util.o
  CC [M]  fs/xfs/xfs_trans_extfree.o
  CC [M]  drivers/gpu/drm/ttm/ttm_page_alloc.o
  CC [M]  fs/xfs/xfs_trans_inode.o
  CC      net/core/drop_monitor.o
  CC [M]  fs/xfs/xfs_dquot.o
  CC [M]  drivers/gpu/drm/ttm/ttm_bo_manager.o
  CC      net/core/timestamping.o
  LD [M]  drivers/gpu/drm/ttm/ttm.o
  LD      drivers/gpu/drm/vmwgfx/built-in.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.o
  CC [M]  fs/xfs/xfs_dquot_item.o
  LD      net/core/built-in.o
  CC      net/dns_resolver/dns_key.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_gmr.o
  CC [M]  fs/xfs/xfs_trans_dquot.o
  CC      net/dns_resolver/dns_query.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_kms.o
  LD      net/dns_resolver/dns_resolver.o
  LD      net/dns_resolver/built-in.o
  CC      net/ethernet/eth.o
  CC [M]  fs/xfs/xfs_qm_syscalls.o
  LD      net/ethernet/built-in.o
  CC      net/ipv4/route.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_drv.o
  CC [M]  fs/xfs/xfs_qm_bhv.o
  CC [M]  fs/xfs/xfs_qm.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_fb.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.o
  CC [M]  fs/xfs/xfs_quotaops.o
  CC      net/ipv4/inetpeer.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_resource.o
  CC [M]  fs/xfs/xfs_qm_stats.o
  CC [M]  fs/xfs/xfs_rtalloc.o
  CC      net/ipv4/protocol.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_buffer.o
  CC      net/ipv4/ip_input.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_fifo.o
  CC [M]  fs/xfs/xfs_acl.o
  CC      net/ipv4/ip_fragment.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_irq.o
  CC [M]  fs/xfs/xfs_stats.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_ldu.o
  CC [M]  fs/xfs/xfs_sysctl.o
  CC      net/ipv4/ip_forward.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.o
  LD [M]  fs/xfs/xfs.o
  CC      fs/eventpoll.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_overlay.o
  CC      net/ipv4/ip_options.o
  CC      fs/anon_inodes.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_marker.o
  CC      fs/signalfd.o
  CC      net/ipv4/ip_output.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.o
  CC      fs/timerfd.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_fence.o
  CC      fs/eventfd.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.o
  CC      fs/aio.o
  CC      net/ipv4/ip_sockglue.o
  CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_scrn.o
  LD [M]  drivers/gpu/drm/vmwgfx/vmwgfx.o
  CC [M]  drivers/gpu/drm/drm_auth.o
  CC      fs/locks.o
  CC [M]  drivers/gpu/drm/drm_buffer.o
  CC      net/ipv4/inet_hashtables.o
  CC [M]  drivers/gpu/drm/drm_bufs.o
  CC      net/ipv4/inet_timewait_sock.o
  CC      fs/binfmt_misc.o
  CC [M]  drivers/gpu/drm/drm_cache.o
In file included from /var/tmp/linux-3.3/arch/x86/include/asm/uaccess.h:573:0,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:7,
                 from include/linux/pagemap.h:10,
                 from fs/binfmt_misc.c:26:
/var/tmp/linux-3.3/arch/x86/include/asm/uaccess_32.h: In function
‘parse_command.part.1’:
/var/tmp/linux-3.3/arch/x86/include/asm/uaccess_32.h:211:26: warning:
call to ‘copy_from_user_overflow’ declared with attribute warning:
copy_from_user() buffer size is not provably correct [enabled by
default]
  CC      net/ipv4/inet_connection_sock.o
  CC      fs/binfmt_script.o
  CC      fs/binfmt_elf.o
  CC [M]  drivers/gpu/drm/drm_context.o
  CC [M]  drivers/gpu/drm/drm_dma.o
  CC      net/ipv4/tcp.o
  CC      fs/posix_acl.o
  CC [M]  drivers/gpu/drm/drm_drv.o
  CC      fs/xattr_acl.o
  CC [M]  drivers/gpu/drm/drm_fops.o
  CC      fs/generic_acl.o
  CC      fs/dcookies.o
  CC [M]  drivers/gpu/drm/drm_gem.o
  CC      net/ipv4/tcp_input.o
  CC [M]  fs/mbcache.o
  CC [M]  drivers/gpu/drm/drm_ioctl.o
  LD      fs/built-in.o
  CC      lib/bcd.o
  CC [M]  drivers/gpu/drm/drm_irq.o
  CC      lib/div64.o
  CC      lib/sort.o
  CC      lib/parser.o
  CC [M]  drivers/gpu/drm/drm_lock.o
  CC      lib/halfmd4.o
  CC      lib/debug_locks.o
  CC [M]  drivers/gpu/drm/drm_memory.o
  CC      lib/random32.o
  CC      lib/bust_spinlocks.o
  CC      net/ipv4/tcp_output.o
  CC [M]  drivers/gpu/drm/drm_proc.o
  CC      lib/hexdump.o
  CC [M]  drivers/gpu/drm/drm_stub.o
  CC      lib/kasprintf.o
  CC      lib/bitmap.o
  CC [M]  drivers/gpu/drm/drm_vm.o
  CC      lib/scatterlist.o
  CC      net/ipv4/tcp_timer.o
  CC [M]  drivers/gpu/drm/drm_agpsupport.o
  CC      lib/string_helpers.o
  CC [M]  drivers/gpu/drm/drm_scatter.o
  CC      lib/gcd.o
  CC      net/ipv4/tcp_ipv4.o
  CC      lib/lcm.o
  CC [M]  drivers/gpu/drm/ati_pcigart.o
  CC      lib/list_sort.o
  CC      lib/uuid.o
  CC [M]  drivers/gpu/drm/drm_pci.o
  CC      lib/flex_array.o
  CC      lib/bsearch.o
  CC [M]  drivers/gpu/drm/drm_platform.o
  CC      net/ipv4/tcp_minisocks.o
  CC      lib/find_last_bit.o
  CC [M]  drivers/gpu/drm/drm_sysfs.o
  CC      lib/find_next_bit.o
  CC      lib/llist.o
  CC      net/ipv4/tcp_cong.o
  CC [M]  drivers/gpu/drm/drm_hashtab.o
  CC      lib/kstrtox.o
  CC      lib/iomap.o
  CC [M]  drivers/gpu/drm/drm_mm.o
  CC      net/ipv4/datagram.o
  CC      lib/pci_iomap.o
  CC      lib/iomap_copy.o
  CC [M]  drivers/gpu/drm/drm_crtc.o
  CC      net/ipv4/raw.o
  CC      lib/devres.o
  CC      lib/hweight.o
  CC      net/ipv4/udp.o
  CC      lib/btree.o
  CC [M]  drivers/gpu/drm/drm_modes.o
  CC      lib/bitrev.o
  HOSTCC  lib/gen_crc32table
  CC      lib/genalloc.o
  CC [M]  drivers/gpu/drm/drm_edid.o
  CC      lib/lzo/lzo1x_compress.o
  CC      net/ipv4/udplite.o
  CC      lib/lzo/lzo1x_decompress.o
  LD      lib/lzo/lzo_compress.o
  LD      lib/lzo/lzo_decompress.o
  LD      lib/lzo/built-in.o
  CC      lib/xz/xz_dec_syms.o
  CC [M]  drivers/gpu/drm/drm_info.o
  CC      net/ipv4/arp.o
  CC      lib/xz/xz_dec_stream.o
  CC [M]  drivers/gpu/drm/drm_debugfs.o
  CC      lib/xz/xz_dec_lzma2.o
  CC [M]  drivers/gpu/drm/drm_encoder_slave.o
  CC      net/ipv4/icmp.o
  CC      lib/xz/xz_dec_bcj.o
  LD      lib/xz/xz_dec.o
  LD      lib/xz/built-in.o
  LD      lib/zlib_deflate/built-in.o
  CC [M]  lib/zlib_deflate/deflate.o
  CC [M]  drivers/gpu/drm/drm_trace_points.o
  CC [M]  lib/zlib_deflate/deftree.o
  CC [M]  drivers/gpu/drm/drm_global.o
  CC      net/ipv4/devinet.o
  CC [M]  drivers/gpu/drm/drm_usb.o
  CC [M]  lib/zlib_deflate/deflate_syms.o
  CC [M]  drivers/gpu/drm/drm_fb_helper.o
  LD [M]  lib/zlib_deflate/zlib_deflate.o
  CC      lib/zlib_inflate/inffast.o
  CC      lib/zlib_inflate/inflate.o
  CC      net/ipv4/af_inet.o
  CC      lib/zlib_inflate/infutil.o
  CC [M]  drivers/gpu/drm/drm_crtc_helper.o
  CC      lib/zlib_inflate/inftrees.o
  CC      lib/zlib_inflate/inflate_syms.o
  LD      lib/zlib_inflate/zlib_inflate.o
  LD      lib/zlib_inflate/built-in.o
  CC      lib/percpu_counter.o
  CC      net/ipv4/igmp.o
  CC [M]  drivers/gpu/drm/drm_dp_i2c_helper.o
  CC      lib/audit.o
  CC      lib/syscall.o
  LD      drivers/gpu/drm/built-in.o
  LD [M]  drivers/gpu/drm/drm_kms_helper.o
  CC      lib/nlattr.o
  LD [M]  drivers/gpu/drm/drm.o
  LD      drivers/gpu/stub/built-in.o
  CC      drivers/gpu/vga/vgaarb.o
  CC      lib/average.o
  CC      net/ipv4/fib_frontend.o
  CC      drivers/gpu/vga/vga_switcheroo.o
  CC      lib/cpu_rmap.o
  CC      lib/dynamic_queue_limits.o
  LD      drivers/gpu/vga/built-in.o
  LD      drivers/gpu/built-in.o
  LD      drivers/hid/built-in.o
  CC [M]  drivers/hid/hid-lg.o
  CC      lib/argv_split.o
  CC      net/ipv4/fib_semantics.o
  CC      lib/bug.o
  CC [M]  drivers/hid/hid-lgff.o
  CC      lib/cmdline.o
  CC [M]  drivers/hid/hid-lg2ff.o
  CC      lib/cpumask.o
  CC      net/ipv4/fib_trie.o
  CC [M]  drivers/hid/hid-lg3ff.o
  CC      lib/ctype.o
  CC [M]  drivers/hid/hid-lg4ff.o
  CC      lib/dec_and_lock.o
  CC      lib/decompress.o
  CC      lib/decompress_bunzip2.o
  CC [M]  drivers/hid/hid-debug.o
  CC      lib/decompress_inflate.o
  CC      net/ipv4/inet_fragment.o
  CC [M]  drivers/hid/hid-core.o
  CC      lib/decompress_unlzma.o
  CC      lib/decompress_unlzo.o
  CC      net/ipv4/ping.o
  CC      lib/decompress_unxz.o
  CC [M]  drivers/hid/hid-input.o
  CC      lib/dump_stack.o
  CC      lib/extable.o
  CC      net/ipv4/sysctl_net_ipv4.o
  CC      lib/idr.o
  CC      lib/int_sqrt.o
  CC      net/ipv4/proc.o
  CC [M]  drivers/hid/hidraw.o
  CC      lib/ioremap.o
  CC      lib/irq_regs.o
  CC [M]  drivers/hid/hid-a4tech.o
  CC      net/ipv4/fib_rules.o
  CC      lib/is_single_threaded.o
  CC      lib/klist.o
  CC [M]  drivers/hid/hid-apple.o
  CC      net/ipv4/ipmr.o
  CC      lib/kobject.o
  CC [M]  drivers/hid/hid-belkin.o
  CC [M]  drivers/hid/hid-cherry.o
  CC      lib/kobject_uevent.o
  CC [M]  drivers/hid/hid-chicony.o
  CC [M]  drivers/hid/hid-cypress.o
  CC      net/ipv4/syncookies.o
  CC [M]  drivers/hid/hid-ezkey.o
  CC      lib/md5.o
  CC [M]  drivers/hid/hid-kensington.o
  CC      lib/plist.o
  CC      lib/prio_heap.o
  CC [M]  drivers/hid/hid-kye.o
  CC      net/ipv4/inet_lro.o
  CC      lib/prio_tree.o
  LD [M]  drivers/hid/hid-logitech.o
  CC [M]  drivers/hid/hid-microsoft.o
  CC      lib/proportions.o
  CC [M]  drivers/hid/hid-monterey.o
  CC      lib/radix-tree.o
  CC [M]  drivers/hid/hid-prodikeys.o
  CC      net/ipv4/netfilter.o
  LD      drivers/hid/usbhid/built-in.o
  CC [M]  drivers/hid/usbhid/hid-core.o
  CC      lib/ratelimit.o
  LD      net/ipv4/netfilter/built-in.o
  CC [M]  net/ipv4/netfilter/nf_nat_rule.o
  CC      lib/rbtree.o
  CC [M]  net/ipv4/netfilter/nf_nat_standalone.o
  CC      lib/reciprocal_div.o
  CC      lib/rwsem.o
  CC [M]  drivers/hid/usbhid/hid-quirks.o
  CC [M]  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.o
  CC      lib/sha1.o
  CC [M]  drivers/hid/usbhid/hiddev.o
  CC      lib/show_mem.o
  CC [M]  net/ipv4/netfilter/nf_conntrack_proto_icmp.o
  CC [M]  drivers/hid/usbhid/hid-pidff.o
  CC      lib/string.o
  CC [M]  net/ipv4/netfilter/nf_nat_core.o
  CC      lib/timerqueue.o
  LD [M]  drivers/hid/usbhid/usbhid.o
  LD [M]  drivers/hid/hid.o
  CC      drivers/hwmon/hwmon.o
  CC      lib/vsprintf.o
  CC [M]  drivers/hwmon/hwmon-vid.o
  CC [M]  net/ipv4/netfilter/nf_nat_helper.o
  CC [M]  drivers/hwmon/asb100.o
  CC [M]  drivers/hwmon/w83627hf.o
  CC [M]  lib/crc-ccitt.o
  CC [M]  net/ipv4/netfilter/nf_nat_proto_unknown.o
  CC [M]  lib/crc16.o
  CC [M]  lib/crc-itu-t.o
  CC [M]  net/ipv4/netfilter/nf_nat_proto_common.o
  CC [M]  drivers/hwmon/w83793.o
  CC [M]  lib/libcrc32c.o
  CC [M]  net/ipv4/netfilter/nf_nat_proto_tcp.o
  GEN     lib/crc32table.h
  AR      lib/lib.a
  CC      lib/crc32.o
  LD      lib/built-in.o
  CC      arch/x86/lib/msr-smp.o
  CC [M]  net/ipv4/netfilter/nf_nat_proto_udp.o
  CC [M]  drivers/hwmon/w83781d.o
  CC      arch/x86/lib/cache-smp.o
  CC [M]  net/ipv4/netfilter/nf_nat_proto_icmp.o
  CC      arch/x86/lib/msr.o
  CC [M]  net/ipv4/netfilter/nf_defrag_ipv4.o
  AS      arch/x86/lib/msr-reg.o
  CC [M]  drivers/hwmon/w83791d.o
  CC      arch/x86/lib/msr-reg-export.o
  CC      arch/x86/lib/atomic64_32.o
  AS      arch/x86/lib/atomic64_386_32.o
  CC [M]  net/ipv4/netfilter/ip_tables.o
  CC [M]  drivers/hwmon/adm1025.o
  AS      arch/x86/lib/atomic64_cx8_32.o
  AS      arch/x86/lib/checksum_32.o
  CC      arch/x86/lib/cmpxchg.o
  AS      arch/x86/lib/cmpxchg8b_emu.o
  CC      arch/x86/lib/delay.o
  CC [M]  drivers/hwmon/adm1026.o
  AS      arch/x86/lib/getuser.o
  GEN     arch/x86/lib/inat-tables.c
  CC      arch/x86/lib/insn.o
  CC [M]  net/ipv4/netfilter/iptable_filter.o
  CC      arch/x86/lib/memcpy_32.o
  CC [M]  drivers/hwmon/adm9240.o
  CC      arch/x86/lib/mmx_32.o
  CC [M]  net/ipv4/netfilter/iptable_mangle.o
  CC [M]  drivers/hwmon/adt7475.o
  AS      arch/x86/lib/putuser.o
  AS      arch/x86/lib/rwlock.o
  AS      arch/x86/lib/rwsem.o
  CC      arch/x86/lib/string_32.o
  LD [M]  net/ipv4/netfilter/iptable_nat.o
  CC [M]  net/ipv4/netfilter/ipt_MASQUERADE.o
  CC      arch/x86/lib/strstr_32.o
  AS      arch/x86/lib/thunk_32.o
  CC      arch/x86/lib/usercopy.o
  CC [M]  drivers/hwmon/atxp1.o
  CC [M]  net/ipv4/netfilter/ipt_REJECT.o
  CC      arch/x86/lib/usercopy_32.o
  CC [M]  drivers/hwmon/dme1737.o
  LD [M]  net/ipv4/netfilter/nf_conntrack_ipv4.o
  LD [M]  net/ipv4/netfilter/nf_nat.o
  CC      net/ipv4/inet_diag.o
  LD      arch/x86/lib/built-in.o
  CC      arch/x86/lib/inat.o
  AR      arch/x86/lib/lib.a
  CC      net/ipv6/af_inet6.o
  CC [M]  drivers/hwmon/gl520sm.o
  CC      net/ipv4/tcp_diag.o
  CC [M]  drivers/hwmon/it87.o
  CC      net/ipv6/anycast.o
  CC      net/ipv4/tcp_cubic.o
  CC      net/ipv6/ip6_output.o
  CC      net/ipv4/tcp_memcontrol.o
  CC [M]  drivers/hwmon/lm78.o
  CC      net/ipv4/cipso_ipv4.o
  CC [M]  drivers/hwmon/lm85.o
  CC      net/ipv6/ip6_input.o
  CC [M]  drivers/hwmon/lm87.o
  LD      net/ipv4/built-in.o
  CC      net/netfilter/core.o
  CC      net/ipv6/addrconf.o
  CC [M]  drivers/hwmon/lm93.o
  CC      net/netfilter/nf_log.o
  CC      net/netfilter/nf_queue.o
  CC [M]  drivers/hwmon/pc87360.o
  CC      net/ipv6/addrlabel.o
  CC      net/netfilter/nf_sockopt.o
  CC [M]  drivers/hwmon/smsc47m192.o
  CC      net/ipv6/route.o
  CC [M]  drivers/hwmon/via-cputemp.o
  CC [M]  net/netfilter/nf_conntrack_core.o
  CC [M]  drivers/hwmon/vt1211.o
  CC [M]  drivers/hwmon/vt8231.o
  CC [M]  net/netfilter/nf_conntrack_standalone.o
  CC [M]  drivers/hwmon/w83627ehf.o
  CC      net/ipv6/ip6_fib.o
  CC [M]  net/netfilter/nf_conntrack_expect.o
  CC      net/ipv6/ipv6_sockglue.o
  CC [M]  net/netfilter/nf_conntrack_helper.o
  LD      drivers/hwmon/built-in.o
  CC      drivers/i2c/i2c-boardinfo.o
  LD      drivers/i2c/algos/built-in.o
  CC [M]  drivers/i2c/algos/i2c-algo-bit.o
  CC [M]  net/netfilter/nf_conntrack_proto.o
  CC      net/ipv6/ndisc.o
  LD      drivers/i2c/busses/built-in.o
  CC [M]  drivers/i2c/busses/i2c-amd756.o
  CC [M]  net/netfilter/nf_conntrack_l3proto_generic.o
  LD      drivers/i2c/muxes/built-in.o
  CC [M]  drivers/i2c/i2c-core.o
  CC [M]  net/netfilter/nf_conntrack_proto_generic.o
  CC      net/ipv6/udp.o
  CC [M]  net/netfilter/nf_conntrack_proto_tcp.o
  LD      drivers/i2c/built-in.o
  CC      drivers/idle/intel_idle.o
  LD      drivers/idle/built-in.o
  LD      drivers/ieee802154/built-in.o
  CC      drivers/input/input.o
  CC [M]  net/netfilter/nf_conntrack_proto_udp.o
  CC      net/ipv6/udplite.o
  CC [M]  net/netfilter/nf_conntrack_extend.o
  CC      net/ipv6/raw.o
  CC      drivers/input/input-compat.o
  CC      drivers/input/input-mt.o
  CC [M]  net/netfilter/nf_conntrack_acct.o
  CC      drivers/input/ff-core.o
  CC      net/ipv6/protocol.o
  CC [M]  net/netfilter/nf_conntrack_timestamp.o
  CC      drivers/input/mousedev.o
  CC [M]  net/netfilter/nf_conntrack_ecache.o
  CC      net/ipv6/icmp.o
  LD      drivers/input/joystick/built-in.o
  CC      drivers/input/keyboard/atkbd.o
  CC [M]  net/netfilter/nf_tproxy_core.o
  CC      net/ipv6/mcast.o
  LD      drivers/input/keyboard/built-in.o
  LD      drivers/input/misc/built-in.o
  CC [M]  drivers/input/misc/pcspkr.o
  CC [M]  net/netfilter/x_tables.o
  CC      drivers/input/mouse/sermouse.o
  CC [M]  drivers/input/mouse/psmouse-base.o
  CC [M]  net/netfilter/xt_tcpudp.o
  CC      net/ipv6/reassembly.o
  CC [M]  drivers/input/mouse/synaptics.o
  CC [M]  net/netfilter/xt_mark.o
  CC [M]  drivers/input/mouse/alps.o
  CC      net/ipv6/tcp_ipv6.o
  CC [M]  net/netfilter/xt_TPROXY.o
  CC [M]  drivers/input/mouse/elantech.o
  CC [M]  net/netfilter/xt_conntrack.o
  CC [M]  net/netfilter/xt_dscp.o
  CC [M]  drivers/input/mouse/hgpk.o
  CC      net/ipv6/exthdrs.o
  CC [M]  net/netfilter/xt_multiport.o
  CC [M]  drivers/input/mouse/logips2pp.o
  CC      net/ipv6/datagram.o
  CC [M]  drivers/input/mouse/lifebook.o
  CC [M]  net/netfilter/xt_recent.o
  CC [M]  drivers/input/mouse/sentelic.o
  CC      net/ipv6/ip6_flowlabel.o
  CC [M]  net/netfilter/xt_socket.o
  CC [M]  drivers/input/mouse/trackpoint.o
  LD      drivers/input/mouse/built-in.o
  LD [M]  drivers/input/mouse/psmouse.o
  LD      drivers/input/tablet/built-in.o
  LD      drivers/input/touchscreen/built-in.o
  CC [M]  drivers/input/ff-memless.o
  LD      net/netfilter/netfilter.o
  LD [M]  net/netfilter/nf_conntrack.o
  LD      net/netfilter/built-in.o
  CC      net/netlabel/netlabel_user.o
  CC      net/ipv6/inet6_connection_sock.o
  CC [M]  drivers/input/evdev.o
  CC      net/netlabel/netlabel_kapi.o
  CC      net/ipv6/sysctl_net_ipv6.o
  LD      drivers/input/input-core.o
  LD      drivers/input/built-in.o
  LD      drivers/input/gameport/built-in.o
  CC [M]  drivers/input/gameport/gameport.o
  CC      net/netlabel/netlabel_domainhash.o
  CC      net/ipv6/netfilter.o
  CC      drivers/input/serio/serio.o
  CC      net/netlabel/netlabel_addrlist.o
  CC      net/ipv6/fib6_rules.o
  CC      drivers/input/serio/i8042.o
  CC      net/netlabel/netlabel_mgmt.o
  CC      net/ipv6/proc.o
  CC      net/netlabel/netlabel_unlabeled.o
  CC      drivers/input/serio/libps2.o
  CC      net/ipv6/syncookies.o
  CC [M]  drivers/input/serio/serio_raw.o
  CC      net/netlabel/netlabel_cipso_v4.o
  LD      net/ipv6/netfilter/built-in.o
  CC      net/ipv6/addrconf_core.o
  LD      drivers/input/serio/built-in.o
  CC      drivers/iommu/iommu.o
  CC      drivers/iommu/dmar.o
  LD      net/netlabel/built-in.o
  CC      net/netlink/af_netlink.o
  CC      net/ipv6/exthdrs_core.o
  CC      net/ipv6/inet6_hashtables.o
  CC      drivers/iommu/iova.o
  CC      drivers/iommu/intel-iommu.o
  CC      net/netlink/genetlink.o
  LD      net/ipv6/ipv6.o
  LD      net/ipv6/built-in.o
  CC      net/packet/af_packet.o
  LD      net/netlink/built-in.o
  LD      net/rfkill/built-in.o
  CC [M]  net/rfkill/core.o
  LD      drivers/iommu/built-in.o
  LD      drivers/isdn/hardware/built-in.o
  LD      drivers/isdn/built-in.o
  CC      drivers/leds/led-core.o
  CC [M]  net/rfkill/input.o
  LD      net/packet/built-in.o
  CC      net/sched/sch_generic.o
  CC      drivers/leds/led-class.o
  LD [M]  net/rfkill/rfkill.o
  LD      net/sctp/built-in.o
  CC [M]  net/sctp/sm_statetable.o
  CC      drivers/leds/led-triggers.o
  LD      drivers/leds/built-in.o
  CC      drivers/lguest/lguest_device.o
  CC [M]  net/sctp/sm_statefuns.o
  CC      net/sched/sch_mq.o
  LD      drivers/lguest/built-in.o
  CC      drivers/macintosh/mac_hid.o
  CC      net/sched/sch_api.o
  LD      drivers/macintosh/built-in.o
  LD      drivers/md/built-in.o
  CC [M]  drivers/md/dm-uevent.o
  CC [M]  drivers/md/dm.o
  CC [M]  net/sctp/sm_sideeffect.o
  CC      net/sched/sch_blackhole.o
  CC      net/sched/cls_api.o
  CC [M]  drivers/md/dm-table.o
  CC [M]  net/sctp/protocol.o
  CC      net/sched/act_api.o
  CC [M]  drivers/md/dm-target.o
  CC [M]  net/sctp/endpointola.o
  CC [M]  drivers/md/dm-linear.o
  CC [M]  net/sctp/associola.o
  CC      net/sched/sch_fifo.o
  CC [M]  drivers/md/dm-stripe.o
  CC      net/sched/cls_cgroup.o
  CC [M]  net/sctp/transport.o
  CC [M]  drivers/md/dm-ioctl.o
  LD      net/sched/built-in.o
  LD      net/sunrpc/built-in.o
  CC [M]  net/sunrpc/clnt.o
  CC [M]  net/sctp/chunk.o
  CC [M]  drivers/md/dm-io.o
  CC [M]  net/sctp/sm_make_chunk.o
  CC [M]  drivers/md/dm-kcopyd.o
  CC [M]  net/sunrpc/xprt.o
  CC [M]  drivers/md/dm-sysfs.o
  LD [M]  drivers/md/dm-mod.o
  LD      drivers/media/common/tuners/built-in.o
  CC [M]  drivers/media/common/tuners/tuner-xc2028.o
  CC [M]  net/sctp/ulpevent.o
  CC [M]  net/sunrpc/socklib.o
  CC [M]  net/sctp/inqueue.o
  CC [M]  net/sunrpc/xprtsock.o
  CC [M]  drivers/media/common/tuners/tuner-simple.o
  CC [M]  net/sctp/outqueue.o
  CC [M]  drivers/media/common/tuners/tuner-types.o
  CC [M]  net/sunrpc/sched.o
  CC [M]  net/sctp/ulpqueue.o
  CC [M]  drivers/media/common/tuners/mt20xx.o
  CC [M]  net/sctp/command.o
  CC [M]  net/sunrpc/auth.o
  CC [M]  drivers/media/common/tuners/tda8290.o
  CC [M]  net/sctp/tsnmap.o
  CC [M]  net/sunrpc/auth_null.o
  CC [M]  net/sctp/bind_addr.o
  CC [M]  drivers/media/common/tuners/tea5767.o
  CC [M]  net/sunrpc/auth_unix.o
  CC [M]  net/sctp/socket.o
  CC [M]  drivers/media/common/tuners/tea5761.o
  CC [M]  net/sunrpc/auth_generic.o
  CC [M]  drivers/media/common/tuners/tda9887.o
  CC [M]  net/sunrpc/svc.o
  CC [M]  drivers/media/common/tuners/tda827x.o
  CC [M]  net/sctp/primitive.o
  CC [M]  drivers/media/common/tuners/tda18271-maps.o
  CC [M]  net/sunrpc/svcsock.o
  CC [M]  drivers/media/common/tuners/tda18271-common.o
  CC [M]  net/sctp/output.o
  CC [M]  drivers/media/common/tuners/tda18271-fe.o
  CC [M]  net/sctp/input.o
  CC [M]  net/sunrpc/svcauth.o
  CC [M]  net/sunrpc/svcauth_unix.o
  CC [M]  net/sctp/debug.o
  CC [M]  drivers/media/common/tuners/xc5000.o
  CC [M]  net/sctp/ssnmap.o
  CC [M]  net/sunrpc/addr.o
  CC [M]  drivers/media/common/tuners/xc4000.o
  CC [M]  net/sctp/auth.o
  CC [M]  net/sunrpc/rpcb_clnt.o
  CC [M]  net/sctp/proc.o
  CC [M]  drivers/media/common/tuners/mt2131.o
  CC [M]  net/sunrpc/timer.o
  CC [M]  drivers/media/common/tuners/mxl5005s.o
  CC [M]  net/sctp/sysctl.o
  CC [M]  net/sunrpc/xdr.o
  CC [M]  net/sctp/ipv6.o
  LD [M]  net/sctp/sctp.o
  CC      net/unix/af_unix.o
  CC [M]  net/sunrpc/sunrpc_syms.o
  CC [M]  net/sunrpc/cache.o
  CC      net/unix/garbage.o
  CC [M]  drivers/media/common/tuners/mxl5007t.o
  CC [M]  net/sunrpc/rpc_pipe.o
  CC      net/unix/sysctl_net_unix.o
  CC [M]  drivers/media/common/tuners/mc44s803.o
  LD      net/unix/unix.o
  LD      net/unix/built-in.o
  LD      net/wireless/built-in.o
  CC      net/sysctl_net.o
  LD [M]  drivers/media/common/tuners/tda18271.o
  LD      drivers/media/common/built-in.o
  CC [M]  net/sunrpc/svc_xprt.o
  LD      drivers/media/dvb/b2c2/built-in.o
  LD      drivers/media/dvb/bt8xx/built-in.o
  CC [M]  drivers/media/dvb/bt8xx/bt878.o
  LD      drivers/message/fusion/built-in.o
  LD      drivers/message/built-in.o
  CC      drivers/mfd/stmpe.o
  CC [M]  drivers/media/dvb/bt8xx/dvb-bt8xx.o
  CC      drivers/mfd/stmpe-spi.o
  CC [M]  net/sunrpc/stats.o
  CC      drivers/mfd/tps65912-core.o
  CC [M]  drivers/media/dvb/bt8xx/dst.o
  CC      drivers/mfd/tps65912-irq.o
  CC [M]  net/sunrpc/sysctl.o
  CC      drivers/mfd/wm831x-core.o
  LD      net/sunrpc/auth_gss/built-in.o
  CC [M]  net/sunrpc/auth_gss/auth_gss.o
  CC      drivers/mfd/wm831x-irq.o
  CC [M]  drivers/media/dvb/bt8xx/dst_ca.o
  CC      drivers/mfd/wm831x-otp.o
  CC      drivers/mfd/wm831x-auxadc.o
  CC [M]  net/sunrpc/auth_gss/gss_generic_token.o
  LD      drivers/media/dvb/ddbridge/built-in.o
  LD      drivers/media/dvb/dm1105/built-in.o
  LD      drivers/media/dvb/dvb-core/built-in.o
  CC      drivers/mfd/wm831x-spi.o
  CC [M]  drivers/media/dvb/dvb-core/dvbdev.o
  CC [M]  net/sunrpc/auth_gss/gss_mech_switch.o
  LD      drivers/mfd/tps65912.o
  CC      drivers/mfd/tps65912-spi.o
  CC [M]  drivers/media/dvb/dvb-core/dmxdev.o
  CC      drivers/mfd/mfd-core.o
  CC [M]  net/sunrpc/auth_gss/svcauth_gss.o
  CC      drivers/mfd/ezx-pcap.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_demux.o
  CC      drivers/mfd/da9052-core.o
  LD [M]  net/sunrpc/auth_gss/auth_rpcgss.o
  LD [M]  net/sunrpc/sunrpc.o
  LD      net/built-in.o
  CC      drivers/mfd/da9052-spi.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_filter.o
  LD      drivers/media/radio/si470x/built-in.o
  LD      drivers/media/radio/built-in.o
  LD      drivers/media/rc/keymaps/built-in.o
  CC [M]  drivers/media/rc/rc-main.o
  CC      drivers/mfd/abx500-core.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_ca_en50221.o
  CC      drivers/mfd/ab8500-core.o
  CC [M]  drivers/media/rc/ir-raw.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_frontend.o
  CC      drivers/mfd/ab8500-sysctrl.o
  CC [M]  drivers/media/rc/lirc_dev.o
  CC      drivers/mfd/ab8500-gpadc.o
  CC [M]  drivers/mfd/timberdale.o
  LD      drivers/media/rc/built-in.o
  LD [M]  drivers/media/rc/rc-core.o
  LD      drivers/media/video/au0828/built-in.o
  CC [M]  drivers/media/video/au0828/au0828-core.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_net.o
  LD      drivers/mfd/wm831x.o
  LD      drivers/mfd/built-in.o
  LD      drivers/misc/carma/built-in.o
  LD      drivers/misc/cb710/built-in.o
  LD      drivers/misc/eeprom/built-in.o
  CC [M]  drivers/misc/eeprom/eeprom_93cx6.o
  CC [M]  drivers/media/video/au0828/au0828-i2c.o
  LD      drivers/misc/lis3lv02d/built-in.o
  LD      drivers/misc/ti-st/built-in.o
  LD      drivers/misc/built-in.o
  LD      drivers/mmc/built-in.o
  LD      drivers/mtd/chips/built-in.o
  CC [M]  drivers/mtd/chips/chipreg.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_ringbuffer.o
  CC [M]  drivers/media/video/au0828/au0828-cards.o
  LD      drivers/mtd/devices/built-in.o
  LD      drivers/mtd/lpddr/built-in.o
  LD      drivers/mtd/maps/built-in.o
  CC [M]  drivers/mtd/maps/map_funcs.o
  CC [M]  drivers/media/dvb/dvb-core/dvb_math.o
  CC [M]  drivers/media/video/au0828/au0828-dvb.o
  LD      drivers/mtd/nand/built-in.o
  LD      drivers/mtd/onenand/built-in.o
  LD      drivers/mtd/tests/built-in.o
  CC [M]  drivers/mtd/mtdcore.o
  LD [M]  drivers/media/dvb/dvb-core/dvb-core.o
  LD      drivers/media/dvb/dvb-usb/built-in.o
  LD      drivers/media/dvb/frontends/built-in.o
  CC [M]  drivers/media/dvb/frontends/cx24110.o
drivers/mtd/mtdcore.c: In function ‘mtd_release’:
drivers/mtd/mtdcore.c:110:19: warning: unused variable ‘mtd’ [-Wunused-variable]
  CC [M]  drivers/media/video/au0828/au0828-video.o
  CC [M]  drivers/mtd/mtdsuper.o
  CC [M]  drivers/media/dvb/frontends/dib7000p.o
  CC [M]  drivers/mtd/mtdconcat.o
  CC [M]  drivers/media/video/au0828/au0828-vbi.o
  CC [M]  drivers/mtd/mtdpart.o
  CC [M]  drivers/media/dvb/frontends/dibx000_common.o
  LD [M]  drivers/media/video/au0828/au0828.o
  LD      drivers/media/video/bt8xx/built-in.o
  CC [M]  drivers/media/video/bt8xx/bttv-driver.o
  LD      drivers/mtd/built-in.o
  LD [M]  drivers/mtd/mtd.o
  CC      drivers/net/Space.o
  CC [M]  drivers/media/dvb/frontends/tda1004x.o
  CC      drivers/net/loopback.o
  CC [M]  drivers/media/dvb/frontends/sp887x.o
  LD      drivers/net/ethernet/3com/built-in.o
  CC [M]  drivers/net/ethernet/3com/3c59x.o
  CC [M]  drivers/media/video/bt8xx/bttv-cards.o
  CC [M]  drivers/media/dvb/frontends/nxt6000.o
  CC [M]  drivers/media/video/bt8xx/bttv-if.o
  CC [M]  drivers/media/dvb/frontends/mt352.o
  LD      drivers/net/ethernet/8390/built-in.o
  LD      drivers/net/ethernet/adaptec/built-in.o
  CC [M]  drivers/net/ethernet/adaptec/starfire.o
  CC [M]  drivers/media/video/bt8xx/bttv-risc.o
  CC [M]  drivers/media/dvb/frontends/zl10353.o
  CC [M]  drivers/media/video/bt8xx/bttv-vbi.o
  CC [M]  drivers/media/dvb/frontends/or51211.o
  LD      drivers/net/ethernet/alteon/built-in.o
  LD      drivers/net/ethernet/amd/built-in.o
  CC [M]  drivers/net/ethernet/amd/amd8111e.o
  CC [M]  drivers/media/video/bt8xx/bttv-i2c.o
  CC [M]  drivers/media/dvb/frontends/lgdt330x.o
  CC [M]  drivers/media/video/bt8xx/bttv-gpio.o
  CC [M]  drivers/net/ethernet/amd/pcnet32.o
  CC [M]  drivers/media/dvb/frontends/lnbp21.o
  CC [M]  drivers/media/video/bt8xx/bttv-input.o
  CC [M]  drivers/media/dvb/frontends/s5h1409.o
  CC [M]  drivers/media/video/bt8xx/bttv-audio-hook.o
  LD [M]  drivers/media/video/bt8xx/bttv.o
  LD      drivers/media/video/cx18/built-in.o
  CC [M]  drivers/media/video/cx18/cx18-alsa-main.o
  CC [M]  drivers/media/dvb/frontends/au8522_dig.o
  LD      drivers/net/ethernet/atheros/built-in.o
  LD      drivers/net/ethernet/atheros/atl1c/built-in.o
  CC [M]  drivers/net/ethernet/atheros/atl1c/atl1c_main.o
  CC [M]  drivers/media/video/cx18/cx18-alsa-pcm.o
  CC [M]  drivers/media/dvb/frontends/au8522_decoder.o
  CC [M]  drivers/media/dvb/frontends/stv0900_core.o
  CC [M]  drivers/media/video/cx18/cx18-driver.o
drivers/media/video/cx18/cx18-driver.c: In function ‘__check_radio’:
drivers/media/video/cx18/cx18-driver.c:113:1: warning: return from
incompatible pointer type [enabled by default]
drivers/media/video/cx18/cx18-driver.c: At top level:
drivers/media/video/cx18/cx18-driver.c:113:1: warning: initialization
from incompatible pointer type [enabled by default]
drivers/media/video/cx18/cx18-driver.c:113:1: warning: (near
initialization for ‘__param_arr_radio.num’) [enabled by default]
  CC [M]  drivers/net/ethernet/atheros/atl1c/atl1c_hw.o
  CC [M]  drivers/media/video/cx18/cx18-cards.o
  CC [M]  drivers/media/dvb/frontends/stv0900_sw.o
  CC [M]  drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.o
  CC [M]  drivers/media/video/cx18/cx18-i2c.o
  LD [M]  drivers/net/ethernet/atheros/atl1c/atl1c.o
  LD      drivers/net/ethernet/atheros/atl1e/built-in.o
  CC [M]  drivers/net/ethernet/atheros/atl1e/atl1e_main.o
  CC [M]  drivers/media/video/cx18/cx18-firmware.o
  CC [M]  drivers/media/dvb/frontends/tda10048.o
  CC [M]  drivers/media/video/cx18/cx18-gpio.o
  CC [M]  drivers/net/ethernet/atheros/atl1e/atl1e_hw.o
  CC [M]  drivers/media/dvb/frontends/s5h1411.o
  CC [M]  drivers/media/video/cx18/cx18-queue.o
  CC [M]  drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.o
  CC [M]  drivers/media/dvb/frontends/cx24116.o
  CC [M]  drivers/media/video/cx18/cx18-streams.o
  CC [M]  drivers/net/ethernet/atheros/atl1e/atl1e_param.o
  CC [M]  drivers/media/dvb/frontends/stv6110.o
  LD [M]  drivers/net/ethernet/atheros/atl1e/atl1e.o
  LD      drivers/net/ethernet/atheros/atlx/built-in.o
  CC [M]  drivers/net/ethernet/atheros/atlx/atl1.o
  CC [M]  drivers/media/video/cx18/cx18-fileops.o
  LD [M]  drivers/media/dvb/frontends/stv0900.o
  CC [M]  drivers/media/dvb/frontends/ds3000.o
  CC [M]  drivers/media/video/cx18/cx18-ioctl.o
  CC [M]  drivers/media/dvb/frontends/stv0367.o
  CC [M]  drivers/net/ethernet/atheros/atlx/atl2.o
  CC [M]  drivers/media/video/cx18/cx18-controls.o
  LD [M]  drivers/media/dvb/frontends/au8522.o
  LD      drivers/media/dvb/mantis/built-in.o
  LD      drivers/media/dvb/ngene/built-in.o
  LD      drivers/media/dvb/pluto2/built-in.o
  CC [M]  drivers/media/dvb/pluto2/pluto2.o
  CC [M]  drivers/media/video/cx18/cx18-mailbox.o
  LD      drivers/net/ethernet/broadcom/built-in.o
  CC [M]  drivers/net/ethernet/broadcom/b44.o
  LD      drivers/media/dvb/pt1/built-in.o
  LD      drivers/media/dvb/siano/built-in.o
  LD      drivers/media/dvb/ttpci/built-in.o
  LD      drivers/media/dvb/ttusb-budget/built-in.o
  LD      drivers/media/dvb/ttusb-dec/built-in.o
  LD      drivers/media/dvb/built-in.o
  CC [M]  drivers/media/media-device.o
  CC [M]  drivers/media/video/cx18/cx18-vbi.o
  CC [M]  drivers/media/media-devnode.o
  CC [M]  drivers/media/video/cx18/cx18-audio.o
  CC [M]  drivers/media/media-entity.o
  CC [M]  drivers/net/ethernet/broadcom/bnx2.o
  CC [M]  drivers/media/video/cx18/cx18-video.o
  LD [M]  drivers/media/media.o
  LD      drivers/media/video/cx231xx/built-in.o
  CC [M]  drivers/media/video/cx231xx/cx231xx-audio.o
  CC [M]  drivers/media/video/cx18/cx18-irq.o
  CC [M]  drivers/media/video/cx18/cx18-av-core.o
  CC [M]  drivers/media/video/cx231xx/cx231xx-video.o
  CC [M]  drivers/media/video/cx18/cx18-av-audio.o
  CC [M]  drivers/media/video/cx231xx/cx231xx-i2c.o
  CC [M]  drivers/media/video/cx18/cx18-av-firmware.o
  CC [M]  drivers/media/video/cx231xx/cx231xx-cards.o
  CC [M]  drivers/media/video/cx18/cx18-av-vbi.o
  CC [M]  drivers/net/ethernet/broadcom/cnic.o
  CC [M]  drivers/media/video/cx18/cx18-scb.o
  CC [M]  drivers/media/video/cx231xx/cx231xx-core.o
  CC [M]  drivers/media/video/cx18/cx18-dvb.o
  CC [M]  drivers/media/video/cx18/cx18-io.o
  CC [M]  drivers/media/video/cx231xx/cx231xx-avcore.o
  LD [M]  drivers/media/video/cx18/cx18.o
  LD [M]  drivers/media/video/cx18/cx18-alsa.o
  LD      drivers/media/video/cx23885/built-in.o
  CC [M]  drivers/media/video/cx23885/cx23885-cards.o
  CC [M]  drivers/media/video/cx23885/cx23885-video.o
drivers/net/ethernet/broadcom/cnic.c: In function ‘cnic_start_bnx2_hw’:
drivers/net/ethernet/broadcom/cnic.c:4699:1: warning: the frame size
of 1312 bytes is larger than 1024 bytes [-Wframe-larger-than=]
  CC [M]  drivers/media/video/cx231xx/cx231xx-417.o
  LD      drivers/net/ethernet/brocade/built-in.o
  LD      drivers/net/ethernet/chelsio/built-in.o
  LD      drivers/net/ethernet/chelsio/cxgb3/built-in.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.o
  CC [M]  drivers/media/video/cx23885/cx23885-vbi.o
  CC [M]  drivers/media/video/cx231xx/cx231xx-pcb-cfg.o
  CC [M]  drivers/media/video/cx23885/cx23885-core.o
  CC [M]  drivers/media/video/cx231xx/cx231xx-vbi.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb3/ael1002.o
  CC [M]  drivers/media/video/cx231xx/cx231xx-input.o
  CC [M]  drivers/media/video/cx23885/cx23885-i2c.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb3/vsc8211.o
  LD [M]  drivers/media/video/cx231xx/cx231xx.o
  LD [M]  drivers/media/video/cx231xx/cx231xx-alsa.o
  LD      drivers/media/video/cx25821/built-in.o
  CC [M]  drivers/media/video/cx25821/cx25821-core.o
  CC [M]  drivers/media/video/cx23885/cx23885-dvb.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb3/t3_hw.o
In file included from drivers/media/video/cx23885/cx23885-dvb.c:65:0:
drivers/media/common/tuners/mt2063.h:28:13: warning: ‘enum
MTTune_atv_standard’ declared inside parameter list [enabled by
default]
drivers/media/common/tuners/mt2063.h:28:13: warning: its scope is only
this definition or declaration, which is probably not what you want
[enabled by default]
  CC [M]  drivers/media/video/cx25821/cx25821-cards.o
  CC [M]  drivers/media/video/cx25821/cx25821-i2c.o
  CC [M]  drivers/media/video/cx23885/cx23885-417.o
  CC [M]  drivers/media/video/cx25821/cx25821-gpio.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb3/mc5.o
  CC [M]  drivers/media/video/cx23885/cx23885-ioctl.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb3/xgmac.o
  CC [M]  drivers/media/video/cx25821/cx25821-medusa-video.o
  CC [M]  drivers/media/video/cx23885/cx23885-ir.o
  CC [M]  drivers/media/video/cx25821/cx25821-video.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb3/sge.o
  CC [M]  drivers/media/video/cx23885/cx23885-av.o
  CC [M]  drivers/media/video/cx23885/cx23885-input.o
  CC [M]  drivers/media/video/cx25821/cx25821-video-upstream.o
  CC [M]  drivers/media/video/cx23885/cx23888-ir.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb3/l2t.o
  CC [M]  drivers/media/video/cx25821/cx25821-video-upstream-ch2.o
  CC [M]  drivers/media/video/cx23885/netup-init.o
  CC [M]  drivers/media/video/cx23885/cimax2.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.o
  CC [M]  drivers/media/video/cx25821/cx25821-audio-upstream.o
  CC [M]  drivers/media/video/cx23885/netup-eeprom.o
  CC [M]  drivers/media/video/cx25821/cx25821-alsa.o
  CC [M]  drivers/media/video/cx23885/cx23885-f300.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb3/aq100x.o
  CC [M]  drivers/media/video/cx23885/cx23885-alsa.o
  LD [M]  drivers/media/video/cx25821/cx25821.o
  LD      drivers/media/video/cx25840/built-in.o
  CC [M]  drivers/media/video/cx25840/cx25840-core.o
  LD [M]  drivers/net/ethernet/chelsio/cxgb3/cxgb3.o
  LD      drivers/net/ethernet/chelsio/cxgb4/built-in.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.o
  LD [M]  drivers/media/video/cx23885/cx23885.o
  LD      drivers/media/video/cx88/built-in.o
  CC [M]  drivers/media/video/cx88/cx88-video.o
  CC [M]  drivers/media/video/cx88/cx88-vbi.o
  CC [M]  drivers/media/video/cx25840/cx25840-audio.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb4/l2t.o
  CC [M]  drivers/media/video/cx88/cx88-cards.o
  CC [M]  drivers/media/video/cx25840/cx25840-firmware.o
  CC [M]  drivers/media/video/cx25840/cx25840-vbi.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb4/t4_hw.o
  CC [M]  drivers/media/video/cx25840/cx25840-ir.o
  CC [M]  drivers/media/video/cx88/cx88-core.o
  LD [M]  drivers/media/video/cx25840/cx25840.o
  LD      drivers/media/video/davinci/built-in.o
  LD      drivers/media/video/em28xx/built-in.o
  CC [M]  drivers/media/video/em28xx/em28xx-audio.o
  CC [M]  drivers/net/ethernet/chelsio/cxgb4/sge.o
  CC [M]  drivers/media/video/cx88/cx88-i2c.o
  CC [M]  drivers/media/video/em28xx/em28xx-video.o
  CC [M]  drivers/media/video/cx88/cx88-tvaudio.o
  CC [M]  drivers/media/video/cx88/cx88-dsp.o
  CC [M]  drivers/media/video/em28xx/em28xx-i2c.o
  LD [M]  drivers/net/ethernet/chelsio/cxgb4/cxgb4.o
  LD      drivers/net/ethernet/cirrus/built-in.o
  LD      drivers/net/ethernet/cisco/built-in.o
  LD      drivers/net/ethernet/dec/tulip/built-in.o
  CC [M]  drivers/net/ethernet/dec/tulip/winbond-840.o
  CC [M]  drivers/media/video/em28xx/em28xx-cards.o
  CC [M]  drivers/media/video/cx88/cx88-input.o
  LD      drivers/net/ethernet/dec/built-in.o
  LD      drivers/net/ethernet/dlink/built-in.o
  CC [M]  drivers/net/ethernet/dlink/sundance.o
  CC [M]  drivers/media/video/cx88/cx88-alsa.o
  CC [M]  drivers/media/video/em28xx/em28xx-core.o
  LD [M]  drivers/media/video/cx88/cx88xx.o
  LD [M]  drivers/media/video/cx88/cx8800.o
  LD      drivers/media/video/ivtv/built-in.o
  CC [M]  drivers/media/video/ivtv/ivtv-routing.o
  LD      drivers/net/ethernet/emulex/built-in.o
  LD      drivers/net/ethernet/fujitsu/built-in.o
  LD      drivers/net/ethernet/hp/built-in.o
  LD      drivers/net/ethernet/i825xx/built-in.o
  LD      drivers/net/ethernet/icplus/built-in.o
  CC [M]  drivers/net/ethernet/icplus/ipg.o
  CC [M]  drivers/media/video/em28xx/em28xx-vbi.o
  CC [M]  drivers/media/video/ivtv/ivtv-cards.o
  CC [M]  drivers/media/video/em28xx/em28xx-input.o
  CC [M]  drivers/media/video/ivtv/ivtv-controls.o
  LD      drivers/net/ethernet/intel/built-in.o
  CC [M]  drivers/net/ethernet/intel/e100.o
  CC [M]  drivers/media/video/ivtv/ivtv-driver.o
  LD [M]  drivers/media/video/em28xx/em28xx.o
  LD [M]  drivers/media/video/em28xx/em28xx-alsa.o
  LD      drivers/media/video/saa7134/built-in.o
  CC [M]  drivers/media/video/saa7134/saa6752hs.o
drivers/media/video/ivtv/ivtv-driver.c: In function ‘__check_radio’:
drivers/media/video/ivtv/ivtv-driver.c:142:1: warning: return from
incompatible pointer type [enabled by default]
drivers/media/video/ivtv/ivtv-driver.c: At top level:
drivers/media/video/ivtv/ivtv-driver.c:142:1: warning: initialization
from incompatible pointer type [enabled by default]
drivers/media/video/ivtv/ivtv-driver.c:142:1: warning: (near
initialization for ‘__param_arr_radio.num’) [enabled by default]
  CC [M]  drivers/media/video/saa7134/saa7134-cards.o
  CC [M]  drivers/media/video/ivtv/ivtv-fileops.o
  LD      drivers/net/ethernet/marvell/built-in.o
  LD      drivers/net/ethernet/mellanox/built-in.o
  LD      drivers/net/ethernet/micrel/built-in.o
  CC [M]  drivers/net/ethernet/micrel/ks8851.o
  CC [M]  drivers/media/video/saa7134/saa7134-core.o
  CC [M]  drivers/media/video/ivtv/ivtv-firmware.o
  CC [M]  drivers/net/ethernet/micrel/ks8851_mll.o
  CC [M]  drivers/media/video/ivtv/ivtv-gpio.o
  CC [M]  drivers/media/video/saa7134/saa7134-i2c.o
  CC [M]  drivers/net/ethernet/micrel/ksz884x.o
  CC [M]  drivers/media/video/ivtv/ivtv-i2c.o
  CC [M]  drivers/media/video/saa7134/saa7134-ts.o
  CC [M]  drivers/media/video/ivtv/ivtv-ioctl.o
  CC [M]  drivers/media/video/saa7134/saa7134-tvaudio.o
  CC [M]  drivers/media/video/saa7134/saa7134-vbi.o
  CC [M]  drivers/media/video/ivtv/ivtv-irq.o
  LD      drivers/net/ethernet/microchip/built-in.o
  LD      drivers/net/ethernet/myricom/built-in.o
  LD      drivers/net/ethernet/natsemi/built-in.o
  LD      drivers/net/ethernet/neterion/built-in.o
  LD      drivers/net/ethernet/nvidia/built-in.o
  LD      drivers/net/ethernet/oki-semi/built-in.o
  LD      drivers/net/ethernet/oki-semi/pch_gbe/built-in.o
  CC [M]  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.o
  CC [M]  drivers/media/video/saa7134/saa7134-video.o
  CC [M]  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.o
  CC [M]  drivers/media/video/ivtv/ivtv-mailbox.o
  CC [M]  drivers/media/video/ivtv/ivtv-queue.o
  CC [M]  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.o
  CC [M]  drivers/media/video/saa7134/saa7134-input.o
  CC [M]  drivers/media/video/ivtv/ivtv-streams.o
  CC [M]  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_api.o
  CC [M]  drivers/media/video/saa7134/saa7134-empress.o
  CC [M]  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.o
  CC [M]  drivers/media/video/ivtv/ivtv-udma.o
  CC [M]  drivers/media/video/saa7134/saa7134-alsa.o
  CC [M]  drivers/media/video/ivtv/ivtv-vbi.o
  LD [M]  drivers/media/video/saa7134/saa7134.o
  LD      drivers/media/video/saa7164/built-in.o
  CC [M]  drivers/media/video/saa7164/saa7164-cards.o
  CC [M]  drivers/media/video/ivtv/ivtv-yuv.o
  LD [M]  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.o
  LD      drivers/net/ethernet/packetengines/built-in.o
  CC [M]  drivers/net/ethernet/packetengines/hamachi.o
  CC [M]  drivers/media/video/saa7164/saa7164-core.o
  LD [M]  drivers/media/video/ivtv/ivtv.o
  LD      drivers/media/video/tlg2300/built-in.o
  CC [M]  drivers/media/video/tlg2300/pd-video.o
  LD      drivers/net/ethernet/qlogic/built-in.o
  LD      drivers/net/ethernet/racal/built-in.o
  LD      drivers/net/ethernet/rdc/built-in.o
  CC [M]  drivers/net/ethernet/rdc/r6040.o
  CC [M]  drivers/media/video/saa7164/saa7164-i2c.o
  CC [M]  drivers/media/video/tlg2300/pd-alsa.o
  CC [M]  drivers/media/video/saa7164/saa7164-dvb.o
  LD      drivers/net/ethernet/realtek/built-in.o
  CC [M]  drivers/net/ethernet/realtek/8139cp.o
  CC [M]  drivers/media/video/tlg2300/pd-dvb.o
  CC [M]  drivers/media/video/saa7164/saa7164-fw.o
  CC [M]  drivers/media/video/tlg2300/pd-radio.o
  CC [M]  drivers/net/ethernet/realtek/8139too.o
  CC [M]  drivers/media/video/saa7164/saa7164-bus.o
  CC [M]  drivers/media/video/tlg2300/pd-main.o
  CC [M]  drivers/media/video/saa7164/saa7164-cmd.o
  LD [M]  drivers/media/video/tlg2300/poseidon.o
  LD      drivers/media/video/tm6000/built-in.o
  CC [M]  drivers/media/video/tm6000/tm6000-cards.o
  CC [M]  drivers/net/ethernet/realtek/r8169.o
  CC [M]  drivers/media/video/saa7164/saa7164-api.o
  CC [M]  drivers/media/video/tm6000/tm6000-core.o
  CC [M]  drivers/media/video/tm6000/tm6000-i2c.o
  CC [M]  drivers/media/video/saa7164/saa7164-buffer.o
  CC [M]  drivers/media/video/tm6000/tm6000-video.o
  CC [M]  drivers/media/video/saa7164/saa7164-encoder.o
  LD      drivers/net/ethernet/seeq/built-in.o
  LD      drivers/net/ethernet/sfc/built-in.o
  CC [M]  drivers/net/ethernet/sfc/efx.o
  CC [M]  drivers/media/video/saa7164/saa7164-vbi.o
  CC [M]  drivers/media/video/tm6000/tm6000-stds.o
  CC [M]  drivers/media/video/tm6000/tm6000-input.o
  CC [M]  drivers/net/ethernet/sfc/nic.o
  LD [M]  drivers/media/video/saa7164/saa7164.o
  CC [M]  drivers/media/video/msp3400-driver.o
  CC [M]  drivers/media/video/tm6000/tm6000-alsa.o
  CC [M]  drivers/media/video/msp3400-kthreads.o
  LD [M]  drivers/media/video/tm6000/tm6000.o
  CC [M]  drivers/media/video/tuner-core.o
  CC [M]  drivers/net/ethernet/sfc/falcon.o
  CC [M]  drivers/media/video/v4l2-dev.o
  CC [M]  drivers/media/video/v4l2-ioctl.o
  CC [M]  drivers/media/video/v4l2-device.o
  CC [M]  drivers/net/ethernet/sfc/siena.o
  CC [M]  drivers/media/video/v4l2-fh.o
  CC [M]  drivers/media/video/v4l2-event.o
  CC [M]  drivers/net/ethernet/sfc/tx.o
  CC [M]  drivers/media/video/v4l2-ctrls.o
  CC [M]  drivers/media/video/v4l2-subdev.o
  CC [M]  drivers/net/ethernet/sfc/rx.o
  CC [M]  drivers/media/video/v4l2-int-device.o
  CC [M]  drivers/media/video/v4l2-common.o
  CC [M]  drivers/net/ethernet/sfc/filter.o
  LD [M]  drivers/media/video/tuner.o
  CC [M]  drivers/media/video/saa7115.o
  CC [M]  drivers/media/video/saa717x.o
  CC [M]  drivers/net/ethernet/sfc/falcon_xmac.o
  CC [M]  drivers/media/video/saa7127.o
  LD [M]  drivers/media/video/msp3400.o
  CC [M]  drivers/media/video/cs5345.o
  CC [M]  drivers/net/ethernet/sfc/mcdi_mac.o
  CC [M]  drivers/media/video/cs53l32a.o
  CC [M]  drivers/media/video/m52790.o
  CC [M]  drivers/media/video/wm8775.o
  CC [M]  drivers/net/ethernet/sfc/selftest.o
  CC [M]  drivers/media/video/wm8739.o
  CC [M]  drivers/media/video/vp27smpx.o
  CC [M]  drivers/media/video/upd64031a.o
  CC [M]  drivers/net/ethernet/sfc/ethtool.o
  CC [M]  drivers/media/video/upd64083.o
  CC [M]  drivers/media/video/tveeprom.o
  CC [M]  drivers/media/video/videobuf-core.o
  CC [M]  drivers/net/ethernet/sfc/qt202x_phy.o
  CC [M]  drivers/media/video/videobuf-dma-sg.o
  CC [M]  drivers/net/ethernet/sfc/mdio_10g.o
  CC [M]  drivers/media/video/videobuf-vmalloc.o
  CC [M]  drivers/media/video/videobuf-dvb.o
  CC [M]  drivers/net/ethernet/sfc/tenxpress.o
  CC [M]  drivers/media/video/btcx-risc.o
  CC [M]  drivers/media/video/cx2341x.o
  CC [M]  drivers/net/ethernet/sfc/txc43128_phy.o
  LD      drivers/media/video/built-in.o
  LD [M]  drivers/media/video/videodev.o
  LD      drivers/net/phy/built-in.o
  CC [M]  drivers/net/phy/phy.o
  CC [M]  drivers/net/ethernet/sfc/falcon_boards.o
  LD      drivers/media/built-in.o
  LD      drivers/nfc/built-in.o
  CC      drivers/of/base.o
  CC [M]  drivers/net/phy/phy_device.o
  CC [M]  drivers/net/ethernet/sfc/mcdi.o
  CC      drivers/of/pdt.o
  CC [M]  drivers/net/phy/mdio_bus.o
  CC      drivers/of/address.o
  CC [M]  drivers/net/ethernet/sfc/mcdi_phy.o
  LD [M]  drivers/net/phy/libphy.o
  CC      drivers/of/irq.o
  LD      drivers/net/ppp/built-in.o
  CC [M]  drivers/net/ppp/ppp_generic.o
  CC [M]  drivers/net/ethernet/sfc/mtd.o
  CC      drivers/of/device.o
  LD [M]  drivers/net/ethernet/sfc/sfc.o
  LD      drivers/net/ethernet/silan/built-in.o
  LD      drivers/net/ethernet/sis/built-in.o
  CC [M]  drivers/net/ethernet/sis/sis190.o
  CC      drivers/of/platform.o
  CC      drivers/of/gpio.o
  CC [M]  drivers/net/ppp/ppp_deflate.o
  CC      drivers/of/of_net.o
  LD      drivers/net/slip/built-in.o
  CC [M]  drivers/net/slip/slhc.o
  CC [M]  drivers/net/ethernet/sis/sis900.o
  CC      drivers/of/of_spi.o
  CC      drivers/of/of_pci.o
  LD      drivers/net/usb/built-in.o
  CC [M]  drivers/net/usb/pegasus.o
  LD      drivers/net/ethernet/smsc/built-in.o
  CC [M]  drivers/net/ethernet/smsc/smc91c92_cs.o
  CC      drivers/of/of_pci_irq.o
  CC [M]  drivers/of/of_i2c.o
  CC [M]  drivers/net/usb/rtl8150.o
  CC [M]  drivers/of/of_mdio.o
  CC [M]  drivers/net/ethernet/smsc/epic100.o
  CC [M]  drivers/net/usb/usbnet.o
  LD      drivers/of/built-in.o
  LD      drivers/parport/built-in.o
  CC [M]  drivers/parport/share.o
  LD      drivers/net/ethernet/stmicro/built-in.o
  LD      drivers/net/ethernet/stmicro/stmmac/built-in.o
  CC [M]  drivers/net/ethernet/stmicro/stmmac/stmmac_main.o
  CC [M]  drivers/parport/ieee1284.o
  LD      drivers/net/wireless/built-in.o
  CC [M]  drivers/net/mii.o
  CC [M]  drivers/parport/ieee1284_ops.o
  CC [M]  drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.o
  CC [M]  drivers/net/mdio.o
  CC [M]  drivers/parport/procfs.o
  CC [M]  drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o
  LD      drivers/net/ethernet/sun/built-in.o
  LD      drivers/net/ethernet/tehuti/built-in.o
  LD      drivers/net/ethernet/ti/built-in.o
  CC [M]  drivers/parport/daisy.o
  CC      drivers/pci/access.o
  CC [M]  drivers/net/ethernet/stmicro/stmmac/dwmac_lib.o
  CC [M]  drivers/parport/probe.o
  CC [M]  drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.o
  CC      drivers/pci/bus.o
  LD [M]  drivers/parport/parport.o
  LD      drivers/pcmcia/built-in.o
  CC [M]  drivers/pcmcia/ds.o
  CC [M]  drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.o
  CC      drivers/pci/probe.o
  CC [M]  drivers/net/ethernet/stmicro/stmmac/dwmac100_core.o
  CC [M]  drivers/pcmcia/pcmcia_resource.o
  CC [M]  drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.o
  CC      drivers/pci/remove.o
  CC [M]  drivers/net/ethernet/stmicro/stmmac/enh_desc.o
  CC      drivers/pci/pci.o
  CC [M]  drivers/pcmcia/cistpl.o
  CC [M]  drivers/net/ethernet/stmicro/stmmac/norm_desc.o
  CC [M]  drivers/net/ethernet/stmicro/stmmac/mmc_core.o
  CC [M]  drivers/net/ethernet/stmicro/stmmac/ring_mode.o
  CC [M]  drivers/pcmcia/pcmcia_cis.o
  LD [M]  drivers/net/ethernet/stmicro/stmmac/stmmac.o
  LD      drivers/net/ethernet/via/built-in.o
  CC [M]  drivers/net/ethernet/via/via-rhine.o
  CC      drivers/pci/pci-driver.o
  CC [M]  drivers/pcmcia/cs.o
  CC      drivers/pci/search.o
  CC [M]  drivers/pcmcia/socket_sysfs.o
  CC [M]  drivers/net/ethernet/via/via-velocity.o
  CC      drivers/pci/pci-sysfs.o
  CC [M]  drivers/pcmcia/cardbus.o
  CC [M]  drivers/pcmcia/rsrc_mgr.o
  CC      drivers/pci/rom.o
  CC [M]  drivers/pcmcia/rsrc_nonstatic.o
  CC      drivers/pci/setup-res.o
  LD      drivers/net/ethernet/xircom/built-in.o
  CC [M]  drivers/net/ethernet/jme.o
  CC      drivers/pci/irq.o
  CC [M]  drivers/pcmcia/yenta_socket.o
  CC      drivers/pci/vpd.o
  CC      drivers/pci/proc.o
  LD [M]  drivers/pcmcia/pcmcia_core.o
  LD [M]  drivers/pcmcia/pcmcia.o
  LD [M]  drivers/pcmcia/pcmcia_rsrc.o
  LD      drivers/pinctrl/built-in.o
  LD      drivers/platform/x86/built-in.o
  CC [M]  drivers/platform/x86/thinkpad_acpi.o
  CC      drivers/pci/slot.o
  CC [M]  drivers/net/ethernet/fealnx.o
  CC      drivers/pci/quirks.o
  CC [M]  drivers/net/ethernet/ethoc.o
  LD      drivers/pci/hotplug/built-in.o
  CC [M]  drivers/pci/hotplug/pci_hotplug_core.o
  LD      drivers/net/ethernet/built-in.o
  LD      drivers/net/built-in.o
  CC      drivers/pnp/core.o
  CC [M]  drivers/platform/x86/wmi.o
  CC [M]  drivers/pci/hotplug/pcihp_slot.o
  CC      drivers/pnp/card.o
  CC [M]  drivers/pci/hotplug/cpci_hotplug_core.o
  CC [M]  drivers/platform/x86/mxm-wmi.o
  CC      drivers/pnp/driver.o
  LD      drivers/platform/built-in.o
  CC      drivers/power/power_supply_core.o
  CC      drivers/pnp/resource.o
  CC [M]  drivers/pci/hotplug/cpci_hotplug_pci.o
  CC      drivers/power/power_supply_sysfs.o
  CC      drivers/power/power_supply_leds.o
  CC [M]  drivers/pci/hotplug/acpi_pcihp.o
  CC      drivers/pnp/manager.o
  LD      drivers/power/power_supply.o
  LD      drivers/power/built-in.o
  CC      drivers/rapidio/rio.o
  CC      drivers/pnp/support.o
  CC [M]  drivers/pci/hotplug/shpchp_core.o
  CC      drivers/pnp/interface.o
  CC      drivers/rapidio/rio-access.o
  CC [M]  drivers/pci/hotplug/shpchp_ctrl.o
  CC      drivers/pnp/quirks.o
  CC      drivers/rapidio/rio-driver.o
  CC      drivers/pnp/system.o
  CC      drivers/rapidio/rio-scan.o
  CC [M]  drivers/pci/hotplug/shpchp_pci.o
  CC      drivers/pnp/isapnp/core.o
  CC [M]  drivers/pci/hotplug/shpchp_sysfs.o
  CC      drivers/rapidio/rio-sysfs.o
  CC      drivers/pnp/isapnp/compat.o
  CC      drivers/rapidio/devices/tsi721.o
  CC [M]  drivers/pci/hotplug/shpchp_hpc.o
  CC      drivers/pnp/isapnp/proc.o
  LD      drivers/pnp/isapnp/pnp.o
  LD      drivers/pnp/isapnp/built-in.o
  CC      drivers/pnp/pnpacpi/core.o
  LD [M]  drivers/pci/hotplug/pci_hotplug.o
  LD [M]  drivers/pci/hotplug/shpchp.o
  CC      drivers/pci/pcie/aspm.o
  CC      drivers/pnp/pnpacpi/rsparser.o
  LD      drivers/rapidio/devices/built-in.o
  CC      drivers/rapidio/switches/tsi57x.o
  CC      drivers/pci/pcie/portdrv_core.o
  CC      drivers/rapidio/switches/idtcps.o
  CC      drivers/rapidio/switches/tsi568.o
  LD      drivers/pnp/pnpacpi/pnp.o
  LD      drivers/pnp/pnpacpi/built-in.o
  LD      drivers/pnp/pnp.o
  LD      drivers/pnp/built-in.o
  CC      drivers/regulator/core.o
  CC      drivers/pci/pcie/portdrv_pci.o
  CC      drivers/rapidio/switches/tsi500.o
  CC      drivers/rapidio/switches/idt_gen2.o
  CC      drivers/pci/pcie/portdrv_bus.o
  LD      drivers/rapidio/switches/built-in.o
  LD      drivers/rapidio/built-in.o
  CC      drivers/pci/ioapic.o
  CC      drivers/pci/pcie/portdrv_acpi.o
  CC      drivers/pci/hotplug.o
  CC      drivers/pci/pcie/aer/aerdrv_errprint.o
  CC      drivers/pci/hotplug-pci.o
  CC      drivers/pci/msi.o
  CC      drivers/regulator/dummy.o
  CC      drivers/pci/pcie/aer/aerdrv_core.o
  CC      drivers/regulator/of_regulator.o
  CC      drivers/pci/htirq.o
  CC      drivers/regulator/ab8500.o
  CC      drivers/pci/pcie/aer/aerdrv.o
  CC      drivers/pci/ats.o
  LD      drivers/regulator/built-in.o
  CC      drivers/rtc/rtc-lib.o
  CC      drivers/pci/pcie/aer/aerdrv_acpi.o
  CC      drivers/rtc/hctosys.o
  CC      drivers/pci/iov.o
  LD      drivers/pci/pcie/aer/aerdriver.o
  LD      drivers/pci/pcie/aer/built-in.o
  CC      drivers/pci/pcie/pme.o
  CC      drivers/rtc/class.o
  CC      drivers/pci/setup-bus.o
  LD      drivers/pci/pcie/pcieportdrv.o
  LD      drivers/pci/pcie/built-in.o
  CC      drivers/pci/pci-acpi.o
  CC      drivers/rtc/interface.o
  CC      drivers/pci/pci-label.o
  CC      drivers/rtc/rtc-dev.o
  CC      drivers/pci/of.o
  LD      drivers/scsi/bnx2fc/built-in.o
  CC [M]  drivers/scsi/bnx2fc/bnx2fc_els.o
  LD      drivers/pci/built-in.o
  CC      drivers/sfi/sfi_acpi.o
  CC      drivers/rtc/rtc-proc.o
  CC      drivers/sfi/sfi_core.o
  CC      drivers/rtc/rtc-sysfs.o
  CC      drivers/rtc/rtc-cmos.o
  LD      drivers/sfi/built-in.o
  CC      drivers/spi/spi.o
  CC [M]  drivers/scsi/bnx2fc/bnx2fc_fcoe.o
  LD      drivers/rtc/rtc-core.o
  LD      drivers/rtc/built-in.o
  LD      drivers/ssb/built-in.o
  CC [M]  drivers/ssb/main.o
  LD      drivers/spi/built-in.o
  CC      drivers/staging/staging.o
  LD      drivers/staging/line6/built-in.o
  CC [M]  drivers/staging/line6/audio.o
  CC [M]  drivers/scsi/bnx2fc/bnx2fc_hwi.o
  CC [M]  drivers/staging/line6/capture.o
  CC [M]  drivers/ssb/scan.o
  CC [M]  drivers/staging/line6/control.o
  CC [M]  drivers/ssb/sprom.o
  CC [M]  drivers/ssb/pci.o
  CC [M]  drivers/scsi/bnx2fc/bnx2fc_io.o
  CC [M]  drivers/ssb/pcihost_wrapper.o
  CC [M]  drivers/staging/line6/driver.o
  CC [M]  drivers/ssb/pcmcia.o
  CC [M]  drivers/staging/line6/dumprequest.o
  CC [M]  drivers/ssb/driver_chipcommon.o
  CC [M]  drivers/staging/line6/midi.o
  CC [M]  drivers/scsi/bnx2fc/bnx2fc_tgt.o
  CC [M]  drivers/staging/line6/midibuf.o
  CC [M]  drivers/ssb/driver_chipcommon_pmu.o
  CC [M]  drivers/staging/line6/pcm.o
  CC [M]  drivers/ssb/driver_pcicore.o
  CC [M]  drivers/staging/line6/playback.o
  LD [M]  drivers/scsi/bnx2fc/bnx2fc.o
  LD      drivers/scsi/bnx2i/built-in.o
  CC [M]  drivers/scsi/bnx2i/bnx2i_init.o
  LD [M]  drivers/ssb/ssb.o
  CC      drivers/thermal/thermal_sys.o
  CC [M]  drivers/staging/line6/pod.o
  CC [M]  drivers/scsi/bnx2i/bnx2i_hwi.o
  LD      drivers/thermal/built-in.o
  CC      drivers/tty/tty_io.o
  CC [M]  drivers/staging/line6/toneport.o
  CC [M]  drivers/staging/line6/variax.o
  CC [M]  drivers/staging/line6/podhd.o
  CC [M]  drivers/scsi/bnx2i/bnx2i_iscsi.o
  LD [M]  drivers/staging/line6/line6usb.o
  LD      drivers/staging/media/easycap/built-in.o
  CC [M]  drivers/staging/media/easycap/easycap_main.o
  CC      drivers/tty/n_tty.o
  CC [M]  drivers/scsi/bnx2i/bnx2i_sysfs.o
  CC      drivers/tty/tty_ioctl.o
  LD [M]  drivers/scsi/bnx2i/bnx2i.o
  LD      drivers/scsi/cxgbi/built-in.o
  CC [M]  drivers/scsi/cxgbi/libcxgbi.o
  CC [M]  drivers/staging/media/easycap/easycap_low.o
  CC      drivers/tty/tty_ldisc.o
  CC [M]  drivers/staging/media/easycap/easycap_ioctl.o
  CC      drivers/tty/tty_buffer.o
  CC      drivers/tty/tty_port.o
  CC [M]  drivers/staging/media/easycap/easycap_settings.o
  LD      drivers/scsi/cxgbi/cxgb3i/built-in.o
  CC [M]  drivers/scsi/cxgbi/cxgb3i/cxgb3i.o
  CC [M]  drivers/staging/media/easycap/easycap_testcard.o
  CC      drivers/tty/tty_mutex.o
  CC [M]  drivers/staging/media/easycap/easycap_sound.o
  CC      drivers/tty/pty.o
  CC      drivers/tty/tty_audit.o
  LD [M]  drivers/staging/media/easycap/easycap.o
  LD      drivers/staging/media/go7007/built-in.o
  CC [M]  drivers/staging/media/go7007/go7007-v4l2.o
  LD      drivers/scsi/cxgbi/cxgb4i/built-in.o
  CC [M]  drivers/scsi/cxgbi/cxgb4i/cxgb4i.o
  CC      drivers/tty/sysrq.o
  CC [M]  drivers/staging/media/go7007/go7007-driver.o
  CC      drivers/tty/hvc/hvc_console.o
  LD      drivers/scsi/fcoe/built-in.o
  CC [M]  drivers/scsi/fcoe/fcoe_ctlr.o
  LD      drivers/tty/hvc/built-in.o
  LD      drivers/tty/ipwireless/built-in.o
  CC      drivers/tty/serial/serial_core.o
  CC [M]  drivers/staging/media/go7007/go7007-i2c.o
  CC [M]  drivers/staging/media/go7007/go7007-fw.o
  CC      drivers/tty/serial/8250/8250.o
  CC [M]  drivers/scsi/fcoe/fcoe_transport.o
  CC [M]  drivers/staging/media/go7007/snd-go7007.o
  CC      drivers/tty/serial/8250/8250_pnp.o
  LD [M]  drivers/staging/media/go7007/go7007.o
  LD      drivers/staging/media/lirc/built-in.o
  LD [M]  drivers/scsi/fcoe/libfcoe.o
  LD      drivers/scsi/libfc/built-in.o
  LD      drivers/staging/media/solo6x10/built-in.o
  CC [M]  drivers/scsi/libfc/fc_libfc.o
  CC [M]  drivers/staging/media/solo6x10/core.o
  CC      drivers/tty/serial/8250/8250_pci.o
  CC [M]  drivers/staging/media/solo6x10/i2c.o
  CC [M]  drivers/scsi/libfc/fc_disc.o
  CC      drivers/tty/serial/8250/8250_early.o
  CC [M]  drivers/staging/media/solo6x10/p2m.o
  LD      drivers/tty/serial/8250/built-in.o
  LD      drivers/tty/serial/built-in.o
  CC      drivers/tty/vt/vt_ioctl.o
  CC [M]  drivers/staging/media/solo6x10/v4l2.o
  CC [M]  drivers/scsi/libfc/fc_exch.o
  CC [M]  drivers/staging/media/solo6x10/tw28.o
  CC      drivers/tty/vt/vc_screen.o
  CC [M]  drivers/staging/media/solo6x10/gpio.o
  CC [M]  drivers/scsi/libfc/fc_elsct.o
  CC      drivers/tty/vt/selection.o
  CC [M]  drivers/staging/media/solo6x10/disp.o
  CC      drivers/tty/vt/keyboard.o
  CC [M]  drivers/scsi/libfc/fc_frame.o
  CC [M]  drivers/staging/media/solo6x10/enc.o
  CC [M]  drivers/scsi/libfc/fc_lport.o
  CC [M]  drivers/staging/media/solo6x10/v4l2-enc.o
  CC      drivers/tty/vt/consolemap.o
  CONMK   drivers/tty/vt/consolemap_deftbl.c
  CC      drivers/tty/vt/vt.o
  CC [M]  drivers/staging/media/solo6x10/g723.o
  CC [M]  drivers/scsi/libfc/fc_rport.o
  LD [M]  drivers/staging/media/solo6x10/solo6x10.o
  LD      drivers/staging/media/built-in.o
  LD      drivers/staging/serial/built-in.o
  LD      drivers/staging/built-in.o
  LD      drivers/uio/built-in.o
  CC [M]  drivers/uio/uio.o
  LD      drivers/usb/core/built-in.o
  CC [M]  drivers/usb/core/usb.o
  CC [M]  drivers/scsi/libfc/fc_fcp.o
  CC [M]  drivers/usb/core/hub.o
  SHIPPED drivers/tty/vt/defkeymap.c
  CC      drivers/tty/vt/consolemap_deftbl.o
  CC      drivers/tty/vt/defkeymap.o
  LD      drivers/tty/vt/built-in.o
  LD      drivers/tty/built-in.o
  CC      drivers/video/fb_notify.o
  CC [M]  drivers/scsi/libfc/fc_npiv.o
  CC      drivers/video/fbmem.o
  LD [M]  drivers/scsi/libfc/libfc.o
  LD      drivers/scsi/megaraid/built-in.o
  LD      drivers/scsi/pcmcia/built-in.o
  CC [M]  drivers/scsi/scsi.o
  CC [M]  drivers/usb/core/hcd.o
  CC      drivers/video/fbmon.o
  CC [M]  drivers/scsi/hosts.o
  CC [M]  drivers/usb/core/urb.o
  CC      drivers/video/fbcmap.o
  CC [M]  drivers/usb/core/message.o
  CC [M]  drivers/scsi/scsi_ioctl.o
  CC      drivers/video/fbsysfs.o
  CC [M]  drivers/scsi/constants.o
  CC      drivers/video/modedb.o
  CC [M]  drivers/usb/core/driver.o
  CC [M]  drivers/scsi/scsicam.o
  CC      drivers/video/fbcvt.o
  CC [M]  drivers/scsi/scsi_error.o
  CC [M]  drivers/usb/core/config.o
  CC      drivers/video/backlight/backlight.o
  LD      drivers/video/backlight/built-in.o
  CC [M]  drivers/usb/core/file.o
  CC      drivers/video/console/dummycon.o
  CC      drivers/video/console/vgacon.o
  CC [M]  drivers/scsi/scsi_lib.o
  CC [M]  drivers/usb/core/buffer.o
  CC [M]  drivers/usb/core/sysfs.o
  CC      drivers/video/console/fbcon.o
  CC [M]  drivers/usb/core/endpoint.o
  CC [M]  drivers/scsi/scsi_lib_dma.o
  CC [M]  drivers/usb/core/devio.o
  CC [M]  drivers/scsi/scsi_scan.o
  CC      drivers/video/console/bitblit.o
  CC [M]  drivers/usb/core/notify.o
  CC [M]  drivers/scsi/scsi_sysfs.o
  CC [M]  drivers/usb/core/generic.o
  CC      drivers/video/console/fonts.o
  CC [M]  drivers/usb/core/quirks.o
  CC      drivers/video/console/font_8x16.o
  CC [M]  drivers/scsi/scsi_devinfo.o
  CC [M]  drivers/usb/core/devices.o
  CC      drivers/video/console/softcursor.o
  CC [M]  drivers/usb/core/hcd-pci.o
  CC [M]  drivers/scsi/scsi_netlink.o
  CC      drivers/video/console/tileblit.o
  CC [M]  drivers/usb/core/inode.o
  CC      drivers/video/console/fbcon_rotate.o
  CC [M]  drivers/scsi/scsi_sysctl.o
  CC [M]  drivers/scsi/scsi_proc.o
  LD [M]  drivers/usb/core/usbcore.o
  LD      drivers/usb/gadget/built-in.o
  CC [M]  drivers/usb/gadget/udc-core.o
  CC      drivers/video/console/fbcon_cw.o
  CC [M]  drivers/scsi/scsi_trace.o
  CC [M]  drivers/usb/gadget/audio.o
  CC [M]  drivers/scsi/scsi_pm.o
  CC      drivers/video/console/fbcon_ud.o
  CC [M]  drivers/scsi/sd.o
  CC      drivers/video/console/fbcon_ccw.o
  CC [M]  drivers/usb/gadget/gmidi.o
  LD      drivers/video/console/font.o
  LD      drivers/video/console/built-in.o
  LD      drivers/video/omap2/displays/built-in.o
  LD      drivers/video/omap2/built-in.o
  CC      drivers/video/cfbfillrect.o
  LD [M]  drivers/usb/gadget/g_audio.o
  CC [M]  drivers/scsi/scsi_transport_fc.o
  LD [M]  drivers/usb/gadget/g_midi.o
  CC      drivers/usb/host/pci-quirks.o
  CC      drivers/video/cfbcopyarea.o
  CC [M]  drivers/usb/host/ehci-hcd.o
  CC      drivers/video/cfbimgblt.o
  CC      drivers/video/fb_defio.o
  CC [M]  drivers/scsi/scsi_transport_iscsi.o
  CC      drivers/video/vesafb.o
  CC      drivers/video/efifb.o
  CC [M]  drivers/usb/host/ohci-hcd.o
  CC [M]  drivers/video/vgastate.o
  CC [M]  drivers/scsi/libiscsi.o
  CC [M]  drivers/video/fb_ddc.o
  CC [M]  drivers/usb/host/uhci-hcd.o
  CC [M]  drivers/video/vga16fb.o
  CC [M]  drivers/video/output.o
  LD      drivers/usb/host/built-in.o
  CC [M]  drivers/scsi/libiscsi_tcp.o
  LD      drivers/usb/misc/built-in.o
  CC [M]  drivers/usb/misc/appledisplay.o
  LD      drivers/video/fb.o
  LD      drivers/video/built-in.o
  LD      drivers/video/i810/built-in.o
  CC [M]  drivers/video/i810/i810_main.o
  LD      drivers/usb/storage/built-in.o
  CC [M]  drivers/usb/storage/uas.o
  CC [M]  drivers/usb/storage/scsiglue.o
  CC [M]  drivers/video/i810/i810_accel.o
  LD [M]  drivers/scsi/sd_mod.o
  CC [M]  drivers/scsi/scsi_wait_scan.o
  LD      drivers/scsi/built-in.o
  LD [M]  drivers/scsi/scsi_mod.o
  LD      drivers/virt/built-in.o
  CC      drivers/virtio/virtio.o
  CC [M]  drivers/usb/storage/protocol.o
  CC [M]  drivers/video/i810/i810_gtf.o
  CC      drivers/virtio/virtio_ring.o
  CC [M]  drivers/video/i810/i810-i2c.o
  CC [M]  drivers/usb/storage/transport.o
  LD      drivers/virtio/built-in.o
  CC      drivers/watchdog/watchdog_core.o
  LD [M]  drivers/video/i810/i810fb.o
  CC [M]  drivers/usb/usb-common.o
  CC      drivers/watchdog/watchdog_dev.o
  CC [M]  drivers/usb/storage/usb.o
  CC [M]  drivers/usb/storage/initializers.o
  LD      drivers/watchdog/watchdog.o
  LD      drivers/watchdog/built-in.o
  CC [M]  drivers/usb/storage/sierra_ms.o
  CC [M]  drivers/usb/storage/option_ms.o
  CC [M]  drivers/usb/storage/usual-tables.o
  LD [M]  drivers/usb/storage/usb-storage.o
  LD      drivers/usb/built-in.o
  LD      drivers/built-in.o
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
  AS      .tmp_kallsyms1.o
  LD      .tmp_vmlinux2
  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  Building modules, stage 2.
  MODPOST 518 modules
  CC      arch/x86/boot/a20.o
  AS      arch/x86/boot/bioscall.o
  CC      arch/x86/boot/cmdline.o
  AS      arch/x86/boot/copy.o
  HOSTCC  arch/x86/boot/mkcpustr
  CC      arch/x86/boot/cpucheck.o
  CC      arch/x86/boot/early_serial_console.o
  CC      arch/x86/boot/edd.o
  VOFFSET arch/x86/boot/voffset.h
  LDS     arch/x86/boot/compressed/vmlinux.lds
  AS      arch/x86/boot/compressed/head_32.o
  CC      arch/x86/boot/compressed/misc.o
  CC      arch/x86/boot/main.o
  CC      arch/x86/boot/mca.o
  CC      arch/x86/boot/memory.o
  CC      arch/x86/boot/compressed/string.o
  CC      arch/x86/boot/compressed/cmdline.o
  CC      arch/x86/boot/compressed/early_serial_console.o
  OBJCOPY arch/x86/boot/compressed/vmlinux.bin
  HOSTCC  arch/x86/boot/compressed/relocs
  HOSTCC  arch/x86/boot/compressed/mkpiggy
arch/x86/boot/compressed/relocs.c: In function ‘print_absolute_symbols’:
arch/x86/boot/compressed/relocs.c:405:14: warning: variable
‘sh_symtab’ set but not used [-Wunused-but-set-variable]
  CC      arch/x86/boot/compressed/eboot.o
  AS      arch/x86/boot/compressed/efi_stub_32.o
  RELOCS  arch/x86/boot/compressed/vmlinux.relocs
  GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
  CC      crypto/arc4.mod.o
  CC      arch/x86/boot/pm.o
  AS      arch/x86/boot/pmjump.o
  CC      crypto/crc32c.mod.o
  CC      arch/x86/boot/printf.o
  CC      crypto/deflate.mod.o
  CC      arch/x86/boot/regs.o
  CC      arch/x86/boot/string.o
  CC      arch/x86/boot/tty.o
  CC      crypto/des_generic.mod.o
  MKPIGGY arch/x86/boot/compressed/piggy.S
  AS      arch/x86/boot/compressed/piggy.o
  CC      arch/x86/boot/video.o
  CC      crypto/ecb.mod.o
arch/x86/boot/compressed/eboot.o: In function `efi_main':
eboot.c:(.text+0x1530): undefined reference to `_mmx_memcpy'
eboot.c:(.text+0x17d0): undefined reference to `_mmx_memcpy'
make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 1
make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
make[1]: *** Waiting for unfinished jobs....
  CC      crypto/hmac.mod.o
make: *** [bzImage] Error 2
make: *** Waiting for unfinished jobs....
  CC      crypto/md4.mod.o
  CC      crypto/md5.mod.o
  CC      crypto/sha1_generic.mod.o
  CC      crypto/zlib.mod.o
  CC      drivers/acpi/button.mod.o
  CC      drivers/acpi/container.mod.o
  CC      drivers/acpi/processor.mod.o
  CC      drivers/acpi/video.mod.o
  CC      drivers/ata/ata_generic.mod.o
  CC      drivers/ata/libata.mod.o
  CC      drivers/ata/pata_acpi.mod.o
  CC      drivers/ata/pata_amd.mod.o
  CC      drivers/ata/pata_arasan_cf.mod.o
  CC      drivers/base/regmap/regmap-i2c.mod.o
  CC      drivers/block/floppy.mod.o
  CC      drivers/block/loop.mod.o
  CC      drivers/char/agp/agpgart.mod.o
  CC      drivers/char/agp/amd-k7-agp.mod.o
  CC      drivers/char/agp/intel-agp.mod.o
  CC      drivers/char/agp/intel-gtt.mod.o
  CC      drivers/char/hw_random/amd-rng.mod.o
  CC      drivers/char/nvram.mod.o
  CC      drivers/dma/intel_mid_dma.mod.o
  CC      drivers/dca/dca.mod.o
  CC      drivers/dma/ioat/ioatdma.mod.o
  CC      drivers/dma/pch_dma.mod.o
  CC      drivers/dma/timb_dma.mod.o
  CC      drivers/edac/amd76x_edac.mod.o
  CC      drivers/edac/edac_core.mod.o
  CC      drivers/firewire/firewire-core.mod.o
  CC      drivers/gpu/drm/drm.mod.o
  CC      drivers/gpu/drm/drm_kms_helper.mod.o
  CC      drivers/gpu/drm/gma500/gma500_gfx.mod.o
  CC      drivers/gpu/drm/i915/i915.mod.o
  CC      drivers/gpu/drm/nouveau/nouveau.mod.o
  CC      drivers/gpu/drm/radeon/radeon.mod.o
  CC      drivers/gpu/drm/ttm/ttm.mod.o
  CC      drivers/gpu/drm/vmwgfx/vmwgfx.mod.o
  CC      drivers/hid/hid-a4tech.mod.o
  CC      drivers/hid/hid-apple.mod.o
  CC      drivers/hid/hid-belkin.mod.o
  CC      drivers/hid/hid-cherry.mod.o
  CC      drivers/hid/hid-chicony.mod.o
  CC      drivers/hid/hid-cypress.mod.o
  CC      drivers/hid/hid-ezkey.mod.o
  CC      drivers/hid/hid-kensington.mod.o
  CC      drivers/hid/hid-logitech.mod.o
  CC      drivers/hid/hid-kye.mod.o
  CC      drivers/hid/hid-microsoft.mod.o
  CC      drivers/hid/hid-prodikeys.mod.o
  CC      drivers/hid/hid-monterey.mod.o
  CC      drivers/hid/hid.mod.o
  CC      drivers/hid/usbhid/usbhid.mod.o
  CC      drivers/hwmon/adm1025.mod.o
  CC      drivers/hwmon/adm1026.mod.o
  CC      drivers/hwmon/adm9240.mod.o
  CC      drivers/hwmon/adt7475.mod.o
  CC      drivers/hwmon/asb100.mod.o
  CC      drivers/hwmon/atxp1.mod.o
  CC      drivers/hwmon/dme1737.mod.o
  CC      drivers/hwmon/gl520sm.mod.o
  CC      drivers/hwmon/hwmon-vid.mod.o
  CC      drivers/hwmon/it87.mod.o
  CC      drivers/hwmon/lm78.mod.o
  CC      drivers/hwmon/lm85.mod.o
  CC      drivers/hwmon/lm87.mod.o
  CC      drivers/hwmon/lm93.mod.o
  CC      drivers/hwmon/pc87360.mod.o
  CC      drivers/hwmon/smsc47m192.mod.o
  CC      drivers/hwmon/via-cputemp.mod.o
  CC      drivers/hwmon/vt8231.mod.o
  CC      drivers/hwmon/vt1211.mod.o
  CC      drivers/hwmon/w83627ehf.mod.o
  CC      drivers/hwmon/w83627hf.mod.o
  CC      drivers/hwmon/w83781d.mod.o
  CC      drivers/hwmon/w83791d.mod.o
  CC      drivers/hwmon/w83793.mod.o
  CC      drivers/i2c/algos/i2c-algo-bit.mod.o
  CC      drivers/i2c/busses/i2c-amd756.mod.o
  CC      drivers/i2c/i2c-core.mod.o
  CC      drivers/input/evdev.mod.o
  CC      drivers/input/ff-memless.mod.o
  CC      drivers/input/gameport/gameport.mod.o
  CC      drivers/input/misc/pcspkr.mod.o
  CC      drivers/input/mouse/psmouse.mod.o
  CC      drivers/input/serio/serio_raw.mod.o
  CC      drivers/md/dm-mod.mod.o
  CC      drivers/media/common/tuners/mc44s803.mod.o
  CC      drivers/media/common/tuners/mt20xx.mod.o
  CC      drivers/media/common/tuners/mt2131.mod.o
  CC      drivers/media/common/tuners/mxl5005s.mod.o
  CC      drivers/media/common/tuners/mxl5007t.mod.o
  CC      drivers/media/common/tuners/tda18271.mod.o
  CC      drivers/media/common/tuners/tda827x.mod.o
  CC      drivers/media/common/tuners/tda8290.mod.o
  CC      drivers/media/common/tuners/tda9887.mod.o
  CC      drivers/media/common/tuners/tea5761.mod.o
  CC      drivers/media/common/tuners/tea5767.mod.o
  CC      drivers/media/common/tuners/tuner-simple.mod.o
  CC      drivers/media/common/tuners/tuner-types.mod.o
  CC      drivers/media/common/tuners/tuner-xc2028.mod.o
  CC      drivers/media/common/tuners/xc4000.mod.o
  CC      drivers/media/common/tuners/xc5000.mod.o
  CC      drivers/media/dvb/bt8xx/bt878.mod.o
  CC      drivers/media/dvb/bt8xx/dst.mod.o
  CC      drivers/media/dvb/bt8xx/dst_ca.mod.o
  CC      drivers/media/dvb/bt8xx/dvb-bt8xx.mod.o
  CC      drivers/media/dvb/dvb-core/dvb-core.mod.o
  CC      drivers/media/dvb/frontends/au8522.mod.o
  CC      drivers/media/dvb/frontends/cx24110.mod.o
  CC      drivers/media/dvb/frontends/cx24116.mod.o
  CC      drivers/media/dvb/frontends/dib7000p.mod.o
  CC      drivers/media/dvb/frontends/dibx000_common.mod.o
  CC      drivers/media/dvb/frontends/ds3000.mod.o
  CC      drivers/media/dvb/frontends/lgdt330x.mod.o
  CC      drivers/media/dvb/frontends/lnbp21.mod.o
  CC      drivers/media/dvb/frontends/mt352.mod.o
  CC      drivers/media/dvb/frontends/nxt6000.mod.o
  CC      drivers/media/dvb/frontends/or51211.mod.o
  CC      drivers/media/dvb/frontends/s5h1409.mod.o
  CC      drivers/media/dvb/frontends/s5h1411.mod.o
  CC      drivers/media/dvb/frontends/sp887x.mod.o
  CC      drivers/media/dvb/frontends/stv0367.mod.o
  CC      drivers/media/dvb/frontends/stv0900.mod.o
  CC      drivers/media/dvb/frontends/stv6110.mod.o
  CC      drivers/media/dvb/frontends/tda10048.mod.o
  CC      drivers/media/dvb/frontends/tda1004x.mod.o
  CC      drivers/media/dvb/frontends/zl10353.mod.o
  CC      drivers/media/dvb/pluto2/pluto2.mod.o
  CC      drivers/media/media.mod.o
  CC      drivers/media/rc/lirc_dev.mod.o
  CC      drivers/media/rc/rc-core.mod.o
  CC      drivers/media/video/au0828/au0828.mod.o
  CC      drivers/media/video/bt8xx/bttv.mod.o
  CC      drivers/media/video/btcx-risc.mod.o
  CC      drivers/media/video/cs5345.mod.o
  CC      drivers/media/video/cs53l32a.mod.o
  CC      drivers/media/video/cx18/cx18-alsa.mod.o
  CC      drivers/media/video/cx18/cx18.mod.o
  CC      drivers/media/video/cx231xx/cx231xx-alsa.mod.o
  CC      drivers/media/video/cx231xx/cx231xx.mod.o
  CC      drivers/media/video/cx2341x.mod.o
  CC      drivers/media/video/cx23885/cx23885.mod.o
  CC      drivers/media/video/cx25821/cx25821-alsa.mod.o
  CC      drivers/media/video/cx25821/cx25821.mod.o
  CC      drivers/media/video/cx25840/cx25840.mod.o
  CC      drivers/media/video/cx88/cx88-alsa.mod.o
  CC      drivers/media/video/cx88/cx8800.mod.o
  CC      drivers/media/video/cx88/cx88xx.mod.o
  CC      drivers/media/video/em28xx/em28xx-alsa.mod.o
  CC      drivers/media/video/em28xx/em28xx.mod.o
  CC      drivers/media/video/ivtv/ivtv.mod.o
  CC      drivers/media/video/m52790.mod.o
  CC      drivers/media/video/msp3400.mod.o
  CC      drivers/media/video/saa7115.mod.o
  CC      drivers/media/video/saa7127.mod.o
  CC      drivers/media/video/saa7134/saa6752hs.mod.o
  CC      drivers/media/video/saa7134/saa7134-alsa.mod.o
  CC      drivers/media/video/saa7134/saa7134-empress.mod.o
  CC      drivers/media/video/saa7134/saa7134.mod.o
  CC      drivers/media/video/saa7164/saa7164.mod.o
  CC      drivers/media/video/saa717x.mod.o
  CC      drivers/media/video/tlg2300/poseidon.mod.o
  CC      drivers/media/video/tm6000/tm6000-alsa.mod.o
  CC      drivers/media/video/tm6000/tm6000.mod.o
  CC      drivers/media/video/tuner.mod.o
  CC      drivers/media/video/tveeprom.mod.o
  CC      drivers/media/video/upd64031a.mod.o
  CC      drivers/media/video/upd64083.mod.o
  CC      drivers/media/video/v4l2-common.mod.o
  CC      drivers/media/video/v4l2-int-device.mod.o
  CC      drivers/media/video/videobuf-core.mod.o
  CC      drivers/media/video/videobuf-dma-sg.mod.o
  CC      drivers/media/video/videobuf-dvb.mod.o
  CC      drivers/media/video/videobuf-vmalloc.mod.o
  CC      drivers/media/video/videodev.mod.o
  CC      drivers/media/video/vp27smpx.mod.o
  CC      drivers/media/video/wm8739.mod.o
  CC      drivers/media/video/wm8775.mod.o
  CC      drivers/mfd/timberdale.mod.o
  CC      drivers/misc/eeprom/eeprom_93cx6.mod.o
  CC      drivers/mtd/chips/chipreg.mod.o
  CC      drivers/mtd/maps/map_funcs.mod.o
  CC      drivers/mtd/mtd.mod.o
  CC      drivers/net/ethernet/3com/3c59x.mod.o
  CC      drivers/net/ethernet/adaptec/starfire.mod.o
  CC      drivers/net/ethernet/amd/amd8111e.mod.o
  CC      drivers/net/ethernet/amd/pcnet32.mod.o
  CC      drivers/net/ethernet/atheros/atl1c/atl1c.mod.o
  CC      drivers/net/ethernet/atheros/atl1e/atl1e.mod.o
  CC      drivers/net/ethernet/atheros/atlx/atl1.mod.o
  CC      drivers/net/ethernet/atheros/atlx/atl2.mod.o
  CC      drivers/net/ethernet/broadcom/b44.mod.o
  CC      drivers/net/ethernet/broadcom/bnx2.mod.o
  CC      drivers/net/ethernet/broadcom/cnic.mod.o
  CC      drivers/net/ethernet/chelsio/cxgb3/cxgb3.mod.o
  CC      drivers/net/ethernet/chelsio/cxgb4/cxgb4.mod.o
  CC      drivers/net/ethernet/dec/tulip/winbond-840.mod.o
  CC      drivers/net/ethernet/dlink/sundance.mod.o
  CC      drivers/net/ethernet/ethoc.mod.o
  CC      drivers/net/ethernet/fealnx.mod.o
  CC      drivers/net/ethernet/icplus/ipg.mod.o
  CC      drivers/net/ethernet/intel/e100.mod.o
  CC      drivers/net/ethernet/jme.mod.o
  CC      drivers/net/ethernet/micrel/ks8851.mod.o
  CC      drivers/net/ethernet/micrel/ks8851_mll.mod.o
  CC      drivers/net/ethernet/micrel/ksz884x.mod.o
  CC      drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.mod.o
  CC      drivers/net/ethernet/packetengines/hamachi.mod.o
  CC      drivers/net/ethernet/rdc/r6040.mod.o
  CC      drivers/net/ethernet/realtek/8139cp.mod.o
  CC      drivers/net/ethernet/realtek/8139too.mod.o
  CC      drivers/net/ethernet/realtek/r8169.mod.o
  CC      drivers/net/ethernet/sfc/sfc.mod.o
  CC      drivers/net/ethernet/sis/sis190.mod.o
  CC      drivers/net/ethernet/sis/sis900.mod.o
  CC      drivers/net/ethernet/smsc/epic100.mod.o
  CC      drivers/net/ethernet/smsc/smc91c92_cs.mod.o
  CC      drivers/net/ethernet/stmicro/stmmac/stmmac.mod.o
  CC      drivers/net/ethernet/via/via-rhine.mod.o
  CC      drivers/net/ethernet/via/via-velocity.mod.o
  CC      drivers/net/mdio.mod.o
  CC      drivers/net/mii.mod.o
  CC      drivers/net/phy/libphy.mod.o
  CC      drivers/net/ppp/ppp_deflate.mod.o
  CC      drivers/net/ppp/ppp_generic.mod.o
  CC      drivers/net/slip/slhc.mod.o
  CC      drivers/net/usb/pegasus.mod.o
  CC      drivers/net/usb/rtl8150.mod.o
  CC      drivers/net/usb/usbnet.mod.o
  CC      drivers/of/of_i2c.mod.o
  CC      drivers/of/of_mdio.mod.o
  CC      drivers/parport/parport.mod.o
  CC      drivers/pci/hotplug/pci_hotplug.mod.o
  CC      drivers/pci/hotplug/shpchp.mod.o
  CC      drivers/pcmcia/pcmcia.mod.o
  CC      drivers/pcmcia/pcmcia_core.mod.o
  CC      drivers/pcmcia/pcmcia_rsrc.mod.o
  CC      drivers/pcmcia/yenta_socket.mod.o
  CC      drivers/platform/x86/mxm-wmi.mod.o
  CC      drivers/platform/x86/thinkpad_acpi.mod.o
  CC      drivers/platform/x86/wmi.mod.o
  CC      drivers/scsi/bnx2fc/bnx2fc.mod.o
  CC      drivers/scsi/bnx2i/bnx2i.mod.o
  CC      drivers/scsi/cxgbi/cxgb3i/cxgb3i.mod.o
  CC      drivers/scsi/cxgbi/cxgb4i/cxgb4i.mod.o
  CC      drivers/scsi/cxgbi/libcxgbi.mod.o
  CC      drivers/scsi/fcoe/libfcoe.mod.o
  CC      drivers/scsi/libfc/libfc.mod.o
  CC      drivers/scsi/libiscsi.mod.o
  CC      drivers/scsi/libiscsi_tcp.mod.o
  CC      drivers/scsi/scsi_mod.mod.o
  CC      drivers/scsi/scsi_transport_fc.mod.o
  CC      drivers/scsi/scsi_transport_iscsi.mod.o
  CC      drivers/scsi/scsi_wait_scan.mod.o
  CC      drivers/scsi/sd_mod.mod.o
  CC      drivers/ssb/ssb.mod.o
  CC      drivers/staging/line6/line6usb.mod.o
  CC      drivers/staging/media/easycap/easycap.mod.o
  CC      drivers/staging/media/go7007/go7007.mod.o
  CC      drivers/staging/media/solo6x10/solo6x10.mod.o
  CC      drivers/uio/uio.mod.o
  CC      drivers/usb/core/usbcore.mod.o
  CC      drivers/usb/gadget/g_audio.mod.o
  CC      drivers/usb/gadget/g_midi.mod.o
  CC      drivers/usb/gadget/udc-core.mod.o
  CC      drivers/usb/host/ehci-hcd.mod.o
  CC      drivers/usb/host/ohci-hcd.mod.o
  CC      drivers/usb/host/uhci-hcd.mod.o
  CC      drivers/usb/misc/appledisplay.mod.o
  CC      drivers/usb/storage/uas.mod.o
  CC      drivers/usb/usb-common.mod.o
  CC      drivers/usb/storage/usb-storage.mod.o
  CC      drivers/video/fb_ddc.mod.o
  CC      drivers/video/i810/i810fb.mod.o
  CC      drivers/video/output.mod.o
  CC      drivers/video/vga16fb.mod.o
  CC      drivers/video/vgastate.mod.o
  CC      fs/btrfs/btrfs.mod.o
  CC      fs/cifs/cifs.mod.o
  CC      fs/configfs/configfs.mod.o
  CC      fs/dlm/dlm.mod.o
  CC      fs/exportfs/exportfs.mod.o
  CC      fs/ext4/ext4.mod.o
  CC      fs/fat/fat.mod.o
  CC      fs/fat/msdos.mod.o
  CC      fs/fat/vfat.mod.o
  CC      fs/fscache/fscache.mod.o
  CC      fs/fuse/fuse.mod.o
  CC      fs/gfs2/gfs2.mod.o
  CC      fs/isofs/isofs.mod.o
  CC      fs/jbd2/jbd2.mod.o
  CC      fs/jffs2/jffs2.mod.o
  CC      fs/lockd/lockd.mod.o
  CC      fs/logfs/logfs.mod.o
  CC      fs/mbcache.mod.o
  CC      fs/nfs_common/nfs_acl.mod.o
  CC      fs/nfsd/nfsd.mod.o
  CC      fs/ocfs2/cluster/ocfs2_nodemanager.mod.o
  CC      fs/ocfs2/dlmfs/ocfs2_dlmfs.mod.o
  CC      fs/ocfs2/ocfs2.mod.o
  CC      fs/ocfs2/ocfs2_stackglue.mod.o
  CC      fs/quota/quota_tree.mod.o
  CC      fs/reiserfs/reiserfs.mod.o
  CC      fs/xfs/xfs.mod.o
  CC      lib/crc-ccitt.mod.o
  CC      lib/crc-itu-t.mod.o
  CC      lib/crc16.mod.o
  CC      lib/libcrc32c.mod.o
  CC      lib/zlib_deflate/zlib_deflate.mod.o
  CC      net/ipv4/netfilter/ip_tables.mod.o
  CC      net/ipv4/netfilter/ipt_MASQUERADE.mod.o
  CC      net/ipv4/netfilter/ipt_REJECT.mod.o
  CC      net/ipv4/netfilter/iptable_filter.mod.o
  CC      net/ipv4/netfilter/iptable_mangle.mod.o
  CC      net/ipv4/netfilter/iptable_nat.mod.o
  CC      net/ipv4/netfilter/nf_conntrack_ipv4.mod.o
  CC      net/ipv4/netfilter/nf_defrag_ipv4.mod.o
  CC      net/ipv4/netfilter/nf_nat.mod.o
  CC      net/netfilter/nf_conntrack.mod.o
  CC      net/netfilter/nf_tproxy_core.mod.o
  CC      net/netfilter/x_tables.mod.o
  CC      net/netfilter/xt_TPROXY.mod.o
  CC      net/netfilter/xt_conntrack.mod.o
  CC      net/netfilter/xt_dscp.mod.o
  CC      net/netfilter/xt_mark.mod.o
  CC      net/netfilter/xt_multiport.mod.o
  CC      net/netfilter/xt_recent.mod.o
  CC      net/netfilter/xt_socket.mod.o
  CC      net/netfilter/xt_tcpudp.mod.o
  CC      net/rfkill/rfkill.mod.o
  CC      net/sctp/sctp.mod.o
  CC      net/sunrpc/auth_gss/auth_rpcgss.mod.o
  CC      net/sunrpc/sunrpc.mod.o
  CC      sound/ac97_bus.mod.o
  CC      sound/core/oss/snd-pcm-oss.mod.o
  CC      sound/core/seq/oss/snd-seq-oss.mod.o
  CC      sound/core/seq/snd-seq-device.mod.o
  CC      sound/core/seq/snd-seq-midi-emul.mod.o
  CC      sound/core/seq/snd-seq-midi-event.mod.o
  CC      sound/core/seq/snd-seq-midi.mod.o
  CC      sound/core/seq/snd-seq-virmidi.mod.o
  CC      sound/core/seq/snd-seq.mod.o
  CC      sound/core/snd-hrtimer.mod.o
  CC      sound/core/snd-hwdep.mod.o
  CC      sound/core/snd-page-alloc.mod.o
  CC      sound/core/snd-pcm.mod.o
  CC      sound/core/snd-rawmidi.mod.o
  CC      sound/core/snd-timer.mod.o
  CC      sound/core/snd.mod.o
  CC      sound/drivers/mpu401/snd-mpu401-uart.mod.o
  CC      sound/drivers/mpu401/snd-mpu401.mod.o
  CC      sound/drivers/opl3/snd-opl3-lib.mod.o
  CC      sound/drivers/opl3/snd-opl3-synth.mod.o
  CC      sound/drivers/opl4/snd-opl4-lib.mod.o
  CC      sound/drivers/opl4/snd-opl4-synth.mod.o
  CC      sound/drivers/snd-aloop.mod.o
  CC      sound/drivers/snd-dummy.mod.o
  CC      sound/drivers/snd-mtpav.mod.o
  CC      sound/drivers/snd-mts64.mod.o
  CC      sound/drivers/snd-portman2x4.mod.o
  CC      sound/drivers/snd-serial-u16550.mod.o
  CC      sound/drivers/snd-virmidi.mod.o
  CC      sound/drivers/vx/snd-vx-lib.mod.o
  CC      sound/firewire/snd-firewire-lib.mod.o
  CC      sound/firewire/snd-firewire-speakers.mod.o
  CC      sound/firewire/snd-isight.mod.o
  CC      sound/i2c/other/snd-ak4113.mod.o
  CC      sound/i2c/other/snd-ak4114.mod.o
  CC      sound/i2c/other/snd-ak4117.mod.o
  CC      sound/i2c/other/snd-ak4xxx-adda.mod.o
  CC      sound/i2c/other/snd-pt2258.mod.o
  CC      sound/i2c/other/snd-tea575x-tuner.mod.o
  CC      sound/i2c/snd-cs8427.mod.o
  CC      sound/i2c/snd-i2c.mod.o
  CC      sound/i2c/snd-tea6330t.mod.o
  CC      sound/isa/ad1816a/snd-ad1816a.mod.o
  CC      sound/isa/ad1848/snd-ad1848.mod.o
  CC      sound/isa/cs423x/snd-cs4231.mod.o
  CC      sound/isa/cs423x/snd-cs4236.mod.o
  CC      sound/isa/es1688/snd-es1688-lib.mod.o
  CC      sound/isa/es1688/snd-es1688.mod.o
  CC      sound/isa/galaxy/snd-azt2316.mod.o
  CC      sound/isa/galaxy/snd-azt1605.mod.o
  CC      sound/isa/gus/snd-gus-lib.mod.o
  CC      sound/isa/gus/snd-gusclassic.mod.o
  CC      sound/isa/gus/snd-gusextreme.mod.o
  CC      sound/isa/gus/snd-gusmax.mod.o
  CC      sound/isa/gus/snd-interwave-stb.mod.o
  CC      sound/isa/gus/snd-interwave.mod.o
  CC      sound/isa/msnd/snd-msnd-classic.mod.o
  CC      sound/isa/msnd/snd-msnd-lib.mod.o
  CC      sound/isa/msnd/snd-msnd-pinnacle.mod.o
  CC      sound/isa/opti9xx/snd-miro.mod.o
  CC      sound/isa/opti9xx/snd-opti92x-ad1848.mod.o
  CC      sound/isa/opti9xx/snd-opti92x-cs4231.mod.o
  CC      sound/isa/opti9xx/snd-opti93x.mod.o
  CC      sound/isa/sb/snd-emu8000-synth.mod.o
  CC      sound/isa/sb/snd-jazz16.mod.o
  CC      sound/isa/sb/snd-sb-common.mod.o
  CC      sound/isa/sb/snd-sb16-csp.mod.o
  CC      sound/isa/sb/snd-sb16-dsp.mod.o
  CC      sound/isa/sb/snd-sb16.mod.o
  CC      sound/isa/sb/snd-sb8-dsp.mod.o
  CC      sound/isa/sb/snd-sb8.mod.o
  CC      sound/isa/sb/snd-sbawe.mod.o
  CC      sound/isa/snd-adlib.mod.o
  CC      sound/isa/snd-als100.mod.o
  CC      sound/isa/snd-azt2320.mod.o
  CC      sound/isa/snd-cmi8330.mod.o
  CC      sound/isa/snd-es18xx.mod.o
  CC      sound/isa/snd-opl3sa2.mod.o
  CC      sound/isa/snd-sc6000.mod.o
  CC      sound/isa/snd-sscape.mod.o
  CC      sound/isa/wavefront/snd-wavefront.mod.o
  CC      sound/isa/wss/snd-wss-lib.mod.o
  CC      sound/pci/ac97/snd-ac97-codec.mod.o
  CC      sound/pci/ali5451/snd-ali5451.mod.o
  CC      sound/pci/asihpi/snd-asihpi.mod.o
  CC      sound/pci/au88x0/snd-au8810.mod.o
  CC      sound/pci/au88x0/snd-au8820.mod.o
  CC      sound/pci/au88x0/snd-au8830.mod.o
  CC      sound/pci/ca0106/snd-ca0106.mod.o
  CC      sound/pci/cs46xx/snd-cs46xx.mod.o
  CC      sound/pci/cs5535audio/snd-cs5535audio.mod.o
  CC      sound/pci/ctxfi/snd-ctxfi.mod.o
  CC      sound/pci/echoaudio/snd-darla20.mod.o
  CC      sound/pci/echoaudio/snd-darla24.mod.o
  CC      sound/pci/echoaudio/snd-echo3g.mod.o
  CC      sound/pci/echoaudio/snd-gina20.mod.o
  CC      sound/pci/echoaudio/snd-gina24.mod.o
  CC      sound/pci/echoaudio/snd-indigo.mod.o
  CC      sound/pci/echoaudio/snd-indigodj.mod.o
  CC      sound/pci/echoaudio/snd-indigodjx.mod.o
  CC      sound/pci/echoaudio/snd-indigoio.mod.o
  CC      sound/pci/echoaudio/snd-indigoiox.mod.o
  CC      sound/pci/echoaudio/snd-layla20.mod.o
  CC      sound/pci/echoaudio/snd-layla24.mod.o
  CC      sound/pci/echoaudio/snd-mia.mod.o
  CC      sound/pci/echoaudio/snd-mona.mod.o
  CC      sound/pci/emu10k1/snd-emu10k1-synth.mod.o
  CC      sound/pci/emu10k1/snd-emu10k1.mod.o
  CC      sound/pci/emu10k1/snd-emu10k1x.mod.o
  CC      sound/pci/hda/snd-hda-codec-analog.mod.o
  CC      sound/pci/hda/snd-hda-codec-ca0110.mod.o
  CC      sound/pci/hda/snd-hda-codec-ca0132.mod.o
  CC      sound/pci/hda/snd-hda-codec-cirrus.mod.o
  CC      sound/pci/hda/snd-hda-codec-cmedia.mod.o
  CC      sound/pci/hda/snd-hda-codec-conexant.mod.o
  CC      sound/pci/hda/snd-hda-codec-hdmi.mod.o
  CC      sound/pci/hda/snd-hda-codec-idt.mod.o
  CC      sound/pci/hda/snd-hda-codec-realtek.mod.o
  CC      sound/pci/hda/snd-hda-codec-si3054.mod.o
  CC      sound/pci/hda/snd-hda-codec-via.mod.o
  CC      sound/pci/hda/snd-hda-codec.mod.o
  CC      sound/pci/hda/snd-hda-intel.mod.o
  CC      sound/pci/ice1712/snd-ice1712.mod.o
  CC      sound/pci/ice1712/snd-ice1724.mod.o
  CC      sound/pci/ice1712/snd-ice17xx-ak4xxx.mod.o
  CC      sound/pci/korg1212/snd-korg1212.mod.o
  CC      sound/pci/lola/snd-lola.mod.o
  CC      sound/pci/lx6464es/snd-lx6464es.mod.o
  CC      sound/pci/mixart/snd-mixart.mod.o
  CC      sound/pci/nm256/snd-nm256.mod.o
  CC      sound/pci/oxygen/snd-oxygen-lib.mod.o
  CC      sound/pci/oxygen/snd-oxygen.mod.o
  CC      sound/pci/oxygen/snd-virtuoso.mod.o
  CC      sound/pci/pcxhr/snd-pcxhr.mod.o
  CC      sound/pci/riptide/snd-riptide.mod.o
  CC      sound/pci/rme9652/snd-hdsp.mod.o
  CC      sound/pci/rme9652/snd-hdspm.mod.o
  CC      sound/pci/rme9652/snd-rme9652.mod.o
  CC      sound/pci/snd-ad1889.mod.o
  CC      sound/pci/snd-als300.mod.o
  CC      sound/pci/snd-als4000.mod.o
  CC      sound/pci/snd-atiixp-modem.mod.o
  CC      sound/pci/snd-atiixp.mod.o
  CC      sound/pci/snd-azt3328.mod.o
  CC      sound/pci/snd-bt87x.mod.o
  CC      sound/pci/snd-cmipci.mod.o
  CC      sound/pci/snd-cs4281.mod.o
  CC      sound/pci/snd-cs5530.mod.o
  CC      sound/pci/snd-ens1370.mod.o
  CC      sound/pci/snd-ens1371.mod.o
  CC      sound/pci/snd-es1938.mod.o
  CC      sound/pci/snd-es1968.mod.o
  CC      sound/pci/snd-fm801.mod.o
  CC      sound/pci/snd-intel8x0.mod.o
  CC      sound/pci/snd-intel8x0m.mod.o
  CC      sound/pci/snd-maestro3.mod.o
  CC      sound/pci/snd-rme32.mod.o
  CC      sound/pci/snd-rme96.mod.o
  CC      sound/pci/snd-sis7019.mod.o
  CC      sound/pci/snd-sonicvibes.mod.o
  CC      sound/pci/snd-via82xx-modem.mod.o
  CC      sound/pci/snd-via82xx.mod.o
  CC      sound/pci/trident/snd-trident.mod.o
  CC      sound/pci/vx222/snd-vx222.mod.o
  CC      sound/pci/ymfpci/snd-ymfpci.mod.o
  CC      sound/pcmcia/pdaudiocf/snd-pdaudiocf.mod.o
  CC      sound/pcmcia/vx/snd-vxpocket.mod.o
  CC      sound/soc/snd-soc-core.mod.o
  CC      sound/soundcore.mod.o
  CC      sound/synth/emux/snd-emux-synth.mod.o
  CC      sound/synth/snd-util-mem.mod.o
  CC      sound/usb/6fire/snd-usb-6fire.mod.o
  CC      sound/usb/caiaq/snd-usb-caiaq.mod.o
  CC      sound/usb/misc/snd-ua101.mod.o
  CC      sound/usb/snd-usb-audio.mod.o
  CC      sound/usb/snd-usbmidi-lib.mod.o
  CC      sound/usb/usx2y/snd-usb-us122l.mod.o
  CC      sound/usb/usx2y/snd-usb-usx2y.mod.o
  LD [M]  crypto/arc4.ko
  LD [M]  crypto/crc32c.ko
  LD [M]  crypto/deflate.ko
  LD [M]  crypto/des_generic.ko
  LD [M]  crypto/ecb.ko
  LD [M]  crypto/hmac.ko
  LD [M]  crypto/md4.ko
  LD [M]  crypto/md5.ko
  LD [M]  crypto/sha1_generic.ko
  LD [M]  crypto/zlib.ko
  LD [M]  drivers/acpi/button.ko
  LD [M]  drivers/acpi/container.ko
  LD [M]  drivers/acpi/processor.ko
  LD [M]  drivers/acpi/video.ko
  LD [M]  drivers/ata/ata_generic.ko
  LD [M]  drivers/ata/libata.ko
  LD [M]  drivers/ata/pata_acpi.ko
  LD [M]  drivers/ata/pata_amd.ko
  LD [M]  drivers/ata/pata_arasan_cf.ko
  LD [M]  drivers/base/regmap/regmap-i2c.ko
  LD [M]  drivers/block/floppy.ko
  LD [M]  drivers/block/loop.ko
  LD [M]  drivers/char/agp/agpgart.ko
  LD [M]  drivers/char/agp/amd-k7-agp.ko
  LD [M]  drivers/char/agp/intel-gtt.ko
  LD [M]  drivers/char/agp/intel-agp.ko
  LD [M]  drivers/char/hw_random/amd-rng.ko
  LD [M]  drivers/char/nvram.ko
  LD [M]  drivers/dca/dca.ko
  LD [M]  drivers/dma/intel_mid_dma.ko
  LD [M]  drivers/dma/pch_dma.ko
  LD [M]  drivers/dma/ioat/ioatdma.ko
  LD [M]  drivers/dma/timb_dma.ko
  LD [M]  drivers/edac/amd76x_edac.ko
  LD [M]  drivers/edac/edac_core.ko
  LD [M]  drivers/firewire/firewire-core.ko
  LD [M]  drivers/gpu/drm/drm.ko
  LD [M]  drivers/gpu/drm/gma500/gma500_gfx.ko
  LD [M]  drivers/gpu/drm/drm_kms_helper.ko
  LD [M]  drivers/gpu/drm/i915/i915.ko
  LD [M]  drivers/gpu/drm/nouveau/nouveau.ko
  LD [M]  drivers/gpu/drm/ttm/ttm.ko
  LD [M]  drivers/gpu/drm/radeon/radeon.ko
  LD [M]  drivers/gpu/drm/vmwgfx/vmwgfx.ko
  LD [M]  drivers/hid/hid-a4tech.ko
  LD [M]  drivers/hid/hid-apple.ko
  LD [M]  drivers/hid/hid-belkin.ko
  LD [M]  drivers/hid/hid-cherry.ko
  LD [M]  drivers/hid/hid-chicony.ko
  LD [M]  drivers/hid/hid-cypress.ko
  LD [M]  drivers/hid/hid-ezkey.ko
  LD [M]  drivers/hid/hid-kensington.ko
  LD [M]  drivers/hid/hid-kye.ko
  LD [M]  drivers/hid/hid-logitech.ko
  LD [M]  drivers/hid/hid-microsoft.ko
  LD [M]  drivers/hid/hid-monterey.ko
  LD [M]  drivers/hid/hid-prodikeys.ko
  LD [M]  drivers/hid/hid.ko
  LD [M]  drivers/hwmon/adm1025.ko
  LD [M]  drivers/hwmon/adm1026.ko
  LD [M]  drivers/hwmon/adm9240.ko
  LD [M]  drivers/hwmon/adt7475.ko
  LD [M]  drivers/hwmon/asb100.ko
  LD [M]  drivers/hwmon/atxp1.ko
  LD [M]  drivers/hwmon/dme1737.ko
  LD [M]  drivers/hwmon/gl520sm.ko
  LD [M]  drivers/hwmon/hwmon-vid.ko
  LD [M]  drivers/hwmon/it87.ko
  LD [M]  drivers/hwmon/lm78.ko
  LD [M]  drivers/hwmon/lm85.ko
  LD [M]  drivers/hwmon/lm87.ko
  LD [M]  drivers/hwmon/lm93.ko
  LD [M]  drivers/hwmon/pc87360.ko
  LD [M]  drivers/hwmon/smsc47m192.ko
  LD [M]  drivers/hwmon/via-cputemp.ko
  LD [M]  drivers/hwmon/vt1211.ko
  LD [M]  drivers/hwmon/vt8231.ko
  LD [M]  drivers/hwmon/w83627ehf.ko
  LD [M]  drivers/hwmon/w83781d.ko
  LD [M]  drivers/hwmon/w83627hf.ko
  LD [M]  drivers/hwmon/w83791d.ko
  LD [M]  drivers/hwmon/w83793.ko
  LD [M]  drivers/i2c/algos/i2c-algo-bit.ko
  LD [M]  drivers/i2c/i2c-core.ko
  LD [M]  drivers/i2c/busses/i2c-amd756.ko
  LD [M]  drivers/input/evdev.ko
  LD [M]  drivers/input/ff-memless.ko
  LD [M]  drivers/input/gameport/gameport.ko
  LD [M]  drivers/input/misc/pcspkr.ko
  LD [M]  drivers/input/mouse/psmouse.ko
  LD [M]  drivers/input/serio/serio_raw.ko
  LD [M]  drivers/md/dm-mod.ko
  LD [M]  drivers/media/common/tuners/mc44s803.ko
  LD [M]  drivers/media/common/tuners/mt20xx.ko
  LD [M]  drivers/media/common/tuners/mt2131.ko
  LD [M]  drivers/media/common/tuners/mxl5005s.ko
  LD [M]  drivers/media/common/tuners/mxl5007t.ko
  LD [M]  drivers/media/common/tuners/tda827x.ko
  LD [M]  drivers/media/common/tuners/tda18271.ko
  LD [M]  drivers/media/common/tuners/tda8290.ko
  LD [M]  drivers/media/common/tuners/tda9887.ko
  LD [M]  drivers/media/common/tuners/tea5761.ko
  LD [M]  drivers/media/common/tuners/tea5767.ko
  LD [M]  drivers/media/common/tuners/tuner-simple.ko
  LD [M]  drivers/media/common/tuners/tuner-xc2028.ko
  LD [M]  drivers/media/common/tuners/tuner-types.ko
  LD [M]  drivers/media/common/tuners/xc4000.ko
  LD [M]  drivers/media/common/tuners/xc5000.ko
  LD [M]  drivers/media/dvb/bt8xx/dst.ko
  LD [M]  drivers/media/dvb/bt8xx/bt878.ko
  LD [M]  drivers/media/dvb/bt8xx/dst_ca.ko
  LD [M]  drivers/media/dvb/bt8xx/dvb-bt8xx.ko
  LD [M]  drivers/media/dvb/frontends/au8522.ko
  LD [M]  drivers/media/dvb/dvb-core/dvb-core.ko
  LD [M]  drivers/media/dvb/frontends/cx24110.ko
  LD [M]  drivers/media/dvb/frontends/cx24116.ko
  LD [M]  drivers/media/dvb/frontends/dib7000p.ko
  LD [M]  drivers/media/dvb/frontends/dibx000_common.ko
  LD [M]  drivers/media/dvb/frontends/lgdt330x.ko
  LD [M]  drivers/media/dvb/frontends/ds3000.ko
  LD [M]  drivers/media/dvb/frontends/mt352.ko
  LD [M]  drivers/media/dvb/frontends/nxt6000.ko
  LD [M]  drivers/media/dvb/frontends/or51211.ko
  LD [M]  drivers/media/dvb/frontends/s5h1409.ko
  LD [M]  drivers/media/dvb/frontends/s5h1411.ko
  LD [M]  drivers/media/dvb/frontends/sp887x.ko
  LD [M]  drivers/media/dvb/frontends/stv0367.ko
  LD [M]  drivers/media/dvb/frontends/stv0900.ko
  LD [M]  drivers/media/dvb/frontends/stv6110.ko
  LD [M]  drivers/media/dvb/frontends/tda10048.ko
  LD [M]  drivers/media/dvb/frontends/zl10353.ko
  LD [M]  drivers/media/dvb/frontends/tda1004x.ko
  LD [M]  drivers/media/dvb/pluto2/pluto2.ko
  LD [M]  drivers/media/media.ko
  LD [M]  drivers/media/rc/rc-core.ko
  LD [M]  drivers/media/rc/lirc_dev.ko
  LD [M]  drivers/media/video/au0828/au0828.ko
  LD [M]  drivers/media/video/bt8xx/bttv.ko
  LD [M]  drivers/media/video/cs5345.ko
  LD [M]  drivers/media/video/btcx-risc.ko
  LD [M]  drivers/media/video/cs53l32a.ko
  LD [M]  drivers/media/video/cx18/cx18-alsa.ko
  LD [M]  drivers/media/video/cx18/cx18.ko
  LD [M]  drivers/media/video/cx231xx/cx231xx-alsa.ko
  LD [M]  drivers/media/video/cx231xx/cx231xx.ko
  LD [M]  drivers/media/video/cx23885/cx23885.ko
  LD [M]  drivers/media/video/cx2341x.ko
  LD [M]  drivers/media/video/cx25821/cx25821.ko
  LD [M]  drivers/media/video/cx25821/cx25821-alsa.ko
  LD [M]  drivers/media/video/cx25840/cx25840.ko
  LD [M]  drivers/media/video/cx88/cx88-alsa.ko
  LD [M]  drivers/media/video/cx88/cx88xx.ko
  LD [M]  drivers/media/video/cx88/cx8800.ko
  LD [M]  drivers/media/video/em28xx/em28xx-alsa.ko
  LD [M]  drivers/media/video/ivtv/ivtv.ko
  LD [M]  drivers/media/video/em28xx/em28xx.ko
  LD [M]  drivers/media/video/m52790.ko
  LD [M]  drivers/media/video/saa7115.ko
  LD [M]  drivers/media/video/msp3400.ko
  LD [M]  drivers/media/video/saa7127.ko
  LD [M]  drivers/media/video/saa7134/saa7134-alsa.ko
  LD [M]  drivers/media/video/saa7134/saa6752hs.ko
  LD [M]  drivers/media/video/saa7134/saa7134-empress.ko
  LD [M]  drivers/media/video/saa7134/saa7134.ko
  LD [M]  drivers/media/video/saa7164/saa7164.ko
  LD [M]  drivers/media/video/saa717x.ko
  LD [M]  drivers/media/video/tlg2300/poseidon.ko
  LD [M]  drivers/media/video/tm6000/tm6000-alsa.ko
  LD [M]  drivers/media/video/tm6000/tm6000.ko
  LD [M]  drivers/media/video/tuner.ko
  LD [M]  drivers/media/video/tveeprom.ko
  LD [M]  drivers/media/video/upd64083.ko
  LD [M]  drivers/media/video/upd64031a.ko
  LD [M]  drivers/media/video/v4l2-common.ko
  LD [M]  drivers/media/video/v4l2-int-device.ko
  LD [M]  drivers/media/video/videobuf-core.ko
  LD [M]  drivers/media/video/videobuf-dma-sg.ko
  LD [M]  drivers/media/video/videobuf-dvb.ko
  LD [M]  drivers/media/video/videobuf-vmalloc.ko
  LD [M]  drivers/media/video/videodev.ko
  LD [M]  drivers/media/video/vp27smpx.ko
  LD [M]  drivers/media/video/wm8775.ko
  LD [M]  drivers/media/video/wm8739.ko
  LD [M]  drivers/mfd/timberdale.ko
  LD [M]  drivers/mtd/chips/chipreg.ko
  LD [M]  drivers/misc/eeprom/eeprom_93cx6.ko
  LD [M]  drivers/mtd/maps/map_funcs.ko
  LD [M]  drivers/mtd/mtd.ko
  LD [M]  drivers/net/ethernet/3com/3c59x.ko
  LD [M]  drivers/net/ethernet/adaptec/starfire.ko
  LD [M]  drivers/net/ethernet/amd/amd8111e.ko
  LD [M]  drivers/net/ethernet/amd/pcnet32.ko
  LD [M]  drivers/net/ethernet/atheros/atl1c/atl1c.ko
  LD [M]  drivers/net/ethernet/atheros/atl1e/atl1e.ko
  LD [M]  drivers/net/ethernet/atheros/atlx/atl1.ko
  LD [M]  drivers/net/ethernet/broadcom/b44.ko
  LD [M]  drivers/net/ethernet/atheros/atlx/atl2.ko
  LD [M]  drivers/net/ethernet/broadcom/bnx2.ko
  LD [M]  drivers/net/ethernet/chelsio/cxgb3/cxgb3.ko
  LD [M]  drivers/net/ethernet/broadcom/cnic.ko
  LD [M]  drivers/net/ethernet/chelsio/cxgb4/cxgb4.ko
  LD [M]  drivers/net/ethernet/dec/tulip/winbond-840.ko
  LD [M]  drivers/net/ethernet/dlink/sundance.ko
  LD [M]  drivers/net/ethernet/fealnx.ko
  LD [M]  drivers/net/ethernet/icplus/ipg.ko
  LD [M]  drivers/net/ethernet/intel/e100.ko
  LD [M]  drivers/net/ethernet/jme.ko
  LD [M]  drivers/net/ethernet/micrel/ks8851.ko
  LD [M]  drivers/net/ethernet/micrel/ks8851_mll.ko
  LD [M]  drivers/net/ethernet/micrel/ksz884x.ko
  LD [M]  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.ko
  LD [M]  drivers/net/ethernet/packetengines/hamachi.ko
  LD [M]  drivers/net/ethernet/rdc/r6040.ko
  LD [M]  drivers/net/ethernet/realtek/8139cp.ko
  LD [M]  drivers/net/ethernet/realtek/8139too.ko
  LD [M]  drivers/net/ethernet/realtek/r8169.ko
  LD [M]  drivers/net/ethernet/sfc/sfc.ko
  LD [M]  drivers/net/ethernet/sis/sis190.ko
  LD [M]  drivers/net/ethernet/sis/sis900.ko
  LD [M]  drivers/net/ethernet/smsc/epic100.ko
  LD [M]  drivers/net/ethernet/smsc/smc91c92_cs.ko
  LD [M]  drivers/net/ethernet/via/via-rhine.ko
  LD [M]  drivers/net/ethernet/stmicro/stmmac/stmmac.ko
  LD [M]  drivers/net/ethernet/via/via-velocity.ko
  LD [M]  drivers/net/mdio.ko
  LD [M]  drivers/net/mii.ko
  LD [M]  drivers/net/ppp/ppp_deflate.ko
  LD [M]  drivers/net/phy/libphy.ko
  LD [M]  drivers/net/ppp/ppp_generic.ko
  LD [M]  drivers/net/usb/pegasus.ko
  LD [M]  drivers/net/slip/slhc.ko
  LD [M]  drivers/net/usb/rtl8150.ko
  LD [M]  drivers/net/usb/usbnet.ko
  LD [M]  drivers/of/of_i2c.ko
  LD [M]  drivers/of/of_mdio.ko
  LD [M]  drivers/parport/parport.ko
  LD [M]  drivers/pci/hotplug/pci_hotplug.ko
  LD [M]  drivers/pci/hotplug/shpchp.ko
  LD [M]  drivers/pcmcia/pcmcia.ko
  LD [M]  drivers/pcmcia/pcmcia_core.ko
  LD [M]  drivers/pcmcia/pcmcia_rsrc.ko
  LD [M]  drivers/pcmcia/yenta_socket.ko
  LD [M]  drivers/platform/x86/mxm-wmi.ko
  LD [M]  drivers/platform/x86/thinkpad_acpi.ko
  LD [M]  drivers/platform/x86/wmi.ko
  LD [M]  drivers/scsi/bnx2fc/bnx2fc.ko
  LD [M]  drivers/scsi/cxgbi/cxgb4i/cxgb4i.ko
  LD [M]  drivers/scsi/cxgbi/libcxgbi.ko
  LD [M]  drivers/scsi/libfc/libfc.ko
  LD [M]  drivers/scsi/fcoe/libfcoe.ko
  LD [M]  drivers/scsi/libiscsi.ko
  LD [M]  drivers/scsi/libiscsi_tcp.ko
  LD [M]  drivers/scsi/scsi_mod.ko
  LD [M]  drivers/scsi/scsi_transport_fc.ko
  LD [M]  drivers/scsi/scsi_transport_iscsi.ko
  LD [M]  drivers/scsi/scsi_wait_scan.ko
  LD [M]  drivers/scsi/sd_mod.ko
  LD [M]  drivers/ssb/ssb.ko
  LD [M]  drivers/staging/line6/line6usb.ko
  LD [M]  drivers/staging/media/go7007/go7007.ko
  LD [M]  drivers/staging/media/solo6x10/solo6x10.ko
  LD [M]  drivers/uio/uio.ko
  LD [M]  drivers/usb/core/usbcore.ko
  LD [M]  drivers/usb/gadget/g_midi.ko
  LD [M]  drivers/usb/gadget/g_audio.ko
  LD [M]  drivers/usb/gadget/udc-core.ko
  LD [M]  drivers/usb/host/ehci-hcd.ko
  LD [M]  drivers/usb/host/uhci-hcd.ko
  LD [M]  drivers/usb/host/ohci-hcd.ko
  LD [M]  drivers/usb/misc/appledisplay.ko
  LD [M]  drivers/usb/storage/uas.ko
  LD [M]  drivers/usb/storage/usb-storage.ko
  LD [M]  drivers/video/fb_ddc.ko
  LD [M]  drivers/usb/usb-common.ko
  LD [M]  drivers/video/i810/i810fb.ko
  LD [M]  drivers/video/output.ko
  LD [M]  drivers/video/vga16fb.ko
  LD [M]  fs/btrfs/btrfs.ko
  LD [M]  drivers/video/vgastate.ko
  LD [M]  fs/cifs/cifs.ko
  LD [M]  fs/configfs/configfs.ko
  LD [M]  fs/dlm/dlm.ko
  LD [M]  fs/exportfs/exportfs.ko
  LD [M]  fs/ext4/ext4.ko
  LD [M]  fs/fat/msdos.ko
  LD [M]  fs/fat/fat.ko
  LD [M]  fs/fat/vfat.ko
  LD [M]  fs/fscache/fscache.ko
  LD [M]  fs/fuse/fuse.ko
  LD [M]  fs/gfs2/gfs2.ko
  LD [M]  fs/isofs/isofs.ko
  LD [M]  fs/jbd2/jbd2.ko
  LD [M]  fs/jffs2/jffs2.ko
  LD [M]  fs/lockd/lockd.ko
  LD [M]  fs/logfs/logfs.ko
  LD [M]  fs/mbcache.ko
  LD [M]  fs/nfsd/nfsd.ko
  LD [M]  fs/nfs_common/nfs_acl.ko
  LD [M]  fs/ocfs2/cluster/ocfs2_nodemanager.ko
  LD [M]  fs/ocfs2/dlmfs/ocfs2_dlmfs.ko
  LD [M]  fs/ocfs2/ocfs2.ko
  LD [M]  fs/ocfs2/ocfs2_stackglue.ko
  LD [M]  fs/quota/quota_tree.ko
  LD [M]  fs/reiserfs/reiserfs.ko
  LD [M]  lib/crc-ccitt.ko
  LD [M]  lib/crc-itu-t.ko
  LD [M]  lib/crc16.ko
  LD [M]  lib/libcrc32c.ko
  LD [M]  lib/zlib_deflate/zlib_deflate.ko
  LD [M]  net/ipv4/netfilter/ip_tables.ko
  LD [M]  net/ipv4/netfilter/ipt_MASQUERADE.ko
  LD [M]  net/ipv4/netfilter/ipt_REJECT.ko
  LD [M]  net/ipv4/netfilter/iptable_mangle.ko
  LD [M]  net/ipv4/netfilter/iptable_filter.ko
  LD [M]  net/ipv4/netfilter/nf_conntrack_ipv4.ko
  LD [M]  net/ipv4/netfilter/iptable_nat.ko
  LD [M]  net/ipv4/netfilter/nf_defrag_ipv4.ko
  LD [M]  net/ipv4/netfilter/nf_nat.ko
  LD [M]  net/netfilter/nf_tproxy_core.ko
  LD [M]  net/netfilter/nf_conntrack.ko
  LD [M]  net/netfilter/x_tables.ko
  LD [M]  net/netfilter/xt_TPROXY.ko
  LD [M]  net/netfilter/xt_conntrack.ko
  LD [M]  net/netfilter/xt_dscp.ko
  LD [M]  net/netfilter/xt_mark.ko
  LD [M]  net/netfilter/xt_multiport.ko
  LD [M]  net/netfilter/xt_recent.ko
  LD [M]  net/netfilter/xt_tcpudp.ko
  LD [M]  net/netfilter/xt_socket.ko
  LD [M]  net/rfkill/rfkill.ko
  LD [M]  net/sctp/sctp.ko
  LD [M]  net/sunrpc/auth_gss/auth_rpcgss.ko
  LD [M]  net/sunrpc/sunrpc.ko
  LD [M]  sound/ac97_bus.ko
  LD [M]  sound/core/oss/snd-pcm-oss.ko
  LD [M]  sound/core/seq/oss/snd-seq-oss.ko
  LD [M]  sound/core/seq/snd-seq-midi-emul.ko
  LD [M]  sound/core/seq/snd-seq-device.ko
  LD [M]  sound/core/seq/snd-seq-midi-event.ko
  LD [M]  sound/core/seq/snd-seq-midi.ko
  LD [M]  sound/core/seq/snd-seq.ko
  LD [M]  sound/core/seq/snd-seq-virmidi.ko
  LD [M]  sound/core/snd-hrtimer.ko
  LD [M]  sound/core/snd-page-alloc.ko
  LD [M]  sound/core/snd-hwdep.ko
  LD [M]  sound/core/snd-pcm.ko
  LD [M]  sound/core/snd-rawmidi.ko
  LD [M]  sound/core/snd-timer.ko
  LD [M]  sound/drivers/mpu401/snd-mpu401-uart.ko
  LD [M]  sound/core/snd.ko
  LD [M]  sound/drivers/mpu401/snd-mpu401.ko
  LD [M]  sound/drivers/opl3/snd-opl3-lib.ko
  LD [M]  sound/drivers/opl3/snd-opl3-synth.ko
  LD [M]  sound/drivers/opl4/snd-opl4-synth.ko
  LD [M]  sound/drivers/opl4/snd-opl4-lib.ko
  LD [M]  sound/drivers/snd-aloop.ko
  LD [M]  sound/drivers/snd-dummy.ko
  LD [M]  sound/drivers/snd-mtpav.ko
  LD [M]  sound/drivers/snd-mts64.ko
  LD [M]  sound/drivers/snd-portman2x4.ko
  LD [M]  sound/drivers/vx/snd-vx-lib.ko
  LD [M]  sound/firewire/snd-firewire-lib.ko
  LD [M]  sound/firewire/snd-firewire-speakers.ko
  LD [M]  sound/firewire/snd-isight.ko
  LD [M]  sound/i2c/other/snd-ak4113.ko
  LD [M]  sound/i2c/other/snd-ak4114.ko
  LD [M]  sound/i2c/other/snd-ak4117.ko
  LD [M]  sound/i2c/other/snd-pt2258.ko
  LD [M]  sound/i2c/other/snd-ak4xxx-adda.ko
  LD [M]  sound/i2c/other/snd-tea575x-tuner.ko
  LD [M]  sound/i2c/snd-cs8427.ko
  LD [M]  sound/i2c/snd-i2c.ko
  LD [M]  sound/i2c/snd-tea6330t.ko
  LD [M]  sound/isa/ad1816a/snd-ad1816a.ko
  LD [M]  sound/isa/cs423x/snd-cs4231.ko
  LD [M]  sound/isa/ad1848/snd-ad1848.ko
  LD [M]  sound/isa/es1688/snd-es1688-lib.ko
  LD [M]  sound/isa/cs423x/snd-cs4236.ko
  LD [M]  sound/isa/es1688/snd-es1688.ko
  LD [M]  sound/isa/galaxy/snd-azt1605.ko
  LD [M]  sound/isa/galaxy/snd-azt2316.ko
  LD [M]  sound/isa/gus/snd-gus-lib.ko
  LD [M]  sound/isa/gus/snd-gusclassic.ko
  LD [M]  sound/isa/gus/snd-gusextreme.ko
  LD [M]  sound/isa/gus/snd-gusmax.ko
  LD [M]  sound/isa/gus/snd-interwave.ko
  LD [M]  sound/isa/gus/snd-interwave-stb.ko
  LD [M]  sound/isa/msnd/snd-msnd-classic.ko
  LD [M]  sound/isa/msnd/snd-msnd-lib.ko
  LD [M]  sound/isa/msnd/snd-msnd-pinnacle.ko
  LD [M]  sound/isa/opti9xx/snd-miro.ko
  LD [M]  sound/isa/opti9xx/snd-opti92x-cs4231.ko
  LD [M]  sound/isa/opti9xx/snd-opti92x-ad1848.ko
  LD [M]  sound/isa/opti9xx/snd-opti93x.ko
  LD [M]  sound/isa/sb/snd-emu8000-synth.ko
  LD [M]  sound/isa/sb/snd-jazz16.ko
  LD [M]  sound/isa/sb/snd-sb-common.ko
  LD [M]  sound/isa/sb/snd-sb16-csp.ko
  LD [M]  sound/isa/sb/snd-sb16-dsp.ko
  LD [M]  sound/isa/sb/snd-sb8-dsp.ko
  LD [M]  sound/isa/sb/snd-sb16.ko
  LD [M]  sound/isa/sb/snd-sb8.ko
  LD [M]  sound/isa/sb/snd-sbawe.ko
  LD [M]  sound/isa/snd-adlib.ko
  LD [M]  sound/isa/snd-als100.ko
  LD [M]  sound/isa/snd-cmi8330.ko
  LD [M]  sound/isa/snd-azt2320.ko
  LD [M]  sound/isa/snd-opl3sa2.ko
  LD [M]  sound/isa/snd-sc6000.ko
  LD [M]  sound/isa/snd-sscape.ko
  LD [M]  sound/isa/wss/snd-wss-lib.ko
  LD [M]  sound/pci/ac97/snd-ac97-codec.ko
  LD [M]  sound/isa/wavefront/snd-wavefront.ko
  LD [M]  sound/pci/ali5451/snd-ali5451.ko
  LD [M]  sound/pci/asihpi/snd-asihpi.ko
  LD [M]  sound/pci/au88x0/snd-au8810.ko
  LD [M]  sound/pci/au88x0/snd-au8820.ko
  LD [M]  sound/pci/au88x0/snd-au8830.ko
  LD [M]  sound/pci/ca0106/snd-ca0106.ko
  LD [M]  sound/pci/cs46xx/snd-cs46xx.ko
  LD [M]  sound/pci/cs5535audio/snd-cs5535audio.ko
  LD [M]  sound/pci/ctxfi/snd-ctxfi.ko
  LD [M]  sound/pci/echoaudio/snd-darla20.ko
  LD [M]  sound/pci/echoaudio/snd-darla24.ko
  LD [M]  sound/pci/echoaudio/snd-echo3g.ko
  LD [M]  sound/pci/echoaudio/snd-gina20.ko
  LD [M]  sound/pci/echoaudio/snd-gina24.ko
  LD [M]  sound/pci/echoaudio/snd-indigo.ko
  LD [M]  sound/pci/echoaudio/snd-indigodj.ko
  LD [M]  sound/pci/echoaudio/snd-indigodjx.ko
  LD [M]  sound/pci/echoaudio/snd-indigoio.ko
  LD [M]  sound/pci/echoaudio/snd-indigoiox.ko
  LD [M]  sound/pci/echoaudio/snd-layla20.ko
  LD [M]  sound/pci/echoaudio/snd-layla24.ko
  LD [M]  sound/pci/echoaudio/snd-mona.ko
  LD [M]  sound/pci/echoaudio/snd-mia.ko
  LD [M]  sound/pci/emu10k1/snd-emu10k1-synth.ko
  LD [M]  sound/pci/emu10k1/snd-emu10k1.ko
  LD [M]  sound/pci/emu10k1/snd-emu10k1x.ko
  LD [M]  sound/pci/hda/snd-hda-codec-analog.ko
  LD [M]  sound/pci/hda/snd-hda-codec-ca0110.ko
  LD [M]  sound/pci/hda/snd-hda-codec-ca0132.ko
  LD [M]  sound/pci/hda/snd-hda-codec-cirrus.ko
  LD [M]  sound/pci/hda/snd-hda-codec-cmedia.ko
  LD [M]  sound/pci/hda/snd-hda-codec-conexant.ko
  LD [M]  sound/pci/hda/snd-hda-codec-hdmi.ko
  LD [M]  sound/pci/hda/snd-hda-codec-idt.ko
  LD [M]  sound/pci/hda/snd-hda-codec-realtek.ko
  LD [M]  sound/pci/hda/snd-hda-codec-via.ko
  LD [M]  sound/pci/hda/snd-hda-codec-si3054.ko
  LD [M]  sound/pci/hda/snd-hda-codec.ko
  LD [M]  sound/pci/hda/snd-hda-intel.ko
  LD [M]  sound/pci/ice1712/snd-ice1712.ko
  LD [M]  sound/pci/ice1712/snd-ice1724.ko
  LD [M]  sound/pci/ice1712/snd-ice17xx-ak4xxx.ko
  LD [M]  sound/pci/korg1212/snd-korg1212.ko
  LD [M]  sound/pci/lola/snd-lola.ko
  LD [M]  sound/pci/lx6464es/snd-lx6464es.ko
  LD [M]  sound/pci/mixart/snd-mixart.ko
  LD [M]  sound/pci/nm256/snd-nm256.ko
  LD [M]  sound/pci/oxygen/snd-oxygen-lib.ko
  LD [M]  sound/pci/oxygen/snd-oxygen.ko
  LD [M]  sound/pci/oxygen/snd-virtuoso.ko
  LD [M]  sound/pci/pcxhr/snd-pcxhr.ko
  LD [M]  sound/pci/riptide/snd-riptide.ko
  LD [M]  sound/pci/rme9652/snd-hdspm.ko
  LD [M]  sound/pci/rme9652/snd-hdsp.ko
  LD [M]  sound/pci/rme9652/snd-rme9652.ko
  LD [M]  sound/pci/snd-ad1889.ko
  LD [M]  sound/pci/snd-als300.ko
  LD [M]  sound/pci/snd-als4000.ko
  LD [M]  sound/pci/snd-azt3328.ko
  LD [M]  sound/pci/snd-cmipci.ko
  LD [M]  sound/pci/snd-bt87x.ko
  LD [M]  sound/pci/snd-cs4281.ko
  LD [M]  sound/pci/snd-ens1370.ko
  LD [M]  sound/pci/snd-cs5530.ko
  LD [M]  sound/pci/snd-ens1371.ko
  LD [M]  sound/pci/snd-es1938.ko
  LD [M]  sound/pci/snd-es1968.ko
  LD [M]  sound/pci/snd-fm801.ko
  LD [M]  sound/pci/snd-intel8x0m.ko
  LD [M]  sound/pci/snd-intel8x0.ko
  LD [M]  sound/pci/snd-maestro3.ko
  LD [M]  sound/pci/snd-rme32.ko
  LD [M]  sound/pci/snd-rme96.ko
  LD [M]  sound/pci/snd-sis7019.ko
  LD [M]  sound/pci/snd-sonicvibes.ko
  LD [M]  sound/pci/snd-via82xx.ko
  LD [M]  sound/pci/snd-via82xx-modem.ko
  LD [M]  sound/pci/trident/snd-trident.ko
  LD [M]  sound/pci/vx222/snd-vx222.ko
  LD [M]  sound/pci/ymfpci/snd-ymfpci.ko
  LD [M]  sound/pcmcia/vx/snd-vxpocket.ko
  LD [M]  sound/pcmcia/pdaudiocf/snd-pdaudiocf.ko
  LD [M]  sound/soc/snd-soc-core.ko
  LD [M]  sound/soundcore.ko
  LD [M]  sound/synth/snd-util-mem.ko
  LD [M]  sound/synth/emux/snd-emux-synth.ko
  LD [M]  sound/usb/6fire/snd-usb-6fire.ko
  LD [M]  sound/usb/caiaq/snd-usb-caiaq.ko
  LD [M]  sound/usb/misc/snd-ua101.ko
  LD [M]  sound/usb/snd-usb-audio.ko
  LD [M]  sound/usb/snd-usbmidi-lib.ko
  LD [M]  sound/usb/usx2y/snd-usb-usx2y.ko
  LD [M]  sound/usb/usx2y/snd-usb-us122l.ko
  IHEX    firmware/adaptec/starfire_rx.bin
  IHEX    firmware/adaptec/starfire_tx.bin
  IHEX    firmware/bnx2/bnx2-mips-09-6.2.1a.fw
  IHEX    firmware/bnx2/bnx2-rv2p-09-6.0.17.fw
  IHEX    firmware/bnx2/bnx2-rv2p-09ax-6.0.17.fw
  IHEX    firmware/bnx2/bnx2-mips-06-6.2.1.fw
  IHEX    firmware/bnx2/bnx2-rv2p-06-6.0.15.fw
  IHEX    firmware/cxgb3/t3b_psram-1.1.0.bin
  IHEX    firmware/cxgb3/t3c_psram-1.1.0.bin
  IHEX    firmware/cxgb3/t3fw-7.10.0.bin
  IHEX    firmware/cxgb3/ael2005_opt_edc.bin
  IHEX    firmware/cxgb3/ael2005_twx_edc.bin
  IHEX    firmware/cxgb3/ael2020_twx_edc.bin
  IHEX    firmware/radeon/R100_cp.bin
  IHEX    firmware/radeon/R200_cp.bin
  IHEX    firmware/radeon/R300_cp.bin
  IHEX    firmware/radeon/R420_cp.bin
  IHEX    firmware/radeon/RS690_cp.bin
  IHEX    firmware/radeon/R520_cp.bin
  IHEX    firmware/radeon/RS600_cp.bin
  IHEX    firmware/radeon/R600_me.bin
  IHEX    firmware/radeon/RV610_pfp.bin
  IHEX    firmware/radeon/RV610_me.bin
  IHEX    firmware/radeon/RV630_pfp.bin
  IHEX    firmware/radeon/RV630_me.bin
  IHEX    firmware/radeon/RV620_pfp.bin
  IHEX    firmware/radeon/RV620_me.bin
  IHEX    firmware/radeon/RV635_pfp.bin
  IHEX    firmware/radeon/RV635_me.bin
  IHEX    firmware/radeon/RV670_pfp.bin
  IHEX    firmware/radeon/RS780_me.bin
  IHEX    firmware/radeon/RV770_pfp.bin
  IHEX    firmware/radeon/RV770_me.bin
  IHEX    firmware/radeon/RV730_pfp.bin
  IHEX    firmware/radeon/RV730_me.bin
  IHEX    firmware/radeon/RV710_me.bin
  IHEX    firmware/radeon/RV710_pfp.bin
  IHEX    firmware/e100/d101m_ucode.bin
  IHEX    firmware/e100/d101s_ucode.bin
  IHEX    firmware/e100/d102e_ucode.bin
  IHEX    firmware/korg/k1212.dsp
  IHEX    firmware/ositech/Xilinx7OD.bin
  IHEX    firmware/ess/maestro3_assp_kernel.fw
  IHEX    firmware/ess/maestro3_assp_minisrc.fw
  IHEX    firmware/yamaha/ds1_ctrl.fw
  IHEX    firmware/yamaha/ds1_dsp.fw
  IHEX    firmware/yamaha/ds1e_ctrl.fw
  IHEX    firmware/yamaha/yss225_registers.bin
