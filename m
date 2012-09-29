Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab2I2RId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 13:08:33 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:44620 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab2I2RHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 13:07:47 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        x86@kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/4] arch/um/os-Linux: Drop UM_ prefix from printk() level specifiers
Date: Sat, 29 Sep 2012 19:07:38 +0200
Message-Id: <1348938460-20919-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1348938460-20919-1-git-send-email-geert@linux-m68k.org>
References: <1348938460-20919-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 9429ec96c2718c0d1e3317cf60a87a0405223814 ("um: Preinclude
include/linux/kern_levels.h") the non-prefixed printk() level specifiers
are usable for the user parts of UML.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/um/os-Linux/aio.c                   |   26 +++++-----
 arch/um/os-Linux/drivers/ethertap_user.c |   20 ++++----
 arch/um/os-Linux/drivers/tuntap_user.c   |   14 +++---
 arch/um/os-Linux/file.c                  |   22 ++++----
 arch/um/os-Linux/helper.c                |   18 +++---
 arch/um/os-Linux/irq.c                   |    4 +-
 arch/um/os-Linux/process.c               |   22 ++++----
 arch/um/os-Linux/sigio.c                 |   52 ++++++++++----------
 arch/um/os-Linux/skas/mem.c              |   20 ++++----
 arch/um/os-Linux/skas/process.c          |   80 +++++++++++++++---------------
 arch/um/os-Linux/time.c                  |    2 +-
 arch/um/os-Linux/tty.c                   |    6 +-
 arch/um/os-Linux/umid.c                  |   28 +++++-----
 13 files changed, 157 insertions(+), 157 deletions(-)

diff --git a/arch/um/os-Linux/aio.c b/arch/um/os-Linux/aio.c
index c5d039e..c300147 100644
--- a/arch/um/os-Linux/aio.c
+++ b/arch/um/os-Linux/aio.c
@@ -88,7 +88,7 @@ static int do_aio(aio_context_t ctx, enum aio_type type, int fd, char *buf,
 		iocbp->aio_nbytes = sizeof(c);
 		break;
 	default:
-		printk(UM_KERN_ERR "Bogus op in do_aio - %d\n", type);
+		printk(KERN_ERR "Bogus op in do_aio - %d\n", type);
 		return -EINVAL;
 	}
 
@@ -111,7 +111,7 @@ static int aio_thread(void *arg)
 		if (n < 0) {
 			if (errno == EINTR)
 				continue;
-			printk(UM_KERN_ERR "aio_thread - io_getevents failed, "
+			printk(KERN_ERR "aio_thread - io_getevents failed, "
 			       "errno = %d\n", errno);
 		}
 		else {
@@ -121,7 +121,7 @@ static int aio_thread(void *arg)
 			reply_fd = ((struct aio_context *) reply.data)->reply_fd;
 			err = write(reply_fd, &reply, sizeof(reply));
 			if (err != sizeof(reply))
-				printk(UM_KERN_ERR "aio_thread - write failed, "
+				printk(KERN_ERR "aio_thread - write failed, "
 				       "fd = %d, err = %d\n", reply_fd, errno);
 		}
 	}
@@ -151,7 +151,7 @@ static int do_not_aio(struct aio_thread_req *req)
 		n = read(req->io_fd, &c, sizeof(c));
 		break;
 	default:
-		printk(UM_KERN_ERR "do_not_aio - bad request type : %d\n",
+		printk(KERN_ERR "do_not_aio - bad request type : %d\n",
 		       req->type);
 		return -EINVAL;
 	}
@@ -178,12 +178,12 @@ static int not_aio_thread(void *arg)
 		err = read(aio_req_fd_r, &req, sizeof(req));
 		if (err != sizeof(req)) {
 			if (err < 0)
-				printk(UM_KERN_ERR "not_aio_thread - "
+				printk(KERN_ERR "not_aio_thread - "
 				       "read failed, fd = %d, err = %d\n",
 				       aio_req_fd_r,
 				       errno);
 			else {
-				printk(UM_KERN_ERR "not_aio_thread - short "
+				printk(KERN_ERR "not_aio_thread - short "
 				       "read, fd = %d, length = %d\n",
 				       aio_req_fd_r, err);
 			}
@@ -194,7 +194,7 @@ static int not_aio_thread(void *arg)
 						     .err	= err });
 		err = write(req.aio->reply_fd, &reply, sizeof(reply));
 		if (err != sizeof(reply))
-			printk(UM_KERN_ERR "not_aio_thread - write failed, "
+			printk(KERN_ERR "not_aio_thread - write failed, "
 			       "fd = %d, err = %d\n", req.aio->reply_fd, errno);
 	}
 
@@ -231,10 +231,10 @@ out_close_pipe:
 	aio_req_fd_r = -1;
 out:
 #ifndef HAVE_AIO_ABI
-	printk(UM_KERN_INFO "/usr/include/linux/aio_abi.h not present during "
+	printk(KERN_INFO "/usr/include/linux/aio_abi.h not present during "
 	       "build\n");
 #endif
-	printk(UM_KERN_INFO "2.6 host AIO support not used - falling back to "
+	printk(KERN_INFO "2.6 host AIO support not used - falling back to "
 	       "I/O thread\n");
 	return 0;
 }
@@ -247,7 +247,7 @@ static int init_aio_26(void)
 
 	if (io_setup(256, &ctx)) {
 		err = -errno;
-		printk(UM_KERN_ERR "aio_thread failed to initialize context, "
+		printk(KERN_ERR "aio_thread failed to initialize context, "
 		       "err = %d\n", errno);
 		return err;
 	}
@@ -259,7 +259,7 @@ static int init_aio_26(void)
 
 	aio_pid = err;
 
-	printk(UM_KERN_INFO "Using 2.6 host AIO\n");
+	printk(KERN_INFO "Using 2.6 host AIO\n");
 	return 0;
 }
 
@@ -276,7 +276,7 @@ static int submit_aio_26(enum aio_type type, int io_fd, char *buf, int len,
 		err = write(aio->reply_fd, &reply, sizeof(reply));
 		if (err != sizeof(reply)) {
 			err = -errno;
-			printk(UM_KERN_ERR "submit_aio_26 - write failed, "
+			printk(KERN_ERR "submit_aio_26 - write failed, "
 			       "fd = %d, err = %d\n", aio->reply_fd, -err);
 		}
 		else err = 0;
@@ -327,7 +327,7 @@ static int init_aio(void)
 	if (!aio_24) {
 		err = init_aio_26();
 		if (err && (errno == ENOSYS)) {
-			printk(UM_KERN_INFO "2.6 AIO not supported on the "
+			printk(KERN_INFO "2.6 AIO not supported on the "
 			       "host - reverting to 2.4 AIO\n");
 			aio_24 = 1;
 		}
diff --git a/arch/um/os-Linux/drivers/ethertap_user.c b/arch/um/os-Linux/drivers/ethertap_user.c
index db3d648..041bea0 100644
--- a/arch/um/os-Linux/drivers/ethertap_user.c
+++ b/arch/um/os-Linux/drivers/ethertap_user.c
@@ -45,14 +45,14 @@ static void etap_change(int op, unsigned char *addr, unsigned char *netmask,
 	memcpy(change.netmask, netmask, sizeof(change.netmask));
 	CATCH_EINTR(n = write(fd, &change, sizeof(change)));
 	if (n != sizeof(change)) {
-		printk(UM_KERN_ERR "etap_change - request failed, err = %d\n",
+		printk(KERN_ERR "etap_change - request failed, err = %d\n",
 		       errno);
 		return;
 	}
 
 	output = uml_kmalloc(UM_KERN_PAGE_SIZE, UM_GFP_KERNEL);
 	if (output == NULL)
-		printk(UM_KERN_ERR "etap_change : Failed to allocate output "
+		printk(KERN_ERR "etap_change : Failed to allocate output "
 		       "buffer\n");
 	read_output(fd, output, UM_KERN_PAGE_SIZE);
 	if (output != NULL) {
@@ -123,12 +123,12 @@ static int etap_tramp(char *dev, char *gate, int control_me,
 	CATCH_EINTR(n = read(control_me, &c, sizeof(c)));
 	if (n != sizeof(c)) {
 		err = -errno;
-		printk(UM_KERN_ERR "etap_tramp : read of status failed, "
+		printk(KERN_ERR "etap_tramp : read of status failed, "
 		       "err = %d\n", -err);
 		return err;
 	}
 	if (c != 1) {
-		printk(UM_KERN_ERR "etap_tramp : uml_net failed\n");
+		printk(KERN_ERR "etap_tramp : uml_net failed\n");
 		err = helper_wait(pid);
 	}
 	return err;
@@ -147,7 +147,7 @@ static int etap_open(void *data)
 	err = socketpair(AF_UNIX, SOCK_DGRAM, 0, data_fds);
 	if (err) {
 		err = -errno;
-		printk(UM_KERN_ERR "etap_open - data socketpair failed - "
+		printk(KERN_ERR "etap_open - data socketpair failed - "
 		       "err = %d\n", errno);
 		return err;
 	}
@@ -155,7 +155,7 @@ static int etap_open(void *data)
 	err = socketpair(AF_UNIX, SOCK_STREAM, 0, control_fds);
 	if (err) {
 		err = -errno;
-		printk(UM_KERN_ERR "etap_open - control socketpair failed - "
+		printk(KERN_ERR "etap_open - control socketpair failed - "
 		       "err = %d\n", errno);
 		goto out_close_data;
 	}
@@ -167,7 +167,7 @@ static int etap_open(void *data)
 	read_output(control_fds[0], output, output_len);
 
 	if (output == NULL)
-		printk(UM_KERN_ERR "etap_open : failed to allocate output "
+		printk(KERN_ERR "etap_open : failed to allocate output "
 		       "buffer\n");
 	else {
 		printk("%s", output);
@@ -175,7 +175,7 @@ static int etap_open(void *data)
 	}
 
 	if (err < 0) {
-		printk(UM_KERN_ERR "etap_tramp failed - err = %d\n", -err);
+		printk(KERN_ERR "etap_tramp failed - err = %d\n", -err);
 		goto out_close_control;
 	}
 
@@ -201,11 +201,11 @@ static void etap_close(int fd, void *data)
 	close(fd);
 
 	if (shutdown(pri->data_fd, SHUT_RDWR) < 0)
-		printk(UM_KERN_ERR "etap_close - shutdown data socket failed, "
+		printk(KERN_ERR "etap_close - shutdown data socket failed, "
 		       "errno = %d\n", errno);
 
 	if (shutdown(pri->control_fd, SHUT_RDWR) < 0)
-		printk(UM_KERN_ERR "etap_close - shutdown control socket "
+		printk(KERN_ERR "etap_close - shutdown control socket "
 		       "failed, errno = %d\n", errno);
 
 	close(pri->data_fd);
diff --git a/arch/um/os-Linux/drivers/tuntap_user.c b/arch/um/os-Linux/drivers/tuntap_user.c
index a2aacff..78f3705 100644
--- a/arch/um/os-Linux/drivers/tuntap_user.c
+++ b/arch/um/os-Linux/drivers/tuntap_user.c
@@ -102,7 +102,7 @@ static int tuntap_open_tramp(char *gate, int *fd_out, int me, int remote,
 	*used_out = n;
 	if (n < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "tuntap_open_tramp : recvmsg failed - "
+		printk(KERN_ERR "tuntap_open_tramp : recvmsg failed - "
 		       "errno = %d\n", errno);
 		return err;
 	}
@@ -110,13 +110,13 @@ static int tuntap_open_tramp(char *gate, int *fd_out, int me, int remote,
 
 	cmsg = CMSG_FIRSTHDR(&msg);
 	if (cmsg == NULL) {
-		printk(UM_KERN_ERR "tuntap_open_tramp : didn't receive a "
+		printk(KERN_ERR "tuntap_open_tramp : didn't receive a "
 		       "message\n");
 		return -EINVAL;
 	}
 	if ((cmsg->cmsg_level != SOL_SOCKET) ||
 	   (cmsg->cmsg_type != SCM_RIGHTS)) {
-		printk(UM_KERN_ERR "tuntap_open_tramp : didn't receive a "
+		printk(KERN_ERR "tuntap_open_tramp : didn't receive a "
 		       "descriptor\n");
 		return -EINVAL;
 	}
@@ -140,7 +140,7 @@ static int tuntap_open(void *data)
 		pri->fd = os_open_file("/dev/net/tun",
 				       of_cloexec(of_rdwr(OPENFLAGS())), 0);
 		if (pri->fd < 0) {
-			printk(UM_KERN_ERR "Failed to open /dev/net/tun, "
+			printk(KERN_ERR "Failed to open /dev/net/tun, "
 			       "err = %d\n", -pri->fd);
 			return pri->fd;
 		}
@@ -149,7 +149,7 @@ static int tuntap_open(void *data)
 		strlcpy(ifr.ifr_name, pri->dev_name, sizeof(ifr.ifr_name));
 		if (ioctl(pri->fd, TUNSETIFF, &ifr) < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "TUNSETIFF failed, errno = %d\n",
+			printk(KERN_ERR "TUNSETIFF failed, errno = %d\n",
 			       errno);
 			close(pri->fd);
 			return err;
@@ -159,7 +159,7 @@ static int tuntap_open(void *data)
 		err = socketpair(AF_UNIX, SOCK_DGRAM, 0, fds);
 		if (err) {
 			err = -errno;
-			printk(UM_KERN_ERR "tuntap_open : socketpair failed - "
+			printk(KERN_ERR "tuntap_open : socketpair failed - "
 			       "errno = %d\n", errno);
 			return err;
 		}
@@ -176,7 +176,7 @@ static int tuntap_open(void *data)
 		if (err < 0) {
 			printk("%s", output);
 			free_output_buffer(buffer);
-			printk(UM_KERN_ERR "tuntap_open_tramp failed - "
+			printk(KERN_ERR "tuntap_open_tramp failed - "
 			       "err = %d\n", -err);
 			return err;
 		}
diff --git a/arch/um/os-Linux/file.c b/arch/um/os-Linux/file.c
index b049a63..d2f8697 100644
--- a/arch/um/os-Linux/file.c
+++ b/arch/um/os-Linux/file.c
@@ -273,7 +273,7 @@ int os_file_size(const char *file, unsigned long long *size_out)
 
 	err = os_stat_file(file, &buf);
 	if (err < 0) {
-		printk(UM_KERN_ERR "Couldn't stat \"%s\" : err = %d\n", file,
+		printk(KERN_ERR "Couldn't stat \"%s\" : err = %d\n", file,
 		       -err);
 		return err;
 	}
@@ -285,13 +285,13 @@ int os_file_size(const char *file, unsigned long long *size_out)
 		fd = open(file, O_RDONLY, 0);
 		if (fd < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "Couldn't open \"%s\", "
+			printk(KERN_ERR "Couldn't open \"%s\", "
 			       "errno = %d\n", file, errno);
 			return err;
 		}
 		if (ioctl(fd, BLKGETSIZE, &blocks) < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "Couldn't get the block size of "
+			printk(KERN_ERR "Couldn't get the block size of "
 			       "\"%s\", errno = %d\n", file, errno);
 			close(fd);
 			return err;
@@ -311,7 +311,7 @@ int os_file_modtime(const char *file, unsigned long *modtime)
 
 	err = os_stat_file(file, &buf);
 	if (err < 0) {
-		printk(UM_KERN_ERR "Couldn't stat \"%s\" : err = %d\n", file,
+		printk(KERN_ERR "Couldn't stat \"%s\" : err = %d\n", file,
 		       -err);
 		return err;
 	}
@@ -353,7 +353,7 @@ int os_pipe(int *fds, int stream, int close_on_exec)
 	return 0;
 
  error:
-	printk(UM_KERN_ERR "os_pipe : Setting FD_CLOEXEC failed, err = %d\n",
+	printk(KERN_ERR "os_pipe : Setting FD_CLOEXEC failed, err = %d\n",
 	       -err);
 	close(fds[1]);
 	close(fds[0]);
@@ -371,7 +371,7 @@ int os_set_fd_async(int fd)
 	flags |= O_ASYNC | O_NONBLOCK;
 	if (fcntl(fd, F_SETFL, flags) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "os_set_fd_async : failed to set O_ASYNC "
+		printk(KERN_ERR "os_set_fd_async : failed to set O_ASYNC "
 		       "and O_NONBLOCK on fd # %d, errno = %d\n", fd, errno);
 		return err;
 	}
@@ -379,7 +379,7 @@ int os_set_fd_async(int fd)
 	if ((fcntl(fd, F_SETSIG, SIGIO) < 0) ||
 	    (fcntl(fd, F_SETOWN, os_getpid()) < 0)) {
 		err = -errno;
-		printk(UM_KERN_ERR "os_set_fd_async : Failed to fcntl F_SETOWN "
+		printk(KERN_ERR "os_set_fd_async : Failed to fcntl F_SETOWN "
 		       "(or F_SETSIG) fd %d, errno = %d\n", fd, errno);
 		return err;
 	}
@@ -487,13 +487,13 @@ int os_rcv_fd(int fd, int *helper_pid_out)
 
 	cmsg = CMSG_FIRSTHDR(&msg);
 	if (cmsg == NULL) {
-		printk(UM_KERN_ERR "rcv_fd didn't receive anything, "
+		printk(KERN_ERR "rcv_fd didn't receive anything, "
 		       "error = %d\n", errno);
 		return -1;
 	}
 	if ((cmsg->cmsg_level != SOL_SOCKET) ||
 	    (cmsg->cmsg_type != SCM_RIGHTS)) {
-		printk(UM_KERN_ERR "rcv_fd didn't receive a descriptor\n");
+		printk(KERN_ERR "rcv_fd didn't receive a descriptor\n");
 		return -1;
 	}
 
@@ -513,7 +513,7 @@ int os_create_unix_socket(const char *file, int len, int close_on_exec)
 	if (close_on_exec) {
 		err = os_set_exec_close(sock);
 		if (err < 0)
-			printk(UM_KERN_ERR "create_unix_socket : "
+			printk(KERN_ERR "create_unix_socket : "
 			       "close_on_exec failed, err = %d", -err);
 	}
 
@@ -553,7 +553,7 @@ int os_lock_file(int fd, int excl)
 		goto out;
 	}
 
-	printk(UM_KERN_ERR "F_SETLK failed, file already locked by pid %d\n",
+	printk(KERN_ERR "F_SETLK failed, file already locked by pid %d\n",
 	       lock.l_pid);
 	err = save;
  out:
diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index cf26c4a..549b51c 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -52,14 +52,14 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	ret = socketpair(AF_UNIX, SOCK_STREAM, 0, fds);
 	if (ret < 0) {
 		ret = -errno;
-		printk(UM_KERN_ERR "run_helper : pipe failed, errno = %d\n",
+		printk(KERN_ERR "run_helper : pipe failed, errno = %d\n",
 		       errno);
 		goto out_free;
 	}
 
 	ret = os_set_exec_close(fds[1]);
 	if (ret < 0) {
-		printk(UM_KERN_ERR "run_helper : setting FD_CLOEXEC failed, "
+		printk(KERN_ERR "run_helper : setting FD_CLOEXEC failed, "
 		       "ret = %d\n", -ret);
 		goto out_close;
 	}
@@ -74,7 +74,7 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	pid = clone(helper_child, (void *) sp, CLONE_VM, &data);
 	if (pid < 0) {
 		ret = -errno;
-		printk(UM_KERN_ERR "run_helper : clone failed, errno = %d\n",
+		printk(KERN_ERR "run_helper : clone failed, errno = %d\n",
 		       errno);
 		goto out_free2;
 	}
@@ -92,7 +92,7 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	} else {
 		if (n < 0) {
 			n = -errno;
-			printk(UM_KERN_ERR "run_helper : read on pipe failed, "
+			printk(KERN_ERR "run_helper : read on pipe failed, "
 			       "ret = %d\n", -n);
 			ret = n;
 		}
@@ -124,7 +124,7 @@ int run_helper_thread(int (*proc)(void *), void *arg, unsigned int flags,
 	pid = clone(proc, (void *) sp, flags, arg);
 	if (pid < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "run_helper_thread : clone failed, "
+		printk(KERN_ERR "run_helper_thread : clone failed, "
 		       "errno = %d\n", errno);
 		return err;
 	}
@@ -132,12 +132,12 @@ int run_helper_thread(int (*proc)(void *), void *arg, unsigned int flags,
 		CATCH_EINTR(pid = waitpid(pid, &status, __WCLONE));
 		if (pid < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "run_helper_thread - wait failed, "
+			printk(KERN_ERR "run_helper_thread - wait failed, "
 			       "errno = %d\n", errno);
 			pid = err;
 		}
 		if (!WIFEXITED(status) || (WEXITSTATUS(status) != 0))
-			printk(UM_KERN_ERR "run_helper_thread - thread "
+			printk(KERN_ERR "run_helper_thread - thread "
 			       "returned status 0x%x\n", status);
 		free_stack(stack, 0);
 	} else
@@ -152,11 +152,11 @@ int helper_wait(int pid)
 
 	CATCH_EINTR(ret = waitpid(pid, &status, wflags));
 	if (ret < 0) {
-		printk(UM_KERN_ERR "helper_wait : waitpid process %d failed, "
+		printk(KERN_ERR "helper_wait : waitpid process %d failed, "
 		       "errno = %d\n", pid, errno);
 		return -errno;
 	} else if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
-		printk(UM_KERN_ERR "helper_wait : process %d exited with "
+		printk(KERN_ERR "helper_wait : process %d exited with "
 		       "status 0x%x\n", pid, status);
 		return -ECHILD;
 	} else
diff --git a/arch/um/os-Linux/irq.c b/arch/um/os-Linux/irq.c
index 9a49908..c7c4202 100644
--- a/arch/um/os-Linux/irq.c
+++ b/arch/um/os-Linux/irq.c
@@ -29,7 +29,7 @@ int os_waiting_for_events(struct irq_fd *active_fds)
 	if (n < 0) {
 		err = -errno;
 		if (errno != EINTR)
-			printk(UM_KERN_ERR "os_waiting_for_events:"
+			printk(KERN_ERR "os_waiting_for_events:"
 			       " poll returned %d, errno = %d\n", n, errno);
 		return err;
 	}
@@ -88,7 +88,7 @@ void os_free_irq_by_cb(int (*test)(struct irq_fd *, void *), void *arg,
 			struct irq_fd *old_fd = *prev;
 			if ((pollfds[i].fd != -1) &&
 			    (pollfds[i].fd != (*prev)->fd)) {
-				printk(UM_KERN_ERR "os_free_irq_by_cb - "
+				printk(KERN_ERR "os_free_irq_by_cb - "
 				       "mismatch between active_fds and "
 				       "pollfds, fd %d vs %d\n",
 				       (*prev)->fd, pollfds[i].fd);
diff --git a/arch/um/os-Linux/process.c b/arch/um/os-Linux/process.c
index 307f173..45e54b9 100644
--- a/arch/um/os-Linux/process.c
+++ b/arch/um/os-Linux/process.c
@@ -32,13 +32,13 @@ unsigned long os_process_pc(int pid)
 	sprintf(proc_stat, "/proc/%d/stat", pid);
 	fd = open(proc_stat, O_RDONLY, 0);
 	if (fd < 0) {
-		printk(UM_KERN_ERR "os_process_pc - couldn't open '%s', "
+		printk(KERN_ERR "os_process_pc - couldn't open '%s', "
 		       "errno = %d\n", proc_stat, errno);
 		goto out;
 	}
 	CATCH_EINTR(err = read(fd, buf, sizeof(buf)));
 	if (err < 0) {
-		printk(UM_KERN_ERR "os_process_pc - couldn't read '%s', "
+		printk(KERN_ERR "os_process_pc - couldn't read '%s', "
 		       "err = %d\n", proc_stat, errno);
 		goto out_close;
 	}
@@ -47,7 +47,7 @@ unsigned long os_process_pc(int pid)
 	if (sscanf(buf, "%*d " COMM_SCANF " %*c %*d %*d %*d %*d %*d %*d %*d "
 		   "%*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d "
 		   "%*d %*d %*d %*d %*d %lu", &pc) != 1)
-		printk(UM_KERN_ERR "os_process_pc - couldn't find pc in '%s'\n",
+		printk(KERN_ERR "os_process_pc - couldn't find pc in '%s'\n",
 		       buf);
  out_close:
 	close(fd);
@@ -67,7 +67,7 @@ int os_process_parent(int pid)
 	snprintf(stat, sizeof(stat), "/proc/%d/stat", pid);
 	fd = open(stat, O_RDONLY, 0);
 	if (fd < 0) {
-		printk(UM_KERN_ERR "Couldn't open '%s', errno = %d\n", stat,
+		printk(KERN_ERR "Couldn't open '%s', errno = %d\n", stat,
 		       errno);
 		return parent;
 	}
@@ -76,7 +76,7 @@ int os_process_parent(int pid)
 	close(fd);
 
 	if (n < 0) {
-		printk(UM_KERN_ERR "Couldn't read '%s', errno = %d\n", stat,
+		printk(KERN_ERR "Couldn't read '%s', errno = %d\n", stat,
 		       errno);
 		return parent;
 	}
@@ -84,7 +84,7 @@ int os_process_parent(int pid)
 	parent = FAILURE_PID;
 	n = sscanf(data, "%*d " COMM_SCANF " %*c %d", &parent);
 	if (n != 1)
-		printk(UM_KERN_ERR "Failed to scan '%s'\n", data);
+		printk(KERN_ERR "Failed to scan '%s'\n", data);
 
 	return parent;
 }
@@ -200,10 +200,10 @@ int __init can_drop_memory(void)
 	void *addr;
 	int fd, ok = 0;
 
-	printk(UM_KERN_INFO "Checking host MADV_REMOVE support...");
+	printk(KERN_INFO "Checking host MADV_REMOVE support...");
 	fd = create_mem_file(UM_KERN_PAGE_SIZE);
 	if (fd < 0) {
-		printk(UM_KERN_ERR "Creating test memory file failed, "
+		printk(KERN_ERR "Creating test memory file failed, "
 		       "err = %d\n", -fd);
 		goto out;
 	}
@@ -211,17 +211,17 @@ int __init can_drop_memory(void)
 	addr = mmap64(NULL, UM_KERN_PAGE_SIZE, PROT_READ | PROT_WRITE,
 		      MAP_SHARED, fd, 0);
 	if (addr == MAP_FAILED) {
-		printk(UM_KERN_ERR "Mapping test memory file failed, "
+		printk(KERN_ERR "Mapping test memory file failed, "
 		       "err = %d\n", -errno);
 		goto out_close;
 	}
 
 	if (madvise(addr, UM_KERN_PAGE_SIZE, MADV_REMOVE) != 0) {
-		printk(UM_KERN_ERR "MADV_REMOVE failed, err = %d\n", -errno);
+		printk(KERN_ERR "MADV_REMOVE failed, err = %d\n", -errno);
 		goto out_unmap;
 	}
 
-	printk(UM_KERN_CONT "OK\n");
+	printk(KERN_CONT "OK\n");
 	ok = 1;
 
 out_unmap:
diff --git a/arch/um/os-Linux/sigio.c b/arch/um/os-Linux/sigio.c
index 3c16121..2cb8975 100644
--- a/arch/um/os-Linux/sigio.c
+++ b/arch/um/os-Linux/sigio.c
@@ -62,7 +62,7 @@ static int write_sigio_thread(void *unused)
 		if (n < 0) {
 			if (errno == EINTR)
 				continue;
-			printk(UM_KERN_ERR "write_sigio_thread : poll returned "
+			printk(KERN_ERR "write_sigio_thread : poll returned "
 			       "%d, errno = %d\n", n, errno);
 		}
 		for (i = 0; i < fds->used; i++) {
@@ -73,7 +73,7 @@ static int write_sigio_thread(void *unused)
 				CATCH_EINTR(n = read(sigio_private[1], &c,
 						     sizeof(c)));
 				if (n != sizeof(c))
-					printk(UM_KERN_ERR
+					printk(KERN_ERR
 					       "write_sigio_thread : "
 					       "read on socket failed, "
 					       "err = %d\n", errno);
@@ -91,7 +91,7 @@ static int write_sigio_thread(void *unused)
 
 			CATCH_EINTR(n = write(respond_fd, &c, sizeof(c)));
 			if (n != sizeof(c))
-				printk(UM_KERN_ERR "write_sigio_thread : "
+				printk(KERN_ERR "write_sigio_thread : "
 				       "write on socket failed, err = %d\n",
 				       errno);
 		}
@@ -109,7 +109,7 @@ static int need_poll(struct pollfds *polls, int n)
 
 	new = uml_kmalloc(n * sizeof(struct pollfd), UM_GFP_ATOMIC);
 	if (new == NULL) {
-		printk(UM_KERN_ERR "need_poll : failed to allocate new "
+		printk(KERN_ERR "need_poll : failed to allocate new "
 		       "pollfds\n");
 		return -ENOMEM;
 	}
@@ -135,14 +135,14 @@ static void update_thread(void)
 	flags = set_signals(0);
 	CATCH_EINTR(n = write(sigio_private[0], &c, sizeof(c)));
 	if (n != sizeof(c)) {
-		printk(UM_KERN_ERR "update_thread : write failed, err = %d\n",
+		printk(KERN_ERR "update_thread : write failed, err = %d\n",
 		       errno);
 		goto fail;
 	}
 
 	CATCH_EINTR(n = read(sigio_private[0], &c, sizeof(c)));
 	if (n != sizeof(c)) {
-		printk(UM_KERN_ERR "update_thread : read failed, err = %d\n",
+		printk(KERN_ERR "update_thread : read failed, err = %d\n",
 		       errno);
 		goto fail;
 	}
@@ -243,7 +243,7 @@ static struct pollfd *setup_initial_poll(int fd)
 
 	p = uml_kmalloc(sizeof(struct pollfd), UM_GFP_KERNEL);
 	if (p == NULL) {
-		printk(UM_KERN_ERR "setup_initial_poll : failed to allocate "
+		printk(KERN_ERR "setup_initial_poll : failed to allocate "
 		       "poll\n");
 		return NULL;
 	}
@@ -271,13 +271,13 @@ static void write_sigio_workaround(void)
 
 	err = os_pipe(l_write_sigio_fds, 1, 1);
 	if (err < 0) {
-		printk(UM_KERN_ERR "write_sigio_workaround - os_pipe 1 failed, "
+		printk(KERN_ERR "write_sigio_workaround - os_pipe 1 failed, "
 		       "err = %d\n", -err);
 		return;
 	}
 	err = os_pipe(l_sigio_private, 1, 1);
 	if (err < 0) {
-		printk(UM_KERN_ERR "write_sigio_workaround - os_pipe 2 failed, "
+		printk(KERN_ERR "write_sigio_workaround - os_pipe 2 failed, "
 		       "err = %d\n", -err);
 		goto out_close1;
 	}
@@ -345,7 +345,7 @@ void sigio_broken(int fd, int read)
 	sigio_lock();
 	err = need_poll(&all_sigio_fds, all_sigio_fds.used + 1);
 	if (err) {
-		printk(UM_KERN_ERR "maybe_sigio_broken - failed to add pollfd "
+		printk(KERN_ERR "maybe_sigio_broken - failed to add pollfd "
 		       "for descriptor %d\n", fd);
 		goto out;
 	}
@@ -434,7 +434,7 @@ static void __init check_one_sigio(void (*proc)(int, int))
 
 	initial_thread_cb(openpty_cb, &pty);
 	if (pty.err) {
-		printk(UM_KERN_ERR "check_one_sigio failed, errno = %d\n",
+		printk(KERN_ERR "check_one_sigio failed, errno = %d\n",
 		       -pty.err);
 		return;
 	}
@@ -443,7 +443,7 @@ static void __init check_one_sigio(void (*proc)(int, int))
 	slave = pty.slave;
 
 	if ((master == -1) || (slave == -1)) {
-		printk(UM_KERN_ERR "check_one_sigio failed to allocate a "
+		printk(KERN_ERR "check_one_sigio failed to allocate a "
 		       "pty\n");
 		return;
 	}
@@ -451,20 +451,20 @@ static void __init check_one_sigio(void (*proc)(int, int))
 	/* Not now, but complain so we now where we failed. */
 	err = raw(master);
 	if (err < 0) {
-		printk(UM_KERN_ERR "check_one_sigio : raw failed, errno = %d\n",
+		printk(KERN_ERR "check_one_sigio : raw failed, errno = %d\n",
 		      -err);
 		return;
 	}
 
 	err = async_pty(master, slave);
 	if (err < 0) {
-		printk(UM_KERN_ERR "check_one_sigio : sigio_async failed, "
+		printk(KERN_ERR "check_one_sigio : sigio_async failed, "
 		       "err = %d\n", -err);
 		return;
 	}
 
 	if (sigaction(SIGIO, NULL, &old) < 0) {
-		printk(UM_KERN_ERR "check_one_sigio : sigaction 1 failed, "
+		printk(KERN_ERR "check_one_sigio : sigaction 1 failed, "
 		       "errno = %d\n", errno);
 		return;
 	}
@@ -472,7 +472,7 @@ static void __init check_one_sigio(void (*proc)(int, int))
 	new = old;
 	new.sa_handler = handler;
 	if (sigaction(SIGIO, &new, NULL) < 0) {
-		printk(UM_KERN_ERR "check_one_sigio : sigaction 2 failed, "
+		printk(KERN_ERR "check_one_sigio : sigaction 2 failed, "
 		       "errno = %d\n", errno);
 		return;
 	}
@@ -484,7 +484,7 @@ static void __init check_one_sigio(void (*proc)(int, int))
 	close(slave);
 
 	if (sigaction(SIGIO, &old, NULL) < 0)
-		printk(UM_KERN_ERR "check_one_sigio : sigaction 3 failed, "
+		printk(KERN_ERR "check_one_sigio : sigaction 3 failed, "
 		       "errno = %d\n", errno);
 }
 
@@ -493,45 +493,45 @@ static void tty_output(int master, int slave)
 	int n;
 	char buf[512];
 
-	printk(UM_KERN_INFO "Checking that host ptys support output SIGIO...");
+	printk(KERN_INFO "Checking that host ptys support output SIGIO...");
 
 	memset(buf, 0, sizeof(buf));
 
 	while (write(master, buf, sizeof(buf)) > 0) ;
 	if (errno != EAGAIN)
-		printk(UM_KERN_ERR "tty_output : write failed, errno = %d\n",
+		printk(KERN_ERR "tty_output : write failed, errno = %d\n",
 		       errno);
 	while (((n = read(slave, buf, sizeof(buf))) > 0) &&
 	       !({ barrier(); got_sigio; }))
 		;
 
 	if (got_sigio) {
-		printk(UM_KERN_CONT "Yes\n");
+		printk(KERN_CONT "Yes\n");
 		pty_output_sigio = 1;
 	} else if (n == -EAGAIN)
-		printk(UM_KERN_CONT "No, enabling workaround\n");
+		printk(KERN_CONT "No, enabling workaround\n");
 	else
-		printk(UM_KERN_CONT "tty_output : read failed, err = %d\n", n);
+		printk(KERN_CONT "tty_output : read failed, err = %d\n", n);
 }
 
 static void tty_close(int master, int slave)
 {
-	printk(UM_KERN_INFO "Checking that host ptys support SIGIO on "
+	printk(KERN_INFO "Checking that host ptys support SIGIO on "
 	       "close...");
 
 	close(slave);
 	if (got_sigio) {
-		printk(UM_KERN_CONT "Yes\n");
+		printk(KERN_CONT "Yes\n");
 		pty_close_sigio = 1;
 	} else
-		printk(UM_KERN_CONT "No, enabling workaround\n");
+		printk(KERN_CONT "No, enabling workaround\n");
 }
 
 static void __init check_sigio(void)
 {
 	if ((access("/dev/ptmx", R_OK) < 0) &&
 	    (access("/dev/ptyp0", R_OK) < 0)) {
-		printk(UM_KERN_WARNING "No pseudo-terminals available - "
+		printk(KERN_WARNING "No pseudo-terminals available - "
 		       "skipping pty SIGIO check\n");
 		return;
 	}
diff --git a/arch/um/os-Linux/skas/mem.c b/arch/um/os-Linux/skas/mem.c
index 90b310d..ae55e47 100644
--- a/arch/um/os-Linux/skas/mem.c
+++ b/arch/um/os-Linux/skas/mem.c
@@ -62,9 +62,9 @@ static inline long do_syscall_stub(struct mm_id * mm_idp, void **addr)
 
 	n = ptrace_setregs(pid, syscall_regs);
 	if (n < 0) {
-		printk(UM_KERN_ERR "Registers - \n");
+		printk(KERN_ERR "Registers - \n");
 		for (i = 0; i < MAX_REG_NR; i++)
-			printk(UM_KERN_ERR "\t%d\t0x%lx\n", i, syscall_regs[i]);
+			printk(KERN_ERR "\t%d\t0x%lx\n", i, syscall_regs[i]);
 		panic("do_syscall_stub : PTRACE_SETREGS failed, errno = %d\n",
 		      -n);
 	}
@@ -86,22 +86,22 @@ static inline long do_syscall_stub(struct mm_id * mm_idp, void **addr)
 	offset = *((unsigned long *) mm_idp->stack + 1);
 	if (offset) {
 		data = (unsigned long *)(mm_idp->stack + offset - STUB_DATA);
-		printk(UM_KERN_ERR "do_syscall_stub : ret = %ld, offset = %ld, "
+		printk(KERN_ERR "do_syscall_stub : ret = %ld, offset = %ld, "
 		       "data = %p\n", ret, offset, data);
 		syscall = (unsigned long *)((unsigned long)data + data[0]);
-		printk(UM_KERN_ERR "do_syscall_stub: syscall %ld failed, "
+		printk(KERN_ERR "do_syscall_stub: syscall %ld failed, "
 		       "return value = 0x%lx, expected return value = 0x%lx\n",
 		       syscall[0], ret, syscall[7]);
-		printk(UM_KERN_ERR "    syscall parameters: "
+		printk(KERN_ERR "    syscall parameters: "
 		       "0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
 		       syscall[1], syscall[2], syscall[3],
 		       syscall[4], syscall[5], syscall[6]);
 		for (n = 1; n < data[0]/sizeof(long); n++) {
 			if (n == 1)
-				printk(UM_KERN_ERR "    additional syscall "
+				printk(KERN_ERR "    additional syscall "
 				       "data:");
 			if (n % 4 == 1)
-				printk("\n" UM_KERN_ERR "      ");
+				printk("\n" KERN_ERR "      ");
 			printk("  0x%lx", data[n]);
 		}
 		if (n > 1)
@@ -197,7 +197,7 @@ int map(struct mm_id * mm_idp, unsigned long virt, unsigned long len, int prot,
 		CATCH_EINTR(ret = write(fd, &map, sizeof(map)));
 		if (ret != sizeof(map)) {
 			ret = -errno;
-			printk(UM_KERN_ERR "map : /proc/mm map failed, "
+			printk(KERN_ERR "map : /proc/mm map failed, "
 			       "err = %d\n", -ret);
 		}
 		else ret = 0;
@@ -232,7 +232,7 @@ int unmap(struct mm_id * mm_idp, unsigned long addr, unsigned long len,
 		CATCH_EINTR(ret = write(fd, &unmap, sizeof(unmap)));
 		if (ret != sizeof(unmap)) {
 			ret = -errno;
-			printk(UM_KERN_ERR "unmap - proc_mm write returned "
+			printk(KERN_ERR "unmap - proc_mm write returned "
 			       "%d\n", ret);
 		}
 		else ret = 0;
@@ -268,7 +268,7 @@ int protect(struct mm_id * mm_idp, unsigned long addr, unsigned long len,
 		CATCH_EINTR(ret = write(fd, &protect, sizeof(protect)));
 		if (ret != sizeof(protect)) {
 			ret = -errno;
-			printk(UM_KERN_ERR "protect failed, err = %d", -ret);
+			printk(KERN_ERR "protect failed, err = %d", -ret);
 		}
 		else ret = 0;
 	}
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index d93bb40..d7ce2c5 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -36,9 +36,9 @@ static int ptrace_dump_regs(int pid)
 	if (ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
 		return -errno;
 
-	printk(UM_KERN_ERR "Stub registers -\n");
+	printk(KERN_ERR "Stub registers -\n");
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		printk(UM_KERN_ERR "\t%d - %lx\n", i, regs[i]);
+		printk(KERN_ERR "\t%d - %lx\n", i, regs[i]);
 
 	return 0;
 }
@@ -66,7 +66,7 @@ void wait_stub_done(int pid)
 
 		err = ptrace(PTRACE_CONT, pid, 0, 0);
 		if (err) {
-			printk(UM_KERN_ERR "wait_stub_done : continue failed, "
+			printk(KERN_ERR "wait_stub_done : continue failed, "
 			       "errno = %d\n", errno);
 			fatal_sigsegv();
 		}
@@ -78,9 +78,9 @@ void wait_stub_done(int pid)
 bad_wait:
 	err = ptrace_dump_regs(pid);
 	if (err)
-		printk(UM_KERN_ERR "Failed to get registers from stub, "
+		printk(KERN_ERR "Failed to get registers from stub, "
 		       "errno = %d\n", -err);
-	printk(UM_KERN_ERR "wait_stub_done : failed to wait for SIGTRAP, "
+	printk(KERN_ERR "wait_stub_done : failed to wait for SIGTRAP, "
 	       "pid = %d, n = %d, errno = %d, status = 0x%x\n", pid, n, errno,
 	       status);
 	fatal_sigsegv();
@@ -95,7 +95,7 @@ static void get_skas_faultinfo(int pid, struct faultinfo *fi)
 	if (ptrace_faultinfo) {
 		err = ptrace(PTRACE_FAULTINFO, pid, 0, fi);
 		if (err) {
-			printk(UM_KERN_ERR "get_skas_faultinfo - "
+			printk(KERN_ERR "get_skas_faultinfo - "
 			       "PTRACE_FAULTINFO failed, errno = %d\n", errno);
 			fatal_sigsegv();
 		}
@@ -111,13 +111,13 @@ static void get_skas_faultinfo(int pid, struct faultinfo *fi)
 
 		err = get_fp_registers(pid, fpregs);
 		if (err < 0) {
-			printk(UM_KERN_ERR "save_fp_registers returned %d\n",
+			printk(KERN_ERR "save_fp_registers returned %d\n",
 			       err);
 			fatal_sigsegv();
 		}
 		err = ptrace(PTRACE_CONT, pid, 0, SIGSEGV);
 		if (err) {
-			printk(UM_KERN_ERR "Failed to continue stub, pid = %d, "
+			printk(KERN_ERR "Failed to continue stub, pid = %d, "
 			       "errno = %d\n", pid, errno);
 			fatal_sigsegv();
 		}
@@ -131,7 +131,7 @@ static void get_skas_faultinfo(int pid, struct faultinfo *fi)
 
 		err = put_fp_registers(pid, fpregs);
 		if (err < 0) {
-			printk(UM_KERN_ERR "put_fp_registers returned %d\n",
+			printk(KERN_ERR "put_fp_registers returned %d\n",
 			       err);
 			fatal_sigsegv();
 		}
@@ -164,14 +164,14 @@ static void handle_trap(int pid, struct uml_pt_regs *regs,
 		err = ptrace(PTRACE_POKEUSER, pid, PT_SYSCALL_NR_OFFSET,
 			     __NR_getpid);
 		if (err < 0) {
-			printk(UM_KERN_ERR "handle_trap - nullifying syscall "
+			printk(KERN_ERR "handle_trap - nullifying syscall "
 			       "failed, errno = %d\n", errno);
 			fatal_sigsegv();
 		}
 
 		err = ptrace(PTRACE_SYSCALL, pid, 0, 0);
 		if (err < 0) {
-			printk(UM_KERN_ERR "handle_trap - continuing to end of "
+			printk(KERN_ERR "handle_trap - continuing to end of "
 			       "syscall failed, errno = %d\n", errno);
 			fatal_sigsegv();
 		}
@@ -181,9 +181,9 @@ static void handle_trap(int pid, struct uml_pt_regs *regs,
 		    (WSTOPSIG(status) != SIGTRAP + 0x80)) {
 			err = ptrace_dump_regs(pid);
 			if (err)
-				printk(UM_KERN_ERR "Failed to get registers "
+				printk(KERN_ERR "Failed to get registers "
 				       "from process, errno = %d\n", -err);
-			printk(UM_KERN_ERR "handle_trap - failed to wait at "
+			printk(KERN_ERR "handle_trap - failed to wait at "
 			       "end of syscall, errno = %d, status = %d\n",
 			       errno, status);
 			fatal_sigsegv();
@@ -206,7 +206,7 @@ static int userspace_tramp(void *stack)
 	signal(SIGWINCH, SIG_IGN);
 	err = set_interval();
 	if (err) {
-		printk(UM_KERN_ERR "userspace_tramp - setting timer failed, "
+		printk(KERN_ERR "userspace_tramp - setting timer failed, "
 		       "errno = %d\n", err);
 		exit(1);
 	}
@@ -222,7 +222,7 @@ static int userspace_tramp(void *stack)
 		addr = mmap64((void *) STUB_CODE, UM_KERN_PAGE_SIZE,
 			      PROT_EXEC, MAP_FIXED | MAP_PRIVATE, fd, offset);
 		if (addr == MAP_FAILED) {
-			printk(UM_KERN_ERR "mapping mmap stub at 0x%lx failed, "
+			printk(KERN_ERR "mapping mmap stub at 0x%lx failed, "
 			       "errno = %d\n", STUB_CODE, errno);
 			exit(1);
 		}
@@ -233,7 +233,7 @@ static int userspace_tramp(void *stack)
 				    UM_KERN_PAGE_SIZE, PROT_READ | PROT_WRITE,
 				    MAP_FIXED | MAP_SHARED, fd, offset);
 			if (addr == MAP_FAILED) {
-				printk(UM_KERN_ERR "mapping segfault stack "
+				printk(KERN_ERR "mapping segfault stack "
 				       "at 0x%lx failed, errno = %d\n",
 				       STUB_DATA, errno);
 				exit(1);
@@ -253,7 +253,7 @@ static int userspace_tramp(void *stack)
 		sa.sa_sigaction = (void *) v;
 		sa.sa_restorer = NULL;
 		if (sigaction(SIGSEGV, &sa, NULL) < 0) {
-			printk(UM_KERN_ERR "userspace_tramp - setting SIGSEGV "
+			printk(KERN_ERR "userspace_tramp - setting SIGSEGV "
 			       "handler failed - errno = %d\n", errno);
 			exit(1);
 		}
@@ -279,7 +279,7 @@ int start_userspace(unsigned long stub_stack)
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if (stack == MAP_FAILED) {
 		err = -errno;
-		printk(UM_KERN_ERR "start_userspace : mmap failed, "
+		printk(KERN_ERR "start_userspace : mmap failed, "
 		       "errno = %d\n", errno);
 		return err;
 	}
@@ -295,7 +295,7 @@ int start_userspace(unsigned long stub_stack)
 	pid = clone(userspace_tramp, (void *) sp, flags, (void *) stub_stack);
 	if (pid < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "start_userspace : clone failed, "
+		printk(KERN_ERR "start_userspace : clone failed, "
 		       "errno = %d\n", errno);
 		return err;
 	}
@@ -304,7 +304,7 @@ int start_userspace(unsigned long stub_stack)
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED | __WALL));
 		if (n < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "start_userspace : wait failed, "
+			printk(KERN_ERR "start_userspace : wait failed, "
 			       "errno = %d\n", errno);
 			goto out_kill;
 		}
@@ -312,7 +312,7 @@ int start_userspace(unsigned long stub_stack)
 
 	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP)) {
 		err = -EINVAL;
-		printk(UM_KERN_ERR "start_userspace : expected SIGSTOP, got "
+		printk(KERN_ERR "start_userspace : expected SIGSTOP, got "
 		       "status = %d\n", status);
 		goto out_kill;
 	}
@@ -320,14 +320,14 @@ int start_userspace(unsigned long stub_stack)
 	if (ptrace(PTRACE_OLDSETOPTIONS, pid, NULL,
 		   (void *) PTRACE_O_TRACESYSGOOD) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "start_userspace : PTRACE_OLDSETOPTIONS "
+		printk(KERN_ERR "start_userspace : PTRACE_OLDSETOPTIONS "
 		       "failed, errno = %d\n", errno);
 		goto out_kill;
 	}
 
 	if (munmap(stack, UM_KERN_PAGE_SIZE) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "start_userspace : munmap failed, "
+		printk(KERN_ERR "start_userspace : munmap failed, "
 		       "errno = %d\n", errno);
 		goto out_kill;
 	}
@@ -352,7 +352,7 @@ void userspace(struct uml_pt_regs *regs)
 	interrupt_end();
 
 	if (getitimer(ITIMER_VIRTUAL, &timer))
-		printk(UM_KERN_ERR "Failed to get itimer, errno = %d\n", errno);
+		printk(KERN_ERR "Failed to get itimer, errno = %d\n", errno);
 	nsecs = timer.it_value.tv_sec * UM_NSEC_PER_SEC +
 		timer.it_value.tv_usec * UM_NSEC_PER_USEC;
 	nsecs += os_nsecs();
@@ -379,27 +379,27 @@ void userspace(struct uml_pt_regs *regs)
 					     singlestepping(NULL));
 
 		if (ptrace(op, pid, 0, 0)) {
-			printk(UM_KERN_ERR "userspace - ptrace continue "
+			printk(KERN_ERR "userspace - ptrace continue "
 			       "failed, op = %d, errno = %d\n", op, errno);
 			fatal_sigsegv();
 		}
 
 		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED | __WALL));
 		if (err < 0) {
-			printk(UM_KERN_ERR "userspace - wait failed, "
+			printk(KERN_ERR "userspace - wait failed, "
 			       "errno = %d\n", errno);
 			fatal_sigsegv();
 		}
 
 		regs->is_user = 1;
 		if (ptrace(PTRACE_GETREGS, pid, 0, regs->gp)) {
-			printk(UM_KERN_ERR "userspace - PTRACE_GETREGS failed, "
+			printk(KERN_ERR "userspace - PTRACE_GETREGS failed, "
 			       "errno = %d\n", errno);
 			fatal_sigsegv();
 		}
 
 		if (get_fp_registers(pid, regs->fp)) {
-			printk(UM_KERN_ERR "userspace -  get_fp_registers failed, "
+			printk(KERN_ERR "userspace -  get_fp_registers failed, "
 			       "errno = %d\n", errno);
 			fatal_sigsegv();
 		}
@@ -451,7 +451,7 @@ void userspace(struct uml_pt_regs *regs)
 				unblock_signals();
 				break;
 			default:
-				printk(UM_KERN_ERR "userspace - child stopped "
+				printk(KERN_ERR "userspace - child stopped "
 				       "with signal %d\n", sig);
 				fatal_sigsegv();
 			}
@@ -508,14 +508,14 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 	err = ptrace_setregs(pid, thread_regs);
 	if (err < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "copy_context_skas0 : PTRACE_SETREGS "
+		printk(KERN_ERR "copy_context_skas0 : PTRACE_SETREGS "
 		       "failed, pid = %d, errno = %d\n", pid, -err);
 		return err;
 	}
 
 	err = put_fp_registers(pid, thread_fp_regs);
 	if (err < 0) {
-		printk(UM_KERN_ERR "copy_context_skas0 : put_fp_registers "
+		printk(KERN_ERR "copy_context_skas0 : put_fp_registers "
 		       "failed, pid = %d, err = %d\n", pid, err);
 		return err;
 	}
@@ -530,7 +530,7 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 	err = ptrace(PTRACE_CONT, pid, 0, 0);
 	if (err) {
 		err = -errno;
-		printk(UM_KERN_ERR "Failed to continue new process, pid = %d, "
+		printk(KERN_ERR "Failed to continue new process, pid = %d, "
 		       "errno = %d\n", pid, errno);
 		return err;
 	}
@@ -539,7 +539,7 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 
 	pid = data->err;
 	if (pid < 0) {
-		printk(UM_KERN_ERR "copy_context_skas0 - stub-parent reports "
+		printk(KERN_ERR "copy_context_skas0 - stub-parent reports "
 		       "error %d\n", -pid);
 		return pid;
 	}
@@ -550,7 +550,7 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 	 */
 	wait_stub_done(pid);
 	if (child_data->err != STUB_DATA) {
-		printk(UM_KERN_ERR "copy_context_skas0 - stub-child reports "
+		printk(KERN_ERR "copy_context_skas0 - stub-child reports "
 		       "error %ld\n", child_data->err);
 		err = child_data->err;
 		goto out_kill;
@@ -559,7 +559,7 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 	if (ptrace(PTRACE_OLDSETOPTIONS, pid, NULL,
 		   (void *)PTRACE_O_TRACESYSGOOD) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "copy_context_skas0 : PTRACE_OLDSETOPTIONS "
+		printk(KERN_ERR "copy_context_skas0 : PTRACE_OLDSETOPTIONS "
 		       "failed, errno = %d\n", errno);
 		goto out_kill;
 	}
@@ -598,10 +598,10 @@ int map_stub_pages(int fd, unsigned long code, unsigned long data,
 	CATCH_EINTR(n = write(fd, &mmop, sizeof(mmop)));
 	if (n != sizeof(mmop)) {
 		n = errno;
-		printk(UM_KERN_ERR "mmap args - addr = 0x%lx, fd = %d, "
+		printk(KERN_ERR "mmap args - addr = 0x%lx, fd = %d, "
 		       "offset = %llx\n", code, code_fd,
 		       (unsigned long long) code_offset);
-		printk(UM_KERN_ERR "map_stub_pages : /proc/mm map for code "
+		printk(KERN_ERR "map_stub_pages : /proc/mm map for code "
 		       "failed, err = %d\n", n);
 		return -n;
 	}
@@ -623,7 +623,7 @@ int map_stub_pages(int fd, unsigned long code, unsigned long data,
 		CATCH_EINTR(n = write(fd, &mmop, sizeof(mmop)));
 		if (n != sizeof(mmop)) {
 			n = errno;
-			printk(UM_KERN_ERR "map_stub_pages : /proc/mm map for "
+			printk(KERN_ERR "map_stub_pages : /proc/mm map for "
 			       "data failed, err = %d\n", n);
 			return -n;
 		}
@@ -689,7 +689,7 @@ int start_idle_thread(void *stack, jmp_buf *switch_buf)
 		kmalloc_ok = 0;
 		return 1;
 	default:
-		printk(UM_KERN_ERR "Bad sigsetjmp return in "
+		printk(KERN_ERR "Bad sigsetjmp return in "
 		       "start_idle_thread - %d\n", n);
 		fatal_sigsegv();
 	}
@@ -735,7 +735,7 @@ void __switch_mm(struct mm_id *mm_idp)
 		err = ptrace(PTRACE_SWITCH_MM, userspace_pid[0], 0,
 			     mm_idp->u.mm_fd);
 		if (err) {
-			printk(UM_KERN_ERR "__switch_mm - PTRACE_SWITCH_MM "
+			printk(KERN_ERR "__switch_mm - PTRACE_SWITCH_MM "
 			       "failed, errno = %d\n", errno);
 			fatal_sigsegv();
 		}
diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index 0748fe0..0715bfd 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -61,7 +61,7 @@ long long disable_timer(void)
 	long long remain, max = UM_NSEC_PER_SEC / UM_HZ;
 
 	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
-		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
+		printk(KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
 
 	remain = timeval_to_ns(&time.it_value);
diff --git a/arch/um/os-Linux/tty.c b/arch/um/os-Linux/tty.c
index dd12b99..a616511 100644
--- a/arch/um/os-Linux/tty.c
+++ b/arch/um/os-Linux/tty.c
@@ -32,7 +32,7 @@ int get_pty(void)
 	fd = open("/dev/ptmx", O_RDWR);
 	if (fd < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "get_pty : Couldn't open /dev/ptmx - "
+		printk(KERN_ERR "get_pty : Couldn't open /dev/ptmx - "
 		       "err = %d\n", errno);
 		return err;
 	}
@@ -42,14 +42,14 @@ int get_pty(void)
 
 	if (info.res < 0) {
 		err = -info.err;
-		printk(UM_KERN_ERR "get_pty : Couldn't grant pty - "
+		printk(KERN_ERR "get_pty : Couldn't grant pty - "
 		       "errno = %d\n", -info.err);
 		goto out;
 	}
 
 	if (unlockpt(fd) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "get_pty : Couldn't unlock pty - "
+		printk(KERN_ERR "get_pty : Couldn't unlock pty - "
 		       "errno = %d\n", errno);
 		goto out;
 	}
diff --git a/arch/um/os-Linux/umid.c b/arch/um/os-Linux/umid.c
index 4832eb5..ffa22b2 100644
--- a/arch/um/os-Linux/umid.c
+++ b/arch/um/os-Linux/umid.c
@@ -35,7 +35,7 @@ static int __init make_uml_dir(void)
 
 		err = -ENOENT;
 		if (home == NULL) {
-			printk(UM_KERN_ERR "make_uml_dir : no value in "
+			printk(KERN_ERR "make_uml_dir : no value in "
 			       "environment for $HOME\n");
 			goto err;
 		}
@@ -138,7 +138,7 @@ static inline int is_umdir_used(char *dir)
 
 	n = snprintf(file, sizeof(file), "%s/pid", dir);
 	if (n >= sizeof(file)) {
-		printk(UM_KERN_ERR "is_umdir_used - pid filename too long\n");
+		printk(KERN_ERR "is_umdir_used - pid filename too long\n");
 		err = -E2BIG;
 		goto out;
 	}
@@ -148,7 +148,7 @@ static inline int is_umdir_used(char *dir)
 	if (fd < 0) {
 		fd = -errno;
 		if (fd != -ENOENT) {
-			printk(UM_KERN_ERR "is_umdir_used : couldn't open pid "
+			printk(KERN_ERR "is_umdir_used : couldn't open pid "
 			       "file '%s', err = %d\n", file, -fd);
 		}
 		goto out;
@@ -157,24 +157,24 @@ static inline int is_umdir_used(char *dir)
 	err = 0;
 	n = read(fd, pid, sizeof(pid));
 	if (n < 0) {
-		printk(UM_KERN_ERR "is_umdir_used : couldn't read pid file "
+		printk(KERN_ERR "is_umdir_used : couldn't read pid file "
 		       "'%s', err = %d\n", file, errno);
 		goto out_close;
 	} else if (n == 0) {
-		printk(UM_KERN_ERR "is_umdir_used : couldn't read pid file "
+		printk(KERN_ERR "is_umdir_used : couldn't read pid file "
 		       "'%s', 0-byte read\n", file);
 		goto out_close;
 	}
 
 	p = strtoul(pid, &end, 0);
 	if (end == pid) {
-		printk(UM_KERN_ERR "is_umdir_used : couldn't parse pid file "
+		printk(KERN_ERR "is_umdir_used : couldn't parse pid file "
 		       "'%s', errno = %d\n", file, errno);
 		goto out_close;
 	}
 
 	if ((kill(p, 0) == 0) || (errno != ESRCH)) {
-		printk(UM_KERN_ERR "umid \"%s\" is already in use by pid %d\n",
+		printk(KERN_ERR "umid \"%s\" is already in use by pid %d\n",
 		       umid, p);
 		return 1;
 	}
@@ -199,7 +199,7 @@ static int umdir_take_if_dead(char *dir)
 
 	ret = remove_files_and_dir(dir);
 	if (ret) {
-		printk(UM_KERN_ERR "is_umdir_used - remove_files_and_dir "
+		printk(KERN_ERR "is_umdir_used - remove_files_and_dir "
 		       "failed with err = %d\n", ret);
 	}
 	return ret;
@@ -216,7 +216,7 @@ static void __init create_pid_file(void)
 
 	fd = open(file, O_RDWR | O_CREAT | O_EXCL, 0644);
 	if (fd < 0) {
-		printk(UM_KERN_ERR "Open of machine pid file \"%s\" failed: "
+		printk(KERN_ERR "Open of machine pid file \"%s\" failed: "
 		       "%s\n", file, strerror(errno));
 		return;
 	}
@@ -224,7 +224,7 @@ static void __init create_pid_file(void)
 	snprintf(pid, sizeof(pid), "%d\n", getpid());
 	n = write(fd, pid, strlen(pid));
 	if (n != strlen(pid))
-		printk(UM_KERN_ERR "Write of pid file failed - err = %d\n",
+		printk(KERN_ERR "Write of pid file failed - err = %d\n",
 		       errno);
 
 	close(fd);
@@ -258,7 +258,7 @@ static int __init make_umid(void)
 		strlcat(tmp, "XXXXXX", sizeof(tmp));
 		fd = mkstemp(tmp);
 		if (fd < 0) {
-			printk(UM_KERN_ERR "make_umid - mkstemp(%s) failed: "
+			printk(KERN_ERR "make_umid - mkstemp(%s) failed: "
 			       "%s\n", tmp, strerror(errno));
 			err = -errno;
 			goto err;
@@ -293,7 +293,7 @@ static int __init make_umid(void)
 	}
 	if (err) {
 		err = -errno;
-		printk(UM_KERN_ERR "Failed to create '%s' - err = %d\n", umid,
+		printk(KERN_ERR "Failed to create '%s' - err = %d\n", umid,
 		       errno);
 		goto err;
 	}
@@ -316,7 +316,7 @@ static int __init make_umid_init(void)
 	 * If initializing with the given umid failed, then try again with
 	 * a random one.
 	 */
-	printk(UM_KERN_ERR "Failed to initialize umid \"%s\", trying with a "
+	printk(KERN_ERR "Failed to initialize umid \"%s\", trying with a "
 	       "random umid\n", umid);
 	*umid = '\0';
 	make_umid();
@@ -336,7 +336,7 @@ int __init umid_file_name(char *name, char *buf, int len)
 
 	n = snprintf(buf, len, "%s%s/%s", uml_dir, umid, name);
 	if (n >= len) {
-		printk(UM_KERN_ERR "umid_file_name : buffer too short\n");
+		printk(KERN_ERR "umid_file_name : buffer too short\n");
 		return -E2BIG;
 	}
 
-- 
1.7.0.4

