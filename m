Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0IUPJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:09:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52907 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852Ab0IUPJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:09:08 -0400
Date: Tue, 21 Sep 2010 17:09:00 +0200
From: Heinz Diehl <htd@fritha.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Heinz Diehl <htd@fancy-poultry.org>, Alan Ott <alan@signal11.us>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
Message-ID: <20100921150900.GA6801@fritha.org>
References: <20100812113624.GB1591@arch.tripp.de>
 <20100812114513.GA1584@arch.tripp.de>
 <20100812115657.GA1611@arch.tripp.de>
 <alpine.LNX.2.00.1008121401580.2702@pobox.suse.cz>
 <alpine.LNX.2.00.1008121457060.2702@pobox.suse.cz>
 <20100812130411.GA1626@arch.tripp.de>
 <4C63F285.8070801@signal11.us>
 <20100812164035.GB6761@fritha.org>
 <20100920181100.GA12295@fancy-poultry.org>
 <alpine.LNX.2.00.1009211653510.26813@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1009211653510.26813@pobox.suse.cz>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100810 (GNU/Linux)
X-Provags-ID: V02:K0:UoebE4ylRlbGeVxR3AKMj1TCarVNi6U8KoeL2UUNH3c
 8fpGaVMZ39QjCTSQVc494rwLx8WPIoLkgVzFfcd9bv9j0/wHAh
 zworx0sKFFSjSJftAbZGWflWrLMEQQhQzhqPTynLbFHBR1wq64
 jPIOSYmAd9ifrdbnzAudUq4Zq/cXPBQCOlvea/fUSUpen5Onxq
 iPbZTDlA9OfHYuCnApYCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


On 21.09.2010, Jiri Kosina wrote:

> This seems like a completely different problem -- apcupsd is not finding
> the UPS, yes, but kernel doesn't WARN/BUG here, so it seems like similar
> symptoms, but very likely a different cause.

Hmm, I just don't know.

> Could you perhaps strace apcupsd to see what it is doing before it fails?

Yes, of course. The output is attached this mail.


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="apcupsd.strace.txt"

;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

liesel:/var/log # strace apcupsd
execve("/usr/sbin/apcupsd", ["apcupsd"], [/* 92 vars */]) = 0
brk(0)                                  = 0x8ba000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff1a3299000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff1a3298000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=139747, ...}) = 0
mmap(NULL, 139747, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7ff1a3275000
close(3)                                = 0
open("/lib64/libwrap.so.0", O_RDONLY)   = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\00006\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=42016, ...}) = 0
mmap(NULL, 2139528, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ff1a2e72000
fadvise64(3, 0, 2139528, POSIX_FADV_WILLNEED) = 0
mprotect(0x7ff1a2e7b000, 2093056, PROT_NONE) = 0
mmap(0x7ff1a307a000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x8000) = 0x7ff1a307a000
mmap(0x7ff1a307c000, 1416, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7ff1a307c000
close(3)                                = 0
open("/lib64/libpthread.so.0", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20X\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=130284, ...}) = 0
mmap(NULL, 2208624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ff1a2c56000
fadvise64(3, 0, 2208624, POSIX_FADV_WILLNEED) = 0
mprotect(0x7ff1a2c6c000, 2097152, PROT_NONE) = 0
mmap(0x7ff1a2e6c000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x16000) = 0x7ff1a2e6c000
mmap(0x7ff1a2e6e000, 13168, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7ff1a2e6e000
close(3)                                = 0
open("/usr/lib64/libnetsnmp.so.15", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\211\1\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=685760, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff1a3274000
mmap(NULL, 2994464, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ff1a297a000
fadvise64(3, 0, 2994464, POSIX_FADV_WILLNEED) = 0
mprotect(0x7ff1a2a1d000, 2097152, PROT_NONE) = 0
mmap(0x7ff1a2c1d000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xa3000) = 0x7ff1a2c1d000
mmap(0x7ff1a2c21000, 213280, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7ff1a2c21000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY)      = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\346\1\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1406248, ...}) = 0
mmap(NULL, 3506872, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ff1a2621000
fadvise64(3, 0, 3506872, POSIX_FADV_WILLNEED) = 0
mprotect(0x7ff1a2770000, 2097152, PROT_NONE) = 0
mmap(0x7ff1a2970000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x14f000) = 0x7ff1a2970000
mmap(0x7ff1a2975000, 17080, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7ff1a2975000
close(3)                                = 0
open("/usr/lib64/libcrypto.so.0.9.8", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\300\251\6\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0555, st_size=6043624, ...}) = 0
mmap(NULL, 3724088, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ff1a2293000
fadvise64(3, 0, 3724088, POSIX_FADV_WILLNEED) = 0
mprotect(0x7ff1a23f8000, 2093056, PROT_NONE) = 0
mmap(0x7ff1a25f7000, 155648, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x164000) = 0x7ff1a25f7000
mmap(0x7ff1a261d000, 13112, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7ff1a261d000
close(3)                                = 0
open("/lib64/libdl.so.2", O_RDONLY)     = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360\r\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=14872, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff1a3273000
mmap(0x7ff1a261d000, 13112, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7ff1a261d000
close(3)                                = 0
open("/lib64/libdl.so.2", O_RDONLY)     = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360\r\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=14872, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff1a3273000
mmap(NULL, 2109696, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ff1a208f000
fadvise64(3, 0, 2109696, POSIX_FADV_WILLNEED) = 0
mprotect(0x7ff1a2091000, 2097152, PROT_NONE) = 0
mmap(0x7ff1a2291000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7ff1a2291000
close(3)                                = 0
open("/lib64/libz.so.1", O_RDONLY)      = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\"\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=88704, ...}) = 0
mmap(NULL, 2183728, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ff1a1e79000
fadvise64(3, 0, 2183728, POSIX_FADV_WILLNEED) = 0
mprotect(0x7ff1a1e8e000, 2093056, PROT_NONE) = 0
mmap(0x7ff1a208d000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x14000) = 0x7ff1a208d000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff1a3272000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff1a3271000
arch_prctl(ARCH_SET_FS, 0x7ff1a32716f0) = 0
open("/dev/urandom", O_RDONLY)          = 3
read(3, "Z\27\271\37\20\347\f|", 8)     = 8
close(3)                                = 0
mprotect(0x7ff1a208d000, 4096, PROT_READ) = 0
mprotect(0x7ff1a2291000, 4096, PROT_READ) = 0
mprotect(0x7ff1a25f7000, 57344, PROT_READ) = 0
mprotect(0x7ff1a2970000, 16384, PROT_READ) = 0
mprotect(0x7ff1a2c1d000, 4096, PROT_READ) = 0
mprotect(0x7ff1a2e6c000, 4096, PROT_READ) = 0
mprotect(0x7ff1a307a000, 4096, PROT_READ) = 0
mprotect(0x636000, 4096, PROT_READ)     = 0
mprotect(0x7ff1a329a000, 4096, PROT_READ) = 0
munmap(0x7ff1a3275000, 139747)          = 0
set_tid_address(0x7ff1a3271780)         = 6763
set_robust_list(0x7ff1a3271790, 0x18)   = 0
futex(0x7fffe401687c, FUTEX_WAKE_PRIVATE, 1) = 0
rt_sigaction(SIGRTMIN, {0x7ff1a2c5b6a0, [], SA_RESTORER|SA_SIGINFO, 0x7ff1a2c64a90}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0x7ff1a2c5b730, [], SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x7ff1a2c64a90}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
open("/dev/null", O_RDONLY)             = 3
close(3)                                = 0
brk(0)                                  = 0x8ba000
brk(0x8e4000)                           = 0x8e4000
open("/etc/apcupsd/apcupsd.conf", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=12039, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff1a3297000
read(3, "## apcupsd.conf v1.1 ##\n# \n#  fo"..., 4096) = 4096
read(3, "equired.\nPWRFAILDIR /etc/apcupsd"..., 4096) = 4096
read(3, "vents\n\n# EVENTSFILEMAX <kilobyte"..., 4096) = 3847
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7ff1a3297000, 4096)            = 0
open("/var/lock/LCK..", O_RDONLY)       = -1 ENOENT (No such file or directory)
clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7ff1a3271780) = 6764
exit_group(0)                           = ?
liesel:/


--cvVnyQ+4j833TQvp--
