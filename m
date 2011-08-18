Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1HRTBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:01:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44226 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1HRTBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:01:30 -0400
Date: Thu, 18 Aug 2011 20:01:29 +0100
To: richard@nod.at
Subject: Subject: [PATCH 15/91] um: -include user.h for USER_OBJ, trim
 includes
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7qL-0007WA-88@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/drivers/chan_user.c              |    2 --
 arch/um/drivers/cow_sys.h                |    1 -
 arch/um/drivers/daemon_user.c            |    1 -
 arch/um/drivers/fd.c                     |    2 --
 arch/um/drivers/harddog_user.c           |    1 -
 arch/um/drivers/mconsole_user.c          |    2 --
 arch/um/drivers/net_user.c               |    2 --
 arch/um/drivers/pcap_user.c              |    2 --
 arch/um/drivers/port_user.c              |    2 --
 arch/um/drivers/pty.c                    |    2 --
 arch/um/drivers/slip_user.c              |    2 --
 arch/um/drivers/slirp_user.c             |    2 --
 arch/um/drivers/tty.c                    |    2 --
 arch/um/drivers/ubd_user.c               |    1 -
 arch/um/drivers/umcast_user.c            |    2 --
 arch/um/drivers/vde_user.c               |    2 --
 arch/um/drivers/xterm.c                  |    2 --
 arch/um/kernel/skas/clone.c              |    1 -
 arch/um/os-Linux/aio.c                   |    2 --
 arch/um/os-Linux/drivers/ethertap_user.c |    2 --
 arch/um/os-Linux/drivers/tuntap_user.c   |    2 --
 arch/um/os-Linux/elf_aux.c               |    1 -
 arch/um/os-Linux/file.c                  |    2 --
 arch/um/os-Linux/helper.c                |    2 --
 arch/um/os-Linux/irq.c                   |    2 --
 arch/um/os-Linux/main.c                  |    1 -
 arch/um/os-Linux/mem.c                   |    2 --
 arch/um/os-Linux/process.c               |    2 --
 arch/um/os-Linux/sigio.c                 |    2 --
 arch/um/os-Linux/signal.c                |    1 -
 arch/um/os-Linux/skas/mem.c              |    2 --
 arch/um/os-Linux/skas/process.c          |    2 --
 arch/um/os-Linux/start_up.c              |    1 -
 arch/um/os-Linux/sys-i386/registers.c    |    2 --
 arch/um/os-Linux/sys-i386/task_size.c    |    1 -
 arch/um/os-Linux/sys-i386/tls.c          |    1 -
 arch/um/os-Linux/sys-x86_64/registers.c  |    2 --
 arch/um/os-Linux/time.c                  |    2 --
 arch/um/os-Linux/tty.c                   |    2 --
 arch/um/os-Linux/umid.c                  |    2 --
 arch/um/os-Linux/util.c                  |    2 --
 arch/um/scripts/Makefile.rules           |    2 +-
 arch/um/sys-i386/Makefile                |    2 +-
 arch/um/sys-i386/bugs.c                  |    2 --
 arch/um/sys-i386/shared/sysdep/stub.h    |    1 -
 arch/um/sys-x86_64/Makefile              |    2 +-
 arch/um/sys-x86_64/shared/sysdep/stub.h  |    1 -
 47 files changed, 3 insertions(+), 78 deletions(-)

diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index cfeb3f4..7ed06a7 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -11,10 +11,8 @@
 #include <termios.h>
 #include <sys/ioctl.h>
 #include "chan_user.h"
-#include "kern_constants.h"
 #include "os.h"
 #include "um_malloc.h"
-#include "user.h"
 
 void generic_close(int fd, void *unused)
 {
diff --git a/arch/um/drivers/cow_sys.h b/arch/um/drivers/cow_sys.h
index f5701fd..7f2ed0b 100644
--- a/arch/um/drivers/cow_sys.h
+++ b/arch/um/drivers/cow_sys.h
@@ -3,7 +3,6 @@
 
 #include "kern_util.h"
 #include "os.h"
-#include "user.h"
 #include "um_malloc.h"
 
 static inline void *cow_malloc(int size)
diff --git a/arch/um/drivers/daemon_user.c b/arch/um/drivers/daemon_user.c
index f8e85e0..a4fd7bc 100644
--- a/arch/um/drivers/daemon_user.c
+++ b/arch/um/drivers/daemon_user.c
@@ -17,7 +17,6 @@
 #include "net_user.h"
 #include "os.h"
 #include "um_malloc.h"
-#include "user.h"
 
 enum request_type { REQ_NEW_CONTROL };
 
diff --git a/arch/um/drivers/fd.c b/arch/um/drivers/fd.c
index f5a981a..5b81d25 100644
--- a/arch/um/drivers/fd.c
+++ b/arch/um/drivers/fd.c
@@ -9,10 +9,8 @@
 #include <errno.h>
 #include <termios.h>
 #include "chan_user.h"
-#include "kern_constants.h"
 #include "os.h"
 #include "um_malloc.h"
-#include "user.h"
 
 struct fd_chan {
 	int fd;
diff --git a/arch/um/drivers/harddog_user.c b/arch/um/drivers/harddog_user.c
index 84dce3f..0345d62 100644
--- a/arch/um/drivers/harddog_user.c
+++ b/arch/um/drivers/harddog_user.c
@@ -7,7 +7,6 @@
 #include <unistd.h>
 #include <errno.h>
 #include "os.h"
-#include "user.h"
 
 struct dog_data {
 	int stdin;
diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index f8cf4c8..9920982 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -10,9 +10,7 @@
 #include <sys/socket.h>
 #include <sys/uio.h>
 #include <sys/un.h>
-#include "kern_constants.h"
 #include "mconsole.h"
-#include "user.h"
 
 static struct mconsole_command commands[] = {
 	/*
diff --git a/arch/um/drivers/net_user.c b/arch/um/drivers/net_user.c
index 5201188..05090c3 100644
--- a/arch/um/drivers/net_user.c
+++ b/arch/um/drivers/net_user.c
@@ -12,10 +12,8 @@
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include "net_user.h"
-#include "kern_constants.h"
 #include "os.h"
 #include "um_malloc.h"
-#include "user.h"
 
 int tap_open_common(void *dev, char *gate_addr)
 {
diff --git a/arch/um/drivers/pcap_user.c b/arch/um/drivers/pcap_user.c
index 5f90358..702a75b 100644
--- a/arch/um/drivers/pcap_user.c
+++ b/arch/um/drivers/pcap_user.c
@@ -9,9 +9,7 @@
 #include <asm/types.h>
 #include "net_user.h"
 #include "pcap_user.h"
-#include "kern_constants.h"
 #include "um_malloc.h"
-#include "user.h"
 
 #define PCAP_FD(p) (*(int *)(p))
 
diff --git a/arch/um/drivers/port_user.c b/arch/um/drivers/port_user.c
index b49bf56..7b010b7 100644
--- a/arch/um/drivers/port_user.c
+++ b/arch/um/drivers/port_user.c
@@ -10,11 +10,9 @@
 #include <unistd.h>
 #include <netinet/in.h>
 #include "chan_user.h"
-#include "kern_constants.h"
 #include "os.h"
 #include "port.h"
 #include "um_malloc.h"
-#include "user.h"
 
 struct port_chan {
 	int raw;
diff --git a/arch/um/drivers/pty.c b/arch/um/drivers/pty.c
index 1113911..cff2b75 100644
--- a/arch/um/drivers/pty.c
+++ b/arch/um/drivers/pty.c
@@ -12,10 +12,8 @@
 #include <termios.h>
 #include <sys/stat.h>
 #include "chan_user.h"
-#include "kern_constants.h"
 #include "os.h"
 #include "um_malloc.h"
-#include "user.h"
 
 struct pty_chan {
 	void (*announce)(char *dev_name, int dev);
diff --git a/arch/um/drivers/slip_user.c b/arch/um/drivers/slip_user.c
index cbacfc4..932b4d6 100644
--- a/arch/um/drivers/slip_user.c
+++ b/arch/um/drivers/slip_user.c
@@ -11,12 +11,10 @@
 #include <string.h>
 #include <sys/termios.h>
 #include <sys/wait.h>
-#include "kern_constants.h"
 #include "net_user.h"
 #include "os.h"
 #include "slip.h"
 #include "um_malloc.h"
-#include "user.h"
 
 static int slip_user_init(void *data, void *dev)
 {
diff --git a/arch/um/drivers/slirp_user.c b/arch/um/drivers/slirp_user.c
index a0ada8f..db4adb6 100644
--- a/arch/um/drivers/slirp_user.c
+++ b/arch/um/drivers/slirp_user.c
@@ -7,11 +7,9 @@
 #include <errno.h>
 #include <string.h>
 #include <sys/wait.h>
-#include "kern_constants.h"
 #include "net_user.h"
 #include "os.h"
 #include "slirp.h"
-#include "user.h"
 
 static int slirp_user_init(void *data, void *dev)
 {
diff --git a/arch/um/drivers/tty.c b/arch/um/drivers/tty.c
index 495858a..a97391f 100644
--- a/arch/um/drivers/tty.c
+++ b/arch/um/drivers/tty.c
@@ -7,10 +7,8 @@
 #include <fcntl.h>
 #include <termios.h>
 #include "chan_user.h"
-#include "kern_constants.h"
 #include "os.h"
 #include "um_malloc.h"
-#include "user.h"
 
 struct tty_chan {
 	char *dev;
diff --git a/arch/um/drivers/ubd_user.c b/arch/um/drivers/ubd_user.c
index b591bb9..007b94d 100644
--- a/arch/um/drivers/ubd_user.c
+++ b/arch/um/drivers/ubd_user.c
@@ -16,7 +16,6 @@
 #include <sys/mman.h>
 #include <sys/param.h>
 #include "asm/types.h"
-#include "user.h"
 #include "ubd_user.h"
 #include "os.h"
 #include "cow.h"
diff --git a/arch/um/drivers/umcast_user.c b/arch/um/drivers/umcast_user.c
index 59c56fd..010fa2d 100644
--- a/arch/um/drivers/umcast_user.c
+++ b/arch/um/drivers/umcast_user.c
@@ -15,11 +15,9 @@
 #include <unistd.h>
 #include <errno.h>
 #include <netinet/in.h>
-#include "kern_constants.h"
 #include "umcast.h"
 #include "net_user.h"
 #include "um_malloc.h"
-#include "user.h"
 
 static struct sockaddr_in *new_addr(char *addr, unsigned short port)
 {
diff --git a/arch/um/drivers/vde_user.c b/arch/um/drivers/vde_user.c
index c5c4325..b8c2867 100644
--- a/arch/um/drivers/vde_user.c
+++ b/arch/um/drivers/vde_user.c
@@ -6,10 +6,8 @@
 #include <stddef.h>
 #include <errno.h>
 #include <libvdeplug.h>
-#include "kern_constants.h"
 #include "net_user.h"
 #include "um_malloc.h"
-#include "user.h"
 #include "vde.h"
 
 static int vde_user_init(void *data, void *dev)
diff --git a/arch/um/drivers/xterm.c b/arch/um/drivers/xterm.c
index 8ac7146..d947527 100644
--- a/arch/um/drivers/xterm.c
+++ b/arch/um/drivers/xterm.c
@@ -11,10 +11,8 @@
 #include <string.h>
 #include <termios.h>
 #include "chan_user.h"
-#include "kern_constants.h"
 #include "os.h"
 #include "um_malloc.h"
-#include "user.h"
 #include "xterm.h"
 
 struct xterm_chan {
diff --git a/arch/um/kernel/skas/clone.c b/arch/um/kernel/skas/clone.c
index 2c8583c..e1fd066 100644
--- a/arch/um/kernel/skas/clone.c
+++ b/arch/um/kernel/skas/clone.c
@@ -8,7 +8,6 @@
 #include <asm/unistd.h>
 #include <sys/time.h>
 #include "as-layout.h"
-#include "kern_constants.h"
 #include "ptrace_user.h"
 #include "stub-data.h"
 #include "sysdep/stub.h"
diff --git a/arch/um/os-Linux/aio.c b/arch/um/os-Linux/aio.c
index 57e3d46..c5d039e 100644
--- a/arch/um/os-Linux/aio.c
+++ b/arch/um/os-Linux/aio.c
@@ -11,10 +11,8 @@
 #include <asm/unistd.h>
 #include "aio.h"
 #include "init.h"
-#include "kern_constants.h"
 #include "kern_util.h"
 #include "os.h"
-#include "user.h"
 
 struct aio_thread_req {
 	enum aio_type type;
diff --git a/arch/um/os-Linux/drivers/ethertap_user.c b/arch/um/os-Linux/drivers/ethertap_user.c
index cc72cb2..db3d648 100644
--- a/arch/um/os-Linux/drivers/ethertap_user.c
+++ b/arch/um/os-Linux/drivers/ethertap_user.c
@@ -13,11 +13,9 @@
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include "etap.h"
-#include "kern_constants.h"
 #include "os.h"
 #include "net_user.h"
 #include "um_malloc.h"
-#include "user.h"
 
 #define MAX_PACKET ETH_MAX_PACKET
 
diff --git a/arch/um/os-Linux/drivers/tuntap_user.c b/arch/um/os-Linux/drivers/tuntap_user.c
index 2448be0..a2aacff 100644
--- a/arch/um/os-Linux/drivers/tuntap_user.c
+++ b/arch/um/os-Linux/drivers/tuntap_user.c
@@ -13,11 +13,9 @@
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include <sys/uio.h>
-#include "kern_constants.h"
 #include "kern_util.h"
 #include "os.h"
 #include "tuntap.h"
-#include "user.h"
 
 static int tuntap_user_init(void *data, void *dev)
 {
diff --git a/arch/um/os-Linux/elf_aux.c b/arch/um/os-Linux/elf_aux.c
index 9533237..d895271 100644
--- a/arch/um/os-Linux/elf_aux.c
+++ b/arch/um/os-Linux/elf_aux.c
@@ -12,7 +12,6 @@
 #include "init.h"
 #include "elf_user.h"
 #include "mem_user.h"
-#include <kern_constants.h>
 
 typedef Elf32_auxv_t elf_auxv_t;
 
diff --git a/arch/um/os-Linux/file.c b/arch/um/os-Linux/file.c
index 140e587..b049a63 100644
--- a/arch/um/os-Linux/file.c
+++ b/arch/um/os-Linux/file.c
@@ -13,9 +13,7 @@
 #include <sys/socket.h>
 #include <sys/stat.h>
 #include <sys/un.h>
-#include "kern_constants.h"
 #include "os.h"
-#include "user.h"
 
 static void copy_stat(struct uml_stat *dst, const struct stat64 *src)
 {
diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index feff22d..cf26c4a 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -10,11 +10,9 @@
 #include <linux/limits.h>
 #include <sys/socket.h>
 #include <sys/wait.h>
-#include "kern_constants.h"
 #include "kern_util.h"
 #include "os.h"
 #include "um_malloc.h"
-#include "user.h"
 
 struct helper_data {
 	void (*pre_exec)(void*);
diff --git a/arch/um/os-Linux/irq.c b/arch/um/os-Linux/irq.c
index 0348b97..59c592c 100644
--- a/arch/um/os-Linux/irq.c
+++ b/arch/um/os-Linux/irq.c
@@ -9,11 +9,9 @@
 #include <signal.h>
 #include <string.h>
 #include "irq_user.h"
-#include "kern_constants.h"
 #include "os.h"
 #include "process.h"
 #include "um_malloc.h"
-#include "user.h"
 
 /*
  * Locked by irq_lock in arch/um/kernel/irq.c.  Changed by os_create_pollfd
diff --git a/arch/um/os-Linux/main.c b/arch/um/os-Linux/main.c
index 8471b81..7a86dd5 100644
--- a/arch/um/os-Linux/main.c
+++ b/arch/um/os-Linux/main.c
@@ -12,7 +12,6 @@
 #include <sys/resource.h>
 #include "as-layout.h"
 #include "init.h"
-#include "kern_constants.h"
 #include "kern_util.h"
 #include "os.h"
 #include "um_malloc.h"
diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
index 62878cf..8e421e1 100644
--- a/arch/um/os-Linux/mem.c
+++ b/arch/um/os-Linux/mem.c
@@ -14,9 +14,7 @@
 #include <sys/mman.h>
 #include <sys/param.h>
 #include "init.h"
-#include "kern_constants.h"
 #include "os.h"
-#include "user.h"
 
 /* Modified by which_tmpdir, which is called during early boot */
 static char *default_tmpdir = "/tmp";
diff --git a/arch/um/os-Linux/process.c b/arch/um/os-Linux/process.c
index 0c45dc8..0ced30c 100644
--- a/arch/um/os-Linux/process.c
+++ b/arch/um/os-Linux/process.c
@@ -13,12 +13,10 @@
 #include <sys/wait.h>
 #include <asm/unistd.h>
 #include "init.h"
-#include "kern_constants.h"
 #include "longjmp.h"
 #include "os.h"
 #include "process.h"
 #include "skas_ptrace.h"
-#include "user.h"
 
 #define ARBITRARY_ADDR -1
 #define FAILURE_PID    -1
diff --git a/arch/um/os-Linux/sigio.c b/arch/um/os-Linux/sigio.c
index 63d299d..34bb59b 100644
--- a/arch/um/os-Linux/sigio.c
+++ b/arch/um/os-Linux/sigio.c
@@ -11,14 +11,12 @@
 #include <sched.h>
 #include <signal.h>
 #include <string.h>
-#include "kern_constants.h"
 #include "kern_util.h"
 #include "init.h"
 #include "os.h"
 #include "process.h"
 #include "sigio.h"
 #include "um_malloc.h"
-#include "user.h"
 
 /*
  * Protected by sigio_lock(), also used by sigio_cleanup, which is an
diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index 6ae1807..4fc3cd1 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -15,7 +15,6 @@
 #include "process.h"
 #include "sysdep/barrier.h"
 #include "sysdep/sigcontext.h"
-#include "user.h"
 
 /* Copied from linux/compiler-gcc.h since we can't include it directly */
 #define barrier() __asm__ __volatile__("": : :"memory")
diff --git a/arch/um/os-Linux/skas/mem.c b/arch/um/os-Linux/skas/mem.c
index d261f17..01a06ea 100644
--- a/arch/um/os-Linux/skas/mem.c
+++ b/arch/um/os-Linux/skas/mem.c
@@ -9,7 +9,6 @@
 #include <string.h>
 #include <sys/mman.h>
 #include "init.h"
-#include "kern_constants.h"
 #include "as-layout.h"
 #include "mm_id.h"
 #include "os.h"
@@ -17,7 +16,6 @@
 #include "ptrace_user.h"
 #include "registers.h"
 #include "skas.h"
-#include "user.h"
 #include "sysdep/ptrace.h"
 #include "sysdep/stub.h"
 
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index d6e0a22..913b5a5 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -14,7 +14,6 @@
 #include <asm/unistd.h>
 #include "as-layout.h"
 #include "chan_user.h"
-#include "kern_constants.h"
 #include "kern_util.h"
 #include "mem.h"
 #include "os.h"
@@ -24,7 +23,6 @@
 #include "registers.h"
 #include "skas.h"
 #include "skas_ptrace.h"
-#include "user.h"
 #include "sysdep/stub.h"
 
 int is_skas_winch(int pid, int fd, void *data)
diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index 02ee9ad..b698680 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -18,7 +18,6 @@
 #include <sys/wait.h>
 #include <asm/unistd.h>
 #include "init.h"
-#include "kern_constants.h"
 #include "os.h"
 #include "mem_user.h"
 #include "ptrace_user.h"
diff --git a/arch/um/os-Linux/sys-i386/registers.c b/arch/um/os-Linux/sys-i386/registers.c
index 229f7a5..913d811 100644
--- a/arch/um/os-Linux/sys-i386/registers.c
+++ b/arch/um/os-Linux/sys-i386/registers.c
@@ -7,9 +7,7 @@
 #include <errno.h>
 #include <sys/ptrace.h>
 #include <sys/user.h>
-#include "kern_constants.h"
 #include "longjmp.h"
-#include "user.h"
 #include "sysdep/ptrace_user.h"
 
 int save_fp_registers(int pid, unsigned long *fp_regs)
diff --git a/arch/um/os-Linux/sys-i386/task_size.c b/arch/um/os-Linux/sys-i386/task_size.c
index be04c1e..4ce09b8 100644
--- a/arch/um/os-Linux/sys-i386/task_size.c
+++ b/arch/um/os-Linux/sys-i386/task_size.c
@@ -3,7 +3,6 @@
 #include <signal.h>
 #include <sys/mman.h>
 #include "longjmp.h"
-#include "kern_constants.h"
 
 static jmp_buf buf;
 
diff --git a/arch/um/os-Linux/sys-i386/tls.c b/arch/um/os-Linux/sys-i386/tls.c
index 32ed41e..281e83e 100644
--- a/arch/um/os-Linux/sys-i386/tls.c
+++ b/arch/um/os-Linux/sys-i386/tls.c
@@ -5,7 +5,6 @@
 #include <unistd.h>
 
 #include "sysdep/tls.h"
-#include "user.h"
 
 /* Checks whether host supports TLS, and sets *tls_min according to the value
  * valid on the host.
diff --git a/arch/um/os-Linux/sys-x86_64/registers.c b/arch/um/os-Linux/sys-x86_64/registers.c
index 594d97a..0594d55 100644
--- a/arch/um/os-Linux/sys-x86_64/registers.c
+++ b/arch/um/os-Linux/sys-x86_64/registers.c
@@ -7,9 +7,7 @@
 #include <sys/ptrace.h>
 #define __FRAME_OFFSETS
 #include <asm/ptrace.h>
-#include "kern_constants.h"
 #include "longjmp.h"
-#include "user.h"
 
 int save_fp_registers(int pid, unsigned long *fp_regs)
 {
diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index 6e3359d..995ca30 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -8,11 +8,9 @@
 #include <signal.h>
 #include <time.h>
 #include <sys/time.h>
-#include "kern_constants.h"
 #include "kern_util.h"
 #include "os.h"
 #include "process.h"
-#include "user.h"
 
 int set_interval(void)
 {
diff --git a/arch/um/os-Linux/tty.c b/arch/um/os-Linux/tty.c
index b09ff66..dd12b99 100644
--- a/arch/um/os-Linux/tty.c
+++ b/arch/um/os-Linux/tty.c
@@ -7,10 +7,8 @@
 #include <unistd.h>
 #include <errno.h>
 #include <fcntl.h>
-#include "kern_constants.h"
 #include "kern_util.h"
 #include "os.h"
-#include "user.h"
 
 struct grantpt_info {
 	int fd;
diff --git a/arch/um/os-Linux/umid.c b/arch/um/os-Linux/umid.c
index a27defb..4832eb5 100644
--- a/arch/um/os-Linux/umid.c
+++ b/arch/um/os-Linux/umid.c
@@ -13,9 +13,7 @@
 #include <unistd.h>
 #include <sys/stat.h>
 #include "init.h"
-#include "kern_constants.h"
 #include "os.h"
-#include "user.h"
 
 #define UML_DIR "~/.uml/"
 
diff --git a/arch/um/os-Linux/util.c b/arch/um/os-Linux/util.c
index 5803b18..9e3b43b 100644
--- a/arch/um/os-Linux/util.c
+++ b/arch/um/os-Linux/util.c
@@ -13,9 +13,7 @@
 #include <wait.h>
 #include <sys/mman.h>
 #include <sys/utsname.h>
-#include "kern_constants.h"
 #include "os.h"
-#include "user.h"
 
 void stack_protections(unsigned long address)
 {
diff --git a/arch/um/scripts/Makefile.rules b/arch/um/scripts/Makefile.rules
index 61107b6..3a7efb0 100644
--- a/arch/um/scripts/Makefile.rules
+++ b/arch/um/scripts/Makefile.rules
@@ -8,7 +8,7 @@ USER_OBJS += $(filter %_user.o,$(obj-y) $(obj-m)  $(USER_SINGLE_OBJS))
 USER_OBJS := $(foreach file,$(USER_OBJS),$(obj)/$(file))
 
 $(USER_OBJS:.o=.%): \
-	c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS) $(CFLAGS_$(basetarget).o)
+	c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS) -include user.h $(CFLAGS_$(basetarget).o)
 $(USER_OBJS) : CHECKFLAGS := -D__linux__ -Dlinux -D__STDC__ \
 	-Dunix -D__unix__ -D__$(SUBARCH)__ $(CF)
 
diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index e5e56d7..231bb98 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -15,8 +15,8 @@ subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
 USER_OBJS := bugs.o ptrace_user.o fault.o
 
-USER_OBJS += user-offsets.s
 extra-y += user-offsets.s
+$(obj)/user-offsets.s: c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS)
 
 UNPROFILE_OBJS := stub_segv.o
 CFLAGS_stub_segv.o := $(CFLAGS_NO_HARDENING)
diff --git a/arch/um/sys-i386/bugs.c b/arch/um/sys-i386/bugs.c
index 2c6d0d7..7058e1f 100644
--- a/arch/um/sys-i386/bugs.c
+++ b/arch/um/sys-i386/bugs.c
@@ -4,11 +4,9 @@
  */
 
 #include <signal.h>
-#include "kern_constants.h"
 #include "kern_util.h"
 #include "longjmp.h"
 #include "task.h"
-#include "user.h"
 #include "sysdep/ptrace.h"
 
 /* Set during early boot */
diff --git a/arch/um/sys-i386/shared/sysdep/stub.h b/arch/um/sys-i386/shared/sysdep/stub.h
index 977dedd..cca14d4 100644
--- a/arch/um/sys-i386/shared/sysdep/stub.h
+++ b/arch/um/sys-i386/shared/sysdep/stub.h
@@ -11,7 +11,6 @@
 #include <asm/unistd.h>
 #include "as-layout.h"
 #include "stub-data.h"
-#include "kern_constants.h"
 
 extern void stub_segv_handler(int sig);
 extern void stub_clone_handler(void);
diff --git a/arch/um/sys-x86_64/Makefile b/arch/um/sys-x86_64/Makefile
index bd4d1d3..0971846 100644
--- a/arch/um/sys-x86_64/Makefile
+++ b/arch/um/sys-x86_64/Makefile
@@ -18,8 +18,8 @@ ldt-y = ../sys-i386/ldt.o
 
 USER_OBJS := ptrace_user.o
 
-USER_OBJS += user-offsets.s
 extra-y += user-offsets.s
+$(obj)/user-offsets.s: c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS)
 
 UNPROFILE_OBJS := stub_segv.o
 CFLAGS_stub_segv.o := $(CFLAGS_NO_HARDENING)
diff --git a/arch/um/sys-x86_64/shared/sysdep/stub.h b/arch/um/sys-x86_64/shared/sysdep/stub.h
index 3432aa2..922a570 100644
--- a/arch/um/sys-x86_64/shared/sysdep/stub.h
+++ b/arch/um/sys-x86_64/shared/sysdep/stub.h
@@ -11,7 +11,6 @@
 #include <sysdep/ptrace_user.h>
 #include "as-layout.h"
 #include "stub-data.h"
-#include "kern_constants.h"
 
 extern void stub_segv_handler(int sig);
 extern void stub_clone_handler(void);
-- 
1.7.2.5


