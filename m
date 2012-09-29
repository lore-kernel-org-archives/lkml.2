Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab2I2RHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 13:07:48 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:54454 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2I2RHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 13:07:46 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        x86@kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/4] arch/um/drivers: Drop UM_ prefix from printk() level specifiers
Date: Sat, 29 Sep 2012 19:07:37 +0200
Message-Id: <1348938460-20919-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 9429ec96c2718c0d1e3317cf60a87a0405223814 ("um: Preinclude
include/linux/kern_levels.h") the non-prefixed printk() level specifiers
are usable for the user parts of UML.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/um/drivers/chan_user.c     |   28 ++++++++++++++--------------
 arch/um/drivers/daemon_user.c   |   16 ++++++++--------
 arch/um/drivers/fd.c            |    6 +++---
 arch/um/drivers/mconsole_user.c |    4 ++--
 arch/um/drivers/net_user.c      |   12 ++++++------
 arch/um/drivers/pcap_user.c     |   12 ++++++------
 arch/um/drivers/port_user.c     |    4 ++--
 arch/um/drivers/pty.c           |    4 ++--
 arch/um/drivers/slip_user.c     |   20 ++++++++++----------
 arch/um/drivers/slirp_user.c    |    6 +++---
 arch/um/drivers/tty.c           |    2 +-
 arch/um/drivers/umcast_user.c   |   20 ++++++++++----------
 arch/um/drivers/vde_user.c      |   12 ++++++------
 arch/um/drivers/xterm.c         |   16 ++++++++--------
 14 files changed, 81 insertions(+), 81 deletions(-)

diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index f180813..8bc6ad5 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -153,7 +153,7 @@ static int winch_thread(void *arg)
 	pipe_fd = data->pipe_fd;
 	count = write(pipe_fd, &c, sizeof(c));
 	if (count != sizeof(c))
-		printk(UM_KERN_ERR "winch_thread : failed to write "
+		printk(KERN_ERR "winch_thread : failed to write "
 		       "synchronization byte, err = %d\n", -count);
 
 	/*
@@ -166,7 +166,7 @@ static int winch_thread(void *arg)
 	sigfillset(&sigs);
 	/* Block all signals possible. */
 	if (sigprocmask(SIG_SETMASK, &sigs, NULL) < 0) {
-		printk(UM_KERN_ERR "winch_thread : sigprocmask failed, "
+		printk(KERN_ERR "winch_thread : sigprocmask failed, "
 		       "errno = %d\n", errno);
 		exit(1);
 	}
@@ -174,19 +174,19 @@ static int winch_thread(void *arg)
 	sigdelset(&sigs, SIGWINCH);
 
 	if (setsid() < 0) {
-		printk(UM_KERN_ERR "winch_thread : setsid failed, errno = %d\n",
+		printk(KERN_ERR "winch_thread : setsid failed, errno = %d\n",
 		       errno);
 		exit(1);
 	}
 
 	if (ioctl(pty_fd, TIOCSCTTY, 0) < 0) {
-		printk(UM_KERN_ERR "winch_thread : TIOCSCTTY failed on "
+		printk(KERN_ERR "winch_thread : TIOCSCTTY failed on "
 		       "fd %d err = %d\n", pty_fd, errno);
 		exit(1);
 	}
 
 	if (tcsetpgrp(pty_fd, os_getpid()) < 0) {
-		printk(UM_KERN_ERR "winch_thread : tcsetpgrp failed on "
+		printk(KERN_ERR "winch_thread : tcsetpgrp failed on "
 		       "fd %d err = %d\n", pty_fd, errno);
 		exit(1);
 	}
@@ -199,7 +199,7 @@ static int winch_thread(void *arg)
 	 */
 	count = read(pipe_fd, &c, sizeof(c));
 	if (count != sizeof(c))
-		printk(UM_KERN_ERR "winch_thread : failed to read "
+		printk(KERN_ERR "winch_thread : failed to read "
 		       "synchronization byte, err = %d\n", errno);
 
 	while(1) {
@@ -211,7 +211,7 @@ static int winch_thread(void *arg)
 
 		count = write(pipe_fd, &c, sizeof(c));
 		if (count != sizeof(c))
-			printk(UM_KERN_ERR "winch_thread : write failed, "
+			printk(KERN_ERR "winch_thread : write failed, "
 			       "err = %d\n", errno);
 	}
 }
@@ -225,7 +225,7 @@ static int winch_tramp(int fd, struct tty_struct *tty, int *fd_out,
 
 	err = os_pipe(fds, 1, 1);
 	if (err < 0) {
-		printk(UM_KERN_ERR "winch_tramp : os_pipe failed, err = %d\n",
+		printk(KERN_ERR "winch_tramp : os_pipe failed, err = %d\n",
 		       -err);
 		goto out;
 	}
@@ -240,7 +240,7 @@ static int winch_tramp(int fd, struct tty_struct *tty, int *fd_out,
 	 */
 	err = run_helper_thread(winch_thread, &data, CLONE_FILES, stack_out);
 	if (err < 0) {
-		printk(UM_KERN_ERR "fork of winch_thread failed - errno = %d\n",
+		printk(KERN_ERR "fork of winch_thread failed - errno = %d\n",
 		       -err);
 		goto out_close;
 	}
@@ -248,16 +248,16 @@ static int winch_tramp(int fd, struct tty_struct *tty, int *fd_out,
 	*fd_out = fds[0];
 	n = read(fds[0], &c, sizeof(c));
 	if (n != sizeof(c)) {
-		printk(UM_KERN_ERR "winch_tramp : failed to read "
+		printk(KERN_ERR "winch_tramp : failed to read "
 		       "synchronization byte\n");
-		printk(UM_KERN_ERR "read failed, err = %d\n", errno);
-		printk(UM_KERN_ERR "fd %d will not support SIGWINCH\n", fd);
+		printk(KERN_ERR "read failed, err = %d\n", errno);
+		printk(KERN_ERR "fd %d will not support SIGWINCH\n", fd);
 		err = -EINVAL;
 		goto out_close;
 	}
 
 	if (os_set_fd_block(*fd_out, 0)) {
-		printk(UM_KERN_ERR "winch_tramp: failed to set thread_fd "
+		printk(KERN_ERR "winch_tramp: failed to set thread_fd "
 		       "non-blocking.\n");
 		goto out_close;
 	}
@@ -295,7 +295,7 @@ void register_winch(int fd, struct tty_struct *tty)
 
 		count = write(thread_fd, &c, sizeof(c));
 		if (count != sizeof(c))
-			printk(UM_KERN_ERR "register_winch : failed to write "
+			printk(KERN_ERR "register_winch : failed to write "
 			       "synchronization byte, err = %d\n", errno);
 	}
 }
diff --git a/arch/um/drivers/daemon_user.c b/arch/um/drivers/daemon_user.c
index a4fd7bc..ad041ca 100644
--- a/arch/um/drivers/daemon_user.c
+++ b/arch/um/drivers/daemon_user.c
@@ -35,7 +35,7 @@ static struct sockaddr_un *new_addr(void *name, int len)
 
 	sun = uml_kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if (sun == NULL) {
-		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_un "
+		printk(KERN_ERR "new_addr: allocation of sockaddr_un "
 		       "failed\n");
 		return NULL;
 	}
@@ -55,7 +55,7 @@ static int connect_to_switch(struct daemon_data *pri)
 	pri->control = socket(AF_UNIX, SOCK_STREAM, 0);
 	if (pri->control < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "daemon_open : control socket failed, "
+		printk(KERN_ERR "daemon_open : control socket failed, "
 		       "errno = %d\n", -err);
 		return err;
 	}
@@ -63,7 +63,7 @@ static int connect_to_switch(struct daemon_data *pri)
 	if (connect(pri->control, (struct sockaddr *) ctl_addr,
 		   sizeof(*ctl_addr)) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "daemon_open : control connect failed, "
+		printk(KERN_ERR "daemon_open : control connect failed, "
 		       "errno = %d\n", -err);
 		goto out;
 	}
@@ -71,20 +71,20 @@ static int connect_to_switch(struct daemon_data *pri)
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
 	if (fd < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "daemon_open : data socket failed, "
+		printk(KERN_ERR "daemon_open : data socket failed, "
 		       "errno = %d\n", -err);
 		goto out;
 	}
 	if (bind(fd, (struct sockaddr *) local_addr, sizeof(*local_addr)) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "daemon_open : data bind failed, "
+		printk(KERN_ERR "daemon_open : data bind failed, "
 		       "errno = %d\n", -err);
 		goto out_close;
 	}
 
 	sun = uml_kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if (sun == NULL) {
-		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_un "
+		printk(KERN_ERR "new_addr: allocation of sockaddr_un "
 		       "failed\n");
 		err = -ENOMEM;
 		goto out_close;
@@ -96,7 +96,7 @@ static int connect_to_switch(struct daemon_data *pri)
 	req.sock = *local_addr;
 	n = write(pri->control, &req, sizeof(req));
 	if (n != sizeof(req)) {
-		printk(UM_KERN_ERR "daemon_open : control setup request "
+		printk(KERN_ERR "daemon_open : control setup request "
 		       "failed, err = %d\n", -errno);
 		err = -ENOTCONN;
 		goto out_free;
@@ -104,7 +104,7 @@ static int connect_to_switch(struct daemon_data *pri)
 
 	n = read(pri->control, sun, sizeof(*sun));
 	if (n != sizeof(*sun)) {
-		printk(UM_KERN_ERR "daemon_open : read of data socket failed, "
+		printk(KERN_ERR "daemon_open : read of data socket failed, "
 		       "err = %d\n", -errno);
 		err = -ENOTCONN;
 		goto out_free;
diff --git a/arch/um/drivers/fd.c b/arch/um/drivers/fd.c
index 5b81d25..ce530dc 100644
--- a/arch/um/drivers/fd.c
+++ b/arch/um/drivers/fd.c
@@ -26,14 +26,14 @@ static void *fd_init(char *str, int device, const struct chan_opts *opts)
 	int n;
 
 	if (*str != ':') {
-		printk(UM_KERN_ERR "fd_init : channel type 'fd' must specify a "
+		printk(KERN_ERR "fd_init : channel type 'fd' must specify a "
 		       "file descriptor\n");
 		return NULL;
 	}
 	str++;
 	n = strtoul(str, &end, 0);
 	if ((*end != '\0') || (end == str)) {
-		printk(UM_KERN_ERR "fd_init : couldn't parse file descriptor "
+		printk(KERN_ERR "fd_init : couldn't parse file descriptor "
 		       "'%s'\n", str);
 		return NULL;
 	}
@@ -76,7 +76,7 @@ static void fd_close(int fd, void *d)
 
 	CATCH_EINTR(err = tcsetattr(fd, TCSAFLUSH, &data->tt));
 	if (err)
-		printk(UM_KERN_ERR "Failed to restore terminal state - "
+		printk(KERN_ERR "Failed to restore terminal state - "
 		       "errno = %d\n", -err);
 	data->raw = 0;
 }
diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index 9920982..f77908f 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -187,7 +187,7 @@ int mconsole_notify(char *sock_name, int type, const void *data, int len)
 		notify_sock = socket(PF_UNIX, SOCK_DGRAM, 0);
 		if (notify_sock < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "mconsole_notify - socket failed, "
+			printk(KERN_ERR "mconsole_notify - socket failed, "
 			       "errno = %d\n", errno);
 		}
 	}
@@ -212,7 +212,7 @@ int mconsole_notify(char *sock_name, int type, const void *data, int len)
 		   sizeof(target));
 	if (n < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "mconsole_notify - sendto failed, "
+		printk(KERN_ERR "mconsole_notify - sendto failed, "
 		       "errno = %d\n", errno);
 	}
 	return err;
diff --git a/arch/um/drivers/net_user.c b/arch/um/drivers/net_user.c
index 05090c3..a7153ea 100644
--- a/arch/um/drivers/net_user.c
+++ b/arch/um/drivers/net_user.c
@@ -23,7 +23,7 @@ int tap_open_common(void *dev, char *gate_addr)
 		return 0;
 	if (sscanf(gate_addr, "%d.%d.%d.%d", &tap_addr[0],
 		  &tap_addr[1], &tap_addr[2], &tap_addr[3]) != 4) {
-		printk(UM_KERN_ERR "Invalid tap IP address - '%s'\n",
+		printk(KERN_ERR "Invalid tap IP address - '%s'\n",
 		       gate_addr);
 		return -EINVAL;
 	}
@@ -41,7 +41,7 @@ void tap_check_ips(char *gate_addr, unsigned char *eth_addr)
 	    (eth_addr[1] == tap_addr[1]) &&
 	    (eth_addr[2] == tap_addr[2]) &&
 	    (eth_addr[3] == tap_addr[3])) {
-		printk(UM_KERN_ERR "The tap IP address and the UML eth IP "
+		printk(KERN_ERR "The tap IP address and the UML eth IP "
 		       "address must be different\n");
 	}
 }
@@ -85,10 +85,10 @@ void read_output(int fd, char *output, int len)
 
 err:
 	if (ret < 0)
-		printk(UM_KERN_ERR "read_output - read of %s failed, "
+		printk(KERN_ERR "read_output - read of %s failed, "
 		       "errno = %d\n", str, -ret);
 	else
-		printk(UM_KERN_ERR "read_output - read of %s failed, read only "
+		printk(KERN_ERR "read_output - read of %s failed, read only "
 		       "%d of %d bytes\n", str, ret, expected);
 }
 
@@ -184,7 +184,7 @@ static int change_tramp(char **argv, char *output, int output_len)
 
 	err = os_pipe(fds, 1, 0);
 	if (err < 0) {
-		printk(UM_KERN_ERR "change_tramp - pipe failed, err = %d\n",
+		printk(KERN_ERR "change_tramp - pipe failed, err = %d\n",
 		       -err);
 		return err;
 	}
@@ -222,7 +222,7 @@ static void change(char *dev, char *what, unsigned char *addr,
 	output_len = UM_KERN_PAGE_SIZE;
 	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	if (output == NULL)
-		printk(UM_KERN_ERR "change : failed to allocate output "
+		printk(KERN_ERR "change : failed to allocate output "
 		       "buffer\n");
 
 	pid = change_tramp(argv, output, output_len);
diff --git a/arch/um/drivers/pcap_user.c b/arch/um/drivers/pcap_user.c
index 702a75b..841df8d 100644
--- a/arch/um/drivers/pcap_user.c
+++ b/arch/um/drivers/pcap_user.c
@@ -22,7 +22,7 @@ static int pcap_user_init(void *data, void *dev)
 	p = pcap_open_live(pri->host_if, ETH_MAX_PACKET + ETH_HEADER_OTHER,
 			   pri->promisc, 0, errors);
 	if (p == NULL) {
-		printk(UM_KERN_ERR "pcap_user_init : pcap_open_live failed - "
+		printk(KERN_ERR "pcap_user_init : pcap_open_live failed - "
 		       "'%s'\n", errors);
 		return -EINVAL;
 	}
@@ -44,14 +44,14 @@ static int pcap_open(void *data)
 	if (pri->filter != NULL) {
 		err = dev_netmask(pri->dev, &netmask);
 		if (err < 0) {
-			printk(UM_KERN_ERR "pcap_open : dev_netmask failed\n");
+			printk(KERN_ERR "pcap_open : dev_netmask failed\n");
 			return -EIO;
 		}
 
 		pri->compiled = uml_kmalloc(sizeof(struct bpf_program),
 					UM_GFP_KERNEL);
 		if (pri->compiled == NULL) {
-			printk(UM_KERN_ERR "pcap_open : kmalloc failed\n");
+			printk(KERN_ERR "pcap_open : kmalloc failed\n");
 			return -ENOMEM;
 		}
 
@@ -59,14 +59,14 @@ static int pcap_open(void *data)
 				   (struct bpf_program *) pri->compiled,
 				   pri->filter, pri->optimize, netmask);
 		if (err < 0) {
-			printk(UM_KERN_ERR "pcap_open : pcap_compile failed - "
+			printk(KERN_ERR "pcap_open : pcap_compile failed - "
 			       "'%s'\n", pcap_geterr(pri->pcap));
 			goto out;
 		}
 
 		err = pcap_setfilter(pri->pcap, pri->compiled);
 		if (err < 0) {
-			printk(UM_KERN_ERR "pcap_open : pcap_setfilter "
+			printk(KERN_ERR "pcap_open : pcap_setfilter "
 			       "failed - '%s'\n", pcap_geterr(pri->pcap));
 			goto out;
 		}
@@ -116,7 +116,7 @@ int pcap_user_read(int fd, void *buffer, int len, struct pcap_data *pri)
 
 	n = pcap_dispatch(pri->pcap, 1, handler, (u_char *) &hdata);
 	if (n < 0) {
-		printk(UM_KERN_ERR "pcap_dispatch failed - %s\n",
+		printk(KERN_ERR "pcap_dispatch failed - %s\n",
 		       pcap_geterr(pri->pcap));
 		return -EIO;
 	}
diff --git a/arch/um/drivers/port_user.c b/arch/um/drivers/port_user.c
index 7b010b7..bca8c17 100644
--- a/arch/um/drivers/port_user.c
+++ b/arch/um/drivers/port_user.c
@@ -29,14 +29,14 @@ static void *port_init(char *str, int device, const struct chan_opts *opts)
 	int port;
 
 	if (*str != ':') {
-		printk(UM_KERN_ERR "port_init : channel type 'port' must "
+		printk(KERN_ERR "port_init : channel type 'port' must "
 		       "specify a port number\n");
 		return NULL;
 	}
 	str++;
 	port = strtoul(str, &end, 0);
 	if ((*end != '\0') || (end == str)) {
-		printk(UM_KERN_ERR "port_init : couldn't parse port '%s'\n",
+		printk(KERN_ERR "port_init : couldn't parse port '%s'\n",
 		       str);
 		return NULL;
 	}
diff --git a/arch/um/drivers/pty.c b/arch/um/drivers/pty.c
index cff2b75..2adc730 100644
--- a/arch/um/drivers/pty.c
+++ b/arch/um/drivers/pty.c
@@ -47,7 +47,7 @@ static int pts_open(int input, int output, int primary, void *d,
 	fd = get_pty();
 	if (fd < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "open_pts : Failed to open pts\n");
+		printk(KERN_ERR "open_pts : Failed to open pts\n");
 		return err;
 	}
 
@@ -106,7 +106,7 @@ static int getmaster(char *line)
 		}
 	}
 
-	printk(UM_KERN_ERR "getmaster - no usable host pty devices\n");
+	printk(KERN_ERR "getmaster - no usable host pty devices\n");
 	return -ENOENT;
 }
 
diff --git a/arch/um/drivers/slip_user.c b/arch/um/drivers/slip_user.c
index 932b4d6..7ea030c 100644
--- a/arch/um/drivers/slip_user.c
+++ b/arch/um/drivers/slip_user.c
@@ -30,7 +30,7 @@ static int set_up_tty(int fd)
 	struct termios tios;
 
 	if (tcgetattr(fd, &tios) < 0) {
-		printk(UM_KERN_ERR "could not get initial terminal "
+		printk(KERN_ERR "could not get initial terminal "
 		       "attributes\n");
 		return -1;
 	}
@@ -48,7 +48,7 @@ static int set_up_tty(int fd)
 	cfsetispeed(&tios, B38400);
 
 	if (tcsetattr(fd, TCSAFLUSH, &tios) < 0) {
-		printk(UM_KERN_ERR "failed to set terminal attributes\n");
+		printk(KERN_ERR "failed to set terminal attributes\n");
 		return -1;
 	}
 	return 0;
@@ -79,7 +79,7 @@ static int slip_tramp(char **argv, int fd)
 
 	err = os_pipe(fds, 1, 0);
 	if (err < 0) {
-		printk(UM_KERN_ERR "slip_tramp : pipe failed, err = %d\n",
+		printk(KERN_ERR "slip_tramp : pipe failed, err = %d\n",
 		       -err);
 		goto out;
 	}
@@ -96,7 +96,7 @@ static int slip_tramp(char **argv, int fd)
 	output_len = UM_KERN_PAGE_SIZE;
 	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	if (output == NULL) {
-		printk(UM_KERN_ERR "slip_tramp : failed to allocate output "
+		printk(KERN_ERR "slip_tramp : failed to allocate output "
 		       "buffer\n");
 		os_kill_process(pid, 1);
 		err = -ENOMEM;
@@ -131,7 +131,7 @@ static int slip_open(void *data)
 
 	err = get_pty();
 	if (err < 0) {
-		printk(UM_KERN_ERR "slip-open : Failed to open pty, err = %d\n",
+		printk(KERN_ERR "slip-open : Failed to open pty, err = %d\n",
 		       -err);
 		goto out;
 	}
@@ -139,7 +139,7 @@ static int slip_open(void *data)
 
 	err = open(ptsname(mfd), O_RDWR, 0);
 	if (err < 0) {
-		printk(UM_KERN_ERR "Couldn't open tty for slip line, "
+		printk(KERN_ERR "Couldn't open tty for slip line, "
 		       "err = %d\n", -err);
 		goto out_close;
 	}
@@ -158,13 +158,13 @@ static int slip_open(void *data)
 		err = slip_tramp(argv, sfd);
 
 		if (err < 0) {
-			printk(UM_KERN_ERR "slip_tramp failed - err = %d\n",
+			printk(KERN_ERR "slip_tramp failed - err = %d\n",
 			       -err);
 			goto out_close2;
 		}
 		err = os_get_ifname(pri->slave, pri->name);
 		if (err < 0) {
-			printk(UM_KERN_ERR "get_ifname failed, err = %d\n",
+			printk(KERN_ERR "get_ifname failed, err = %d\n",
 			       -err);
 			goto out_close2;
 		}
@@ -173,7 +173,7 @@ static int slip_open(void *data)
 	else {
 		err = os_set_slip(sfd);
 		if (err < 0) {
-			printk(UM_KERN_ERR "Failed to set slip discipline "
+			printk(KERN_ERR "Failed to set slip discipline "
 			       "encapsulation - err = %d\n", -err);
 			goto out_close2;
 		}
@@ -203,7 +203,7 @@ static void slip_close(int fd, void *data)
 	err = slip_tramp(argv, pri->slave);
 
 	if (err != 0)
-		printk(UM_KERN_ERR "slip_tramp failed - errno = %d\n", -err);
+		printk(KERN_ERR "slip_tramp failed - errno = %d\n", -err);
 	close(fd);
 	close(pri->slave);
 	pri->slave = -1;
diff --git a/arch/um/drivers/slirp_user.c b/arch/um/drivers/slirp_user.c
index db4adb6..7dc29f7 100644
--- a/arch/um/drivers/slirp_user.c
+++ b/arch/um/drivers/slirp_user.c
@@ -57,7 +57,7 @@ static int slirp_open(void *data)
 
 	err = slirp_tramp(pri->argw.argv, fds[1]);
 	if (err < 0) {
-		printk(UM_KERN_ERR "slirp_tramp failed - errno = %d\n", -err);
+		printk(KERN_ERR "slirp_tramp failed - errno = %d\n", -err);
 		goto out;
 	}
 	pid = err;
@@ -85,14 +85,14 @@ static void slirp_close(int fd, void *data)
 	pri->slave = -1;
 
 	if (pri->pid<1) {
-		printk(UM_KERN_ERR "slirp_close: no child process to shut "
+		printk(KERN_ERR "slirp_close: no child process to shut "
 		       "down\n");
 		return;
 	}
 
 #if 0
 	if (kill(pri->pid, SIGHUP)<0) {
-		printk(UM_KERN_ERR "slirp_close: sending hangup to %d failed "
+		printk(KERN_ERR "slirp_close: sending hangup to %d failed "
 		       "(%d)\n", pri->pid, errno);
 	}
 #endif
diff --git a/arch/um/drivers/tty.c b/arch/um/drivers/tty.c
index a97391f..f10f0b8 100644
--- a/arch/um/drivers/tty.c
+++ b/arch/um/drivers/tty.c
@@ -21,7 +21,7 @@ static void *tty_chan_init(char *str, int device, const struct chan_opts *opts)
 	struct tty_chan *data;
 
 	if (*str != ':') {
-		printk(UM_KERN_ERR "tty_init : channel type 'tty' must specify "
+		printk(KERN_ERR "tty_init : channel type 'tty' must specify "
 		       "a device\n");
 		return NULL;
 	}
diff --git a/arch/um/drivers/umcast_user.c b/arch/um/drivers/umcast_user.c
index 010fa2d..7c9194f 100644
--- a/arch/um/drivers/umcast_user.c
+++ b/arch/um/drivers/umcast_user.c
@@ -25,7 +25,7 @@ static struct sockaddr_in *new_addr(char *addr, unsigned short port)
 
 	sin = uml_kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
 	if (sin == NULL) {
-		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_in "
+		printk(KERN_ERR "new_addr: allocation of sockaddr_in "
 		       "failed\n");
 		return NULL;
 	}
@@ -79,14 +79,14 @@ static int umcast_open(void *data)
 
 	if (fd < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "umcast_open : data socket failed, "
+		printk(KERN_ERR "umcast_open : data socket failed, "
 		       "errno = %d\n", errno);
 		goto out;
 	}
 
 	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "umcast_open: SO_REUSEADDR failed, "
+		printk(KERN_ERR "umcast_open: SO_REUSEADDR failed, "
 		       "errno = %d\n", errno);
 		goto out_close;
 	}
@@ -96,7 +96,7 @@ static int umcast_open(void *data)
 		if (setsockopt(fd, SOL_IP, IP_MULTICAST_TTL, &pri->ttl,
 			       sizeof(pri->ttl)) < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "umcast_open: IP_MULTICAST_TTL "
+			printk(KERN_ERR "umcast_open: IP_MULTICAST_TTL "
 			       "failed, error = %d\n", errno);
 			goto out_close;
 		}
@@ -105,7 +105,7 @@ static int umcast_open(void *data)
 		if (setsockopt(fd, SOL_IP, IP_MULTICAST_LOOP,
 			       &yes, sizeof(yes)) < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "umcast_open: IP_MULTICAST_LOOP "
+			printk(KERN_ERR "umcast_open: IP_MULTICAST_LOOP "
 			       "failed, error = %d\n", errno);
 			goto out_close;
 		}
@@ -114,7 +114,7 @@ static int umcast_open(void *data)
 	/* bind socket to the address */
 	if (bind(fd, (struct sockaddr *) lsin, sizeof(*lsin)) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "umcast_open : data bind failed, "
+		printk(KERN_ERR "umcast_open : data bind failed, "
 		       "errno = %d\n", errno);
 		goto out_close;
 	}
@@ -126,12 +126,12 @@ static int umcast_open(void *data)
 		if (setsockopt(fd, SOL_IP, IP_ADD_MEMBERSHIP,
 			       &mreq, sizeof(mreq)) < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "umcast_open: IP_ADD_MEMBERSHIP "
+			printk(KERN_ERR "umcast_open: IP_ADD_MEMBERSHIP "
 			       "failed, error = %d\n", errno);
-			printk(UM_KERN_ERR "There appears not to be a "
+			printk(KERN_ERR "There appears not to be a "
 			       "multicast-capable network interface on the "
 			       "host.\n");
-			printk(UM_KERN_ERR "eth0 should be configured in order "
+			printk(KERN_ERR "eth0 should be configured in order "
 			       "to use the multicast transport.\n");
 			goto out_close;
 		}
@@ -157,7 +157,7 @@ static void umcast_close(int fd, void *data)
 		mreq.imr_interface.s_addr = 0;
 		if (setsockopt(fd, SOL_IP, IP_DROP_MEMBERSHIP,
 			       &mreq, sizeof(mreq)) < 0) {
-			printk(UM_KERN_ERR "umcast_close: IP_DROP_MEMBERSHIP "
+			printk(KERN_ERR "umcast_close: IP_DROP_MEMBERSHIP "
 			       "failed, error = %d\n", errno);
 		}
 	}
diff --git a/arch/um/drivers/vde_user.c b/arch/um/drivers/vde_user.c
index b8c2867..1cac03b 100644
--- a/arch/um/drivers/vde_user.c
+++ b/arch/um/drivers/vde_user.c
@@ -22,12 +22,12 @@ static int vde_user_init(void *data, void *dev)
 
 	if (conn == NULL) {
 		err = -errno;
-		printk(UM_KERN_ERR "vde_user_init: vde_open failed, "
+		printk(KERN_ERR "vde_user_init: vde_open failed, "
 		       "errno = %d\n", errno);
 		return err;
 	}
 
-	printk(UM_KERN_INFO "vde backend - connection opened\n");
+	printk(KERN_INFO "vde backend - connection opened\n");
 
 	pri->conn = conn;
 
@@ -41,7 +41,7 @@ static int vde_user_open(void *data)
 	if (pri->conn != NULL)
 		return vde_datafd(pri->conn);
 
-	printk(UM_KERN_WARNING "vde_open - we have no VDECONN to open");
+	printk(KERN_WARNING "vde_open - we have no VDECONN to open");
 	return -EINVAL;
 }
 
@@ -50,7 +50,7 @@ static void vde_remove(void *data)
 	struct vde_data *pri = data;
 
 	if (pri->conn != NULL) {
-		printk(UM_KERN_INFO "vde backend - closing connection\n");
+		printk(KERN_INFO "vde backend - closing connection\n");
 		vde_close(pri->conn);
 		pri->conn = NULL;
 		kfree(pri->args);
@@ -58,7 +58,7 @@ static void vde_remove(void *data)
 		return;
 	}
 
-	printk(UM_KERN_WARNING "vde_remove - we have no VDECONN to remove");
+	printk(KERN_WARNING "vde_remove - we have no VDECONN to remove");
 }
 
 const struct net_user_info vde_user_info = {
@@ -78,7 +78,7 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
 
 	vpri->args = uml_kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
 	if (vpri->args == NULL) {
-		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "
+		printk(KERN_ERR "vde_init_libstuff - vde_open_args "
 		       "allocation failed");
 		return;
 	}
diff --git a/arch/um/drivers/xterm.c b/arch/um/drivers/xterm.c
index 969110e..8406a01 100644
--- a/arch/um/drivers/xterm.c
+++ b/arch/um/drivers/xterm.c
@@ -99,7 +99,7 @@ static int xterm_open(int input, int output, int primary, void *d,
 	 * will work but w/o it we can be pretty sure it won't.
 	 */
 	if (getenv("DISPLAY") == NULL) {
-		printk(UM_KERN_ERR "xterm_open: $DISPLAY not set.\n");
+		printk(KERN_ERR "xterm_open: $DISPLAY not set.\n");
 		return -ENODEV;
 	}
 
@@ -112,14 +112,14 @@ static int xterm_open(int input, int output, int primary, void *d,
 	fd = mkstemp(file);
 	if (fd < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "xterm_open : mkstemp failed, errno = %d\n",
+		printk(KERN_ERR "xterm_open : mkstemp failed, errno = %d\n",
 		       errno);
 		return err;
 	}
 
 	if (unlink(file)) {
 		err = -errno;
-		printk(UM_KERN_ERR "xterm_open : unlink failed, errno = %d\n",
+		printk(KERN_ERR "xterm_open : unlink failed, errno = %d\n",
 		       errno);
 		close(fd);
 		return err;
@@ -128,7 +128,7 @@ static int xterm_open(int input, int output, int primary, void *d,
 
 	fd = os_create_unix_socket(file, sizeof(file), 1);
 	if (fd < 0) {
-		printk(UM_KERN_ERR "xterm_open : create_unix_socket failed, "
+		printk(KERN_ERR "xterm_open : create_unix_socket failed, "
 		       "errno = %d\n", -fd);
 		return fd;
 	}
@@ -137,14 +137,14 @@ static int xterm_open(int input, int output, int primary, void *d,
 	pid = run_helper(NULL, NULL, argv);
 	if (pid < 0) {
 		err = pid;
-		printk(UM_KERN_ERR "xterm_open : run_helper failed, "
+		printk(KERN_ERR "xterm_open : run_helper failed, "
 		       "errno = %d\n", -err);
 		goto out_close1;
 	}
 
 	err = os_set_fd_block(fd, 0);
 	if (err < 0) {
-		printk(UM_KERN_ERR "xterm_open : failed to set descriptor "
+		printk(KERN_ERR "xterm_open : failed to set descriptor "
 		       "non-blocking, err = %d\n", -err);
 		goto out_kill;
 	}
@@ -152,14 +152,14 @@ static int xterm_open(int input, int output, int primary, void *d,
 	new = xterm_fd(fd, &data->helper_pid);
 	if (new < 0) {
 		err = new;
-		printk(UM_KERN_ERR "xterm_open : os_rcv_fd failed, err = %d\n",
+		printk(KERN_ERR "xterm_open : os_rcv_fd failed, err = %d\n",
 		       -err);
 		goto out_kill;
 	}
 
 	err = os_set_fd_block(new, 0);
 	if (err) {
-		printk(UM_KERN_ERR "xterm_open : failed to set xterm "
+		printk(KERN_ERR "xterm_open : failed to set xterm "
 		       "descriptor non-blocking, err = %d\n", -err);
 		goto out_close2;
 	}
-- 
1.7.0.4

