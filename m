Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab2JLUJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:09:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42187 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2JLUJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:09:22 -0400
Date: Fri, 12 Oct 2012 14:09:09 -0600
From: russellbell@gmail.com
Message-Id: <201210122009.q9CK99gB014755@randytool.net>
to: linux-kernel@vger.kernel.org
subject: atd stopped working in kernel 3.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	I apologize if this is the wrong spot.  I can't figure out where to go.


	atd fails beginning in kernel 3.6.0 reporting 'Can't link execution file: Operation not permitted'

1)  atd works in kernel 3.5.5
2)  A version built from the latest source in 3.6.1 fails in the same way


Find the strace log below.  I don't understand it.
The reported error seems to happen at:

	link("a0000101574742", "=0000101574742") = -1 EPERM (Operation not permitted)


In 3.5.5, when atd works, the end of the trace changes at the first getdents; the link never happens:


mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb779c000 _llseek(3, 0, [0], SEEK_CUR)            = 0
write(3, "1119\n", 5)                   = 5
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
setregid32(0, 2)                        = 0
setreuid32(0, 2)                        = 0
time(NULL)                              = 1349882275
stat64(".", {st_dev=makedev(8, 4), st_ino=10715414, st_mode=S_IFDIR|0700, st_nlink=2, st_uid=2, st_gid=2, st_blksize=4096, st_blocks=8, st_size=4096, st_atime=2012/10/10-09:17:07, st_mtime=2012/10/10-09:17:06, st_ctime=2012/10/10-09:17:06}) = 0
openat(AT_FDCWD, ".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 4
getdents(4, {{d_ino=10715416, d_off=618125610, d_reclen=16, d_name=".SEQ"} {d_ino=10715414, d_off=901055122, d_reclen=16, d_name="."} {d_ino=10715172, d_off=2147483647, d_reclen=16, d_name=".."}}, 32768) = 48
getdents(4, {}, 32768)                  = 0
close(4)                                = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGCHLD, NULL, {0x80492b0, [], SA_NOCLDSTOP}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
nanosleep({3600, 0},

atd log in 3.6.1:

execve("/usr/sbin/atd", ["/usr/sbin/atd", "-d"], ["CPLUS_INCLUDE_PATH=/usr/lib/qt/i"..., "NNTPSERVER=127.0.0.1", "MANPATH=/usr/local/man:/usr/man:"..., "HZ=100", "HOSTNAME=randytool.net", "unknownbluetooth=00:1C:62:D1:5C:"..., "SHELL=/bin/bash", "TERM=linux", "HUSHLOGIN=FALSE", "jen=00:19:E3:EB:D2:04", "USER=root", "LS_COLORS=no=00:fi=00:di=01;34:l"..., "GDK_USE_XFT=1", "T1LIB_CONFIG=/usr/share/t1lib/t1"..., "MINICOM=-c on", "MAIL=/var/spool/mail/root", "PATH=/bin:/sbin:/usr/bin:/usr/sb"..., "LC_COLLATE=C", "INPUTRC=/etc/inputrc", "PWD=/var/log", "LANG=en_US", "QT4DIR=/usr/lib/qt", "headset=00:13:17:DD:D0:86", "bluetooth=00:11:67:6B:77:2D", "TZ=MST7MDT", "PS1=`pwd`# ", "PS2=> ", "LESSCHARSET=iso8859", "SHLVL=1", "HOME=/root", "LS_OPTIONS=-F -b -T 0 --color=au"..., "LESS=-M -i", "LOGNAME=root", "VISUAL=/usr/bin/emacs", "LESSOPEN=|lesspipe.sh %s", "PKG_CONFIG_PATH=/usr/lib/pkgconf"..., "G_BROKEN_FILENAMES=1", "_=/usr/bin/strace", "OLDPWD=/root"]) = 0
brk(0)                                  = 0x8afb000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb76ef000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_dev=makedev(8, 4), st_ino=5948477, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=184, st_size=90810, st_atime=2012/10/09-17:00:59, st_mtime=2012/10/09-17:00:59, st_ctime=2012/10/09-17:00:59}) = 0
mmap2(NULL, 90810, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb76d8000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0\227\1\0004\0\0\0"..., 512) = 512
fstat64(3, {st_dev=makedev(8, 4), st_ino=3809925, st_mode=S_IFREG|0755, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=3504, st_size=1790836, st_atime=2012/10/08-22:47:01, st_mtime=2012/09/17-14:35:31, st_ctime=2012/09/20-19:11:52}) = 0
mmap2(NULL, 1591836, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7553000
mprotect(0xb76d1000, 4096, PROT_NONE)   = 0
mmap2(0xb76d2000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17e) = 0xb76d2000
mmap2(0xb76d5000, 10780, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb76d5000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7552000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb75526c0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb76d2000, 8192, PROT_READ)   = 0
mprotect(0xb7712000, 4096, PROT_READ)   = 0
munmap(0xb76d8000, 90810)               = 0
brk(0)                                  = 0x8afb000
brk(0x8b1c000)                          = 0x8b1c000
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
open("/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_dev=makedev(8, 4), st_ino=5947448, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, st_size=1083, st_atime=2012/10/09-01:00:54, st_mtime=2009/08/22-13:30:12, st_ctime=2010/03/10-18:43:39}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb76ee000
read(3, "#\n# /etc/nsswitch.conf\n#\n# An ex"..., 4096) = 1083
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0xb76ee000, 4096)                = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_dev=makedev(8, 4), st_ino=5948477, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=184, st_size=90810, st_atime=2012/10/09-17:00:59, st_mtime=2012/10/09-17:00:59, st_ctime=2012/10/09-17:00:59}) = 0
mmap2(NULL, 90810, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb76d8000
close(3)                                = 0
open("/lib/libnss_compat.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20\16\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_dev=makedev(8, 4), st_ino=3809917, st_mode=S_IFREG|0755, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=80, st_size=39451, st_atime=2012/10/09-01:00:54, st_mtime=2012/09/17-14:35:31, st_ctime=2012/09/20-19:11:52}) = 0
mmap2(NULL, 37424, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7548000
mmap2(0xb7550000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x7) = 0xb7550000
close(3)                                = 0
open("/lib/libnsl.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\2401\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_dev=makedev(8, 4), st_ino=3809916, st_mode=S_IFREG|0755, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=224, st_size=112576, st_atime=2012/10/09-01:00:54, st_mtime=2012/09/17-14:35:31, st_ctime=2012/09/20-19:11:52}) = 0
mmap2(NULL, 108520, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb752d000
mmap2(0xb7544000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x16) = 0xb7544000
mmap2(0xb7546000, 6120, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7546000
close(3)                                = 0
mprotect(0xb7544000, 4096, PROT_READ)   = 0
mprotect(0xb7550000, 4096, PROT_READ)   = 0
munmap(0xb76d8000, 90810)               = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_dev=makedev(8, 4), st_ino=5948477, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=184, st_size=90810, st_atime=2012/10/09-17:00:59, st_mtime=2012/10/09-17:00:59, st_ctime=2012/10/09-17:00:59}) = 0
mmap2(NULL, 90810, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb76d8000
close(3)                                = 0
open("/lib/libnss_nis.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260\31\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_dev=makedev(8, 4), st_ino=3809920, st_mode=S_IFREG|0755, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=104, st_size=49289, st_atime=2012/10/09-01:00:54, st_mtime=2012/09/17-14:35:31, st_ctime=2012/09/20-19:11:52}) = 0
mmap2(NULL, 45628, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7521000
mmap2(0xb752b000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x9) = 0xb752b000
close(3)                                = 0
open("/lib/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P\32\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_dev=makedev(8, 4), st_ino=3809919, st_mode=S_IFREG|0755, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=112, st_size=54520, st_atime=2012/10/09-01:00:54, st_mtime=2012/09/17-14:35:31, st_ctime=2012/09/20-19:11:52}) = 0
mmap2(NULL, 50180, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7514000
mmap2(0xb751f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xa) = 0xb751f000
close(3)                                = 0
mprotect(0xb751f000, 4096, PROT_READ)   = 0
mprotect(0xb752b000, 4096, PROT_READ)   = 0
munmap(0xb76d8000, 90810)               = 0
open("/etc/passwd", O_RDONLY|O_CLOEXEC) = 3
_llseek(3, 0, [0], SEEK_CUR)            = 0
fstat64(3, {st_dev=makedev(8, 4), st_ino=5948161, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, st_size=1190, st_atime=2012/10/08-22:47:01, st_mtime=2012/04/02-22:03:15, st_ctime=2012/04/02-22:03:15}) = 0
mmap2(NULL, 1190, PROT_READ, MAP_SHARED, 3, 0) = 0xb76ee000
_llseek(3, 1190, [1190], SEEK_SET)      = 0
_llseek(3, 95, [95], SEEK_SET)          = 0
munmap(0xb76ee000, 1190)                = 0
close(3)                                = 0
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
open("/etc/group", O_RDONLY|O_CLOEXEC)  = 3
_llseek(3, 0, [0], SEEK_CUR)            = 0
fstat64(3, {st_dev=makedev(8, 4), st_ino=5948155, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, st_size=707, st_atime=2012/10/08-22:47:01, st_mtime=2012/04/06-01:33:07, st_ctime=2012/04/06-01:33:08}) = 0
mmap2(NULL, 707, PROT_READ, MAP_SHARED, 3, 0) = 0xb76ee000
_llseek(3, 707, [707], SEEK_SET)        = 0
_llseek(3, 66, [66], SEEK_SET)          = 0
munmap(0xb76ee000, 707)                 = 0
close(3)                                = 0
geteuid32()                             = 0
getegid32()                             = 0
setregid32(0, 2)                        = 0
setreuid32(0, 2)                        = 0
chdir("/var/spool/atjobs")              = 0
rt_sigaction(SIGCHLD, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGCHLD, {0x80492b0, [], SA_NOCLDSTOP}, NULL, 8) = 0
rt_sigaction(SIGHUP, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGHUP, {0x80492a0, [], 0}, NULL, 8) = 0
rt_sigaction(SIGTERM, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGTERM, {0x8049290, [], 0}, NULL, 8) = 0
rt_sigaction(SIGINT, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGINT, {0x8049290, [], 0}, NULL, 8) = 0
getpid()                                = 1545
umask(022)                              = 022
setreuid32(2, 0)                        = 0
setregid32(2, 0)                        = 0
open("/var/run/atd.pid", O_RDWR|O_CREAT|O_EXCL, 0644) = -1 EEXIST (File exists)
open("/var/run/atd.pid", O_RDWR)        = 3
fcntl64(3, F_GETFL)                     = 0x2 (flags O_RDWR)
fstat64(3, {st_dev=makedev(8, 4), st_ino=10721420, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, st_size=4, st_atime=2012/10/09-17:06:05, st_mtime=2012/10/09-17:01:21, st_ctime=2012/10/09-17:01:21}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb76ee000
_llseek(3, 0, [0], SEEK_CUR)            = 0
read(3, "964\n", 4096)                  = 4
fcntl64(3, F_SETLK, {type=F_WRLCK, whence=SEEK_SET, start=0, len=0}) = 0
time(NULL)                              = 1349825709
open("/usr/share/zoneinfo/MST7MDT", O_RDONLY|O_CLOEXEC) = 4
fstat64(4, {st_dev=makedev(8, 4), st_ino=9699987, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, st_size=2294, st_atime=2012/10/09-16:34:02, st_mtime=2012/09/17-14:30:22, st_ctime=2012/09/20-19:11:54}) = 0
fstat64(4, {st_dev=makedev(8, 4), st_ino=9699987, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, st_size=2294, st_atime=2012/10/09-16:34:02, st_mtime=2012/09/17-14:30:22, st_ctime=2012/09/20-19:11:54}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb76ed000
read(4, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\4\0\0\0\4\0\0\0\0"..., 4096) = 2294
_llseek(4, -24, [2270], SEEK_CUR)       = 0
read(4, "\nMST7MDT,M3.2.0,M11.1.0\n", 4096) = 24
_llseek(4, 2293, [2293], SEEK_SET)      = 0
close(4)                                = 0
munmap(0xb76ed000, 4096)                = 0
socket(PF_FILE, SOCK_DGRAM|SOCK_CLOEXEC, 0) = 4
connect(4, {sa_family=AF_FILE, path="/dev/log"}, 110) = 0
send(4, "<77>Oct  9 17:35:09 atd[1545]: R"..., 66, MSG_NOSIGNAL) = 66
unlink("/var/run/atd.pid")              = 0
_llseek(3, 3, [3], SEEK_SET)            = 0
close(3)                                = 0
munmap(0xb76ee000, 4096)                = 0
unlink("/var/run/atd.pid")              = -1 ENOENT (No such file or directory)
open("/var/run/atd.pid", O_RDWR|O_CREAT|O_EXCL, 0644) = 3
fcntl64(3, F_SETLK, {type=F_WRLCK, whence=SEEK_SET, start=0, len=0}) = 0
fcntl64(3, F_GETFL)                     = 0x2 (flags O_RDWR)
fstat64(3, {st_dev=makedev(8, 4), st_ino=10721420, st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=0, st_size=0, st_atime=2012/10/09-17:35:09, st_mtime=2012/10/09-17:35:09, st_ctime=2012/10/09-17:35:09}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb76ee000
_llseek(3, 0, [0], SEEK_CUR)            = 0
write(3, "1545\n", 5)                   = 5
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
setregid32(0, 2)                        = 0
setreuid32(0, 2)                        = 0
time(NULL)                              = 1349825709
stat64(".", {st_dev=makedev(8, 4), st_ino=10715414, st_mode=S_IFDIR|S_ISVTX|0770, st_nlink=2, st_uid=2, st_gid=2, st_blksize=4096, st_blocks=8, st_size=4096, st_atime=2012/10/09-17:07:17, st_mtime=2012/10/09-17:07:14, st_ctime=2012/10/09-17:07:14}) = 0
openat(AT_FDCWD, ".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 5
getdents(5, {{d_ino=10715416, d_off=618125610, d_reclen=16, d_name=".SEQ"} {d_ino=10715414, d_off=785181927, d_reclen=16, d_name="."} {d_ino=10721669, d_off=901055122, d_reclen=28, d_name="a0000201574760"} {d_ino=10715172, d_off=1160556431, d_reclen=16, d_name=".."} {d_ino=10721627, d_off=1418693512, d_reclen=28, d_name="a0000101574742"} {d_ino=10721677, d_off=1774440493, d_reclen=28, d_name="a000040157479b"} {d_ino=10721675, d_off=2147483647, d_reclen=28, d_name="a000030157477e"}}, 32768) = 160
stat64("a0000201574760", {st_dev=makedev(8, 4), st_ino=10721669, st_mode=S_IFREG|0700, st_nlink=1, st_uid=1000, st_gid=2, st_blksize=4096, st_blocks=8, st_size=3107, st_atime=2012/10/09-17:07:03, st_mtime=2012/10/09-17:07:05, st_ctime=2012/10/09-17:07:05}) = 0
stat64("a0000101574742", {st_dev=makedev(8, 4), st_ino=10721627, st_mode=S_IFREG|0700, st_nlink=1, st_uid=1000, st_gid=2, st_blksize=4096, st_blocks=8, st_size=3107, st_atime=2012/10/09-17:06:58, st_mtime=2012/10/09-17:07:00, st_ctime=2012/10/09-17:07:00}) = 0
link("a0000101574742", "=0000101574742") = -1 EPERM (Operation not permitted)
dup(2)                                  = 6
fcntl64(6, F_GETFL)                     = 0x8002 (flags O_RDWR|O_LARGEFILE)
fstat64(6, {st_dev=makedev(0, 5), st_ino=1053, st_mode=S_IFCHR|0600, st_nlink=1, st_uid=0, st_gid=5, st_blksize=4096, st_blocks=0, st_rdev=makedev(4, 6), st_atime=2012/10/09-17:35:09, st_mtime=2012/10/09-17:35:09, st_ctime=2012/10/09-17:05:53}) = 0
ioctl(6, SNDCTL_TMR_TIMEBASE or TCGETS, {c_iflags=0x2502, c_oflags=0x5, c_cflags=0x4bf, c_lflags=0x8a3b, c_line=0, c_cc="\x03\x1c\x7f\x15\x04\x00\x01\x00\x11\x13\x1a\x00\x12\x0f\x17\x16\x00\x00\x00"}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb76ed000
_llseek(6, 0, 0xbfd73f28, SEEK_CUR)     = -1 ESPIPE (Illegal seek)
write(6, "Can't link execution file: Opera"..., 51) = 51
close(6)                                = 0
munmap(0xb76ed000, 4096)                = 0
exit_group(1)                           = ?



processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Pentium(R) Dual-Core CPU       T4400  @ 2.20GHz
stepping	: 10
microcode	: 0xa07
cpu MHz		: 2200.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm xsave lahf_lm dtherm
bogomips	: 4389.17
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Pentium(R) Dual-Core CPU       T4400  @ 2.20GHz
stepping	: 10
microcode	: 0xa07
cpu MHz		: 2200.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm xsave lahf_lm dtherm
bogomips	: 4389.17
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:
