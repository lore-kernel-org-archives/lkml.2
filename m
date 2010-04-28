Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab0D1U1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:27:09 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:61547 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab0D1U1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TjrTmtI5+he4jESwvXhVQYoHBabJq/ibjiazXer7szHGDoOMyUtGvPGq+ArzwVgjUs
         na0aVMOYEAuZXd//Dusu3IQcUPeqGu11stvA2BGVLr/ZrCmBQgQ/p+L2TE3bRhOOspM0
         wRhn7K+jzUy0g+xOEadKsSJt9lFoZWi/hRNlI=
Subject: Re: 2.6.34-rc5-git7 (plus all patches) -- another suspicious
 rcu_dereference_check() usage.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Miles Lane <miles.lane@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
       Eric Paris <eparis@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, nauman@google.com,
       netdev@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Johannes Berg <johannes@sipsolutions.net>, shemminger@vyatta.com
In-Reply-To: <20100428200904.GS2540@linux.vnet.ibm.com>
References: <h2ya44ae5cd1004261751waa5cb65ei3d139cbcfa2cc5cf@mail.gmail.com>
	 <20100428175426.GK2540@linux.vnet.ibm.com>
	 <1272483491.2201.9.camel@edumazet-laptop>
	 <20100428200904.GS2540@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 22:18:43 +0200
Message-ID: <1272485923.2201.22.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 28 avril 2010 à 13:09 -0700, Paul E. McKenney a écrit :
> On Wed, Apr 28, 2010 at 09:38:11PM +0200, Eric Dumazet wrote:
> > Le mercredi 28 avril 2010 à 10:54 -0700, Paul E. McKenney a écrit :
> > > On Mon, Apr 26, 2010 at 08:51:06PM -0400, Miles Lane wrote:
> > > > This one occurred during the wakeup from suspend to RAM.
> > > > 
> > > > [  984.724697] [ INFO: suspicious rcu_dereference_check() usage. ]
> > > > [  984.724700] ---------------------------------------------------
> > > > [  984.724703] include/linux/fdtable.h:88 invoked
> > > > rcu_dereference_check() without protection!
> > > > [  984.724706]
> > > > [  984.724707] other info that might help us debug this:
> > > > [  984.724708]
> > > > [  984.724711]
> > > > [  984.724711] rcu_scheduler_active = 1, debug_locks = 1
> > > > [  984.724714] no locks held by dbus-daemon/4680.
> > > > [  984.724717]
> > > > [  984.724717] stack backtrace:
> > > > [  984.724721] Pid: 4680, comm: dbus-daemon Not tainted 2.6.34-rc5-git7 #33
> > > > [  984.724724] Call Trace:
> > > > [  984.724734]  [<ffffffff81074556>] lockdep_rcu_dereference+0x9d/0xa6
> > > > [  984.724740]  [<ffffffff810fc785>] fcheck_files+0xb1/0xc9
> > > > [  984.724745]  [<ffffffff810fc7f5>] fget_light+0x35/0xab
> > > > [  984.724751]  [<ffffffff81433e1b>] ? sock_poll_wait+0x13/0x18
> > > > [  984.724755]  [<ffffffff81433e39>] ? unix_poll+0x19/0x95
> > > > [  984.724762]  [<ffffffff8110aa95>] do_sys_poll+0x1ff/0x3e5
> > > > [  984.724766]  [<ffffffff8110a19e>] ? __pollwait+0x0/0xc7
> > > > [  984.724771]  [<ffffffff8110a265>] ? pollwake+0x0/0x4f
> > > > [  984.724776]  [<ffffffff8110a265>] ? pollwake+0x0/0x4f
> > > > [  984.724780]  [<ffffffff8110a265>] ? pollwake+0x0/0x4f
> > > > [  984.724784]  [<ffffffff8110a265>] ? pollwake+0x0/0x4f
> > > > [  984.724788]  [<ffffffff8110a265>] ? pollwake+0x0/0x4f
> > > > [  984.724793]  [<ffffffff8110a265>] ? pollwake+0x0/0x4f
> > > > [  984.724797]  [<ffffffff8110a265>] ? pollwake+0x0/0x4f
> > > > [  984.724802]  [<ffffffff8110a265>] ? pollwake+0x0/0x4f
> > > > [  984.724806]  [<ffffffff8110a265>] ? pollwake+0x0/0x4f
> > > > [  984.724812]  [<ffffffff8110ae0f>] sys_poll+0x50/0xbb
> > > > [  984.724818]  [<ffffffff81009d82>] system_call_fastpath+0x16/0x1b
> > > 
> > > Hmmm...  I am not convinced that this is a false positive.  Couldn't
> > > there be a multi-threaded process where one thread is invoking poll()
> > > on a UNIX socket just as another thread is calling close() on it?
> > > 
> > > The current fcheck_files() logic requires that the caller either (1) be in
> > > an RCU read-side critical section, (2) hold ->files_lock, or (3) passing
> > > in a files_struct with ->count equal to 1 (initialization or cleanup).
> > > 
> > > So I don't feel comfortable just slapping an RCU read-side critical
> > > section around this one, at least not unless someone who understands
> > > the locking says that doing so is OK.
> > > 
> > > 		
> > 
> > Its a single threaded program.
> > 
> > So fget_light() calls fcheck_files(files, fd); without rcu lock,
> > but some /proc/pid/fd/... user temporarly raised files->count just
> > before we perform the condition check.
> 
> So I should add a single-threaded check.  My first thought was to use
> current_is_single_threaded(), but the bit about scanning the full list
> of processes does give me pause.  However, thread_group_empty() looks
> like a much lighter-weight alternative.
> 
> I believe that it is possible for a pair of single-threaded processes
> to share a file descriptor, but that should not be a problem, as both
> of them would need to close it for it to go away.
> 
> But what happens if someone does a clone() with CLONE_FILES, as some
> of the AIO stuff seems to do?  Won't that allow one of the resulting
> processes to close the file for both of them, even though both are
> otherwise single-threaded?  And the ->count seems to be the only
> distinction between these two cases.
> 
> And AIO does CLONE_VM as well as CLONE_FILES, but that seems to mean that
> the check must scan the processes with current_is_single_threaded().
> Besides which, a user could invoke clone() with only CLONE_FILES
> specified, right?
> 
> Or am I just confused here?
> 
> 							Thanx, Paul

If a program is mono threaded, and doing a fget_light() syscall, it
cannot possibly do a clone() in // ;)

If we want to be picky, we could add a user provided condition, aka "we
are sure we are allowed to do this because we are the owner of the files
struct".






diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 6da962c..027f5e1 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2694,7 +2694,7 @@ void __do_SAK(struct tty_struct *tty)
 			spin_lock(&p->files->file_lock);
 			fdt = files_fdtable(p->files);
 			for (i = 0; i < fdt->max_fds; i++) {
-				filp = fcheck_files(p->files, i);
+				filp = fcheck_files(p->files, i, false);
 				if (!filp)
 					continue;
 				if (filp->f_op->read == tty_read &&
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 452d02f..dabf4d8 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -119,7 +119,7 @@ SYSCALL_DEFINE2(dup2, unsigned int, oldfd, unsigned int, newfd)
 		int retval = oldfd;
 
 		rcu_read_lock();
-		if (!fcheck_files(files, oldfd))
+		if (!fcheck_files(files, oldfd, false))
 			retval = -EBADF;
 		rcu_read_unlock();
 		return retval;
diff --git a/fs/file_table.c b/fs/file_table.c
index 32d12b7..2865f72 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -274,7 +274,7 @@ struct file *fget(unsigned int fd)
 	struct files_struct *files = current->files;
 
 	rcu_read_lock();
-	file = fcheck_files(files, fd);
+	file = fcheck_files(files, fd, false);
 	if (file) {
 		if (!atomic_long_inc_not_zero(&file->f_count)) {
 			/* File object ref couldn't be taken */
@@ -303,10 +303,10 @@ struct file *fget_light(unsigned int fd, int *fput_needed)
 
 	*fput_needed = 0;
 	if (likely((atomic_read(&files->count) == 1))) {
-		file = fcheck_files(files, fd);
+		file = fcheck_files(files, fd, true);
 	} else {
 		rcu_read_lock();
-		file = fcheck_files(files, fd);
+		file = fcheck_files(files, fd, false);
 		if (file) {
 			if (atomic_long_inc_not_zero(&file->f_count))
 				*fput_needed = 1;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8418fcc..0e89448 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1716,7 +1716,7 @@ static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 		 * hold ->file_lock.
 		 */
 		spin_lock(&files->file_lock);
-		file = fcheck_files(files, fd);
+		file = fcheck_files(files, fd, false);
 		if (file) {
 			if (path) {
 				*path = file->f_path;
@@ -1755,7 +1755,7 @@ static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
 		files = get_files_struct(task);
 		if (files) {
 			rcu_read_lock();
-			if (fcheck_files(files, fd)) {
+			if (fcheck_files(files, fd, false)) {
 				rcu_read_unlock();
 				put_files_struct(files);
 				if (task_dumpable(task)) {
@@ -1813,7 +1813,7 @@ static struct dentry *proc_fd_instantiate(struct inode *dir,
 	 * hold ->file_lock.
 	 */
 	spin_lock(&files->file_lock);
-	file = fcheck_files(files, fd);
+	file = fcheck_files(files, fd, false);
 	if (!file)
 		goto out_unlock;
 	if (file->f_mode & FMODE_READ)
@@ -1899,7 +1899,7 @@ static int proc_readfd_common(struct file * filp, void * dirent,
 				char name[PROC_NUMBUF];
 				int len;
 
-				if (!fcheck_files(files, fd))
+				if (!fcheck_files(files, fd, false))
 					continue;
 				rcu_read_unlock();
 
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 013dc52..76423ad 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -57,11 +57,12 @@ struct files_struct {
 	struct file * fd_array[NR_OPEN_DEFAULT];
 };
 
-#define rcu_dereference_check_fdtable(files, fdtfd) \
+#define rcu_dereference_check_fdtable(files, fdtfd, cond) \
 	(rcu_dereference_check((fdtfd), \
 			       rcu_read_lock_held() || \
 			       lockdep_is_held(&(files)->file_lock) || \
-			       atomic_read(&(files)->count) == 1))
+			       atomic_read(&(files)->count) == 1 || \
+			       cond))
 
 #define files_fdtable(files) \
 		(rcu_dereference_check_fdtable((files), (files)->fdt))
@@ -79,13 +80,13 @@ static inline void free_fdtable(struct fdtable *fdt)
 	call_rcu(&fdt->rcu, free_fdtable_rcu);
 }
 
-static inline struct file * fcheck_files(struct files_struct *files, unsigned int fd)
+static inline struct file * fcheck_files(struct files_struct *files, unsigned int fd, bool cond)
 {
 	struct file * file = NULL;
 	struct fdtable *fdt = files_fdtable(files);
 
 	if (fd < fdt->max_fds)
-		file = rcu_dereference_check_fdtable(files, fdt->fd[fd]);
+		file = rcu_dereference_check_fdtable(files, fdt->fd[fd], cond);
 	return file;
 }
 


