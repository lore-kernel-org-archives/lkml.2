Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740Ab0D3SL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:11:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36700 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758994Ab0D3SLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QgqavStOtuPk9a1zD5+0nShJsFp94AaNUNkQ815eSX1n6fzrXJfX/doXr7DMpwfJBn
         L18xjxFh4ZPvmV4T8BD0OCDMR9iI+o7cfGrLIFxmXqS9750qjt0QMQAv184VLjuQ8iOC
         Nr9ZanNrrtzuE1YKqOajOJkyo7NeCuyFvUKME=
Date: Thu, 29 Apr 2010 09:54:35 -0300
From: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.33.3-rt16: WARNING: at fs/namespace.c:1197
 umount_tree+0x127/0x175()
Message-ID: <20100429125435.GG2679@uudg.org>
References: <20100427202750.GC2679@uudg.org>
 <alpine.LFD.2.00.1004272252270.2951@localhost.localdomain>
 <1272522942.1967.12.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272522942.1967.12.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:35:42PM -0700, john stultz wrote:
| On Tue, 2010-04-27 at 22:53 +0200, Thomas Gleixner wrote:
| > On Tue, 27 Apr 2010, Luis Claudio R. Goncalves wrote:
| > 
| > CC'ed John
| > 
| > > Hello!
| > > 
| > > I see this warning during system boot and it hangs while loading X and even
| > > though I can change from one VT to another (ctrl+alt+F<num>) no keys
| > > pressed seem to have any effect.
| > > 
| > > ------------[ cut here ]------------
| > > WARNING: at fs/namespace.c:1197 umount_tree+0x127/0x175()
| > > Hardware name: KQ260AA-AC4 a6540br
| > > Modules linked in: i915 drm_kms_helper drm video output ipt_MASQUERADE iptable_nat nf_nat bridge stp llc vfat fat sunrpc ipv6 xt_physdev ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state iptable_filter ip_tables x_tables dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm_intel kvm uinput tuner_simple tuner_types wm8775 tda9887 tda8290 tuner snd_hda_codec_realtek cx25840 snd_hda_intel snd_hda_codec snd_hwdep snd_seq usb_storage snd_seq_device ivtv snd_pcm i2c_algo_bit cx2341x v4l2_common videodev snd_timer firewire_ohci snd firewire_core v4l1_compat v4l2_compat_ioctl32 ir_common ir_core i2c_i801 soundcore crc_itu_t tveeprom i2c_core iTCO_wdt snd_page_alloc sr_mod intel_agp iTCO_vendor_support serio_raw pcspkr sg button r8169 mii cdrom ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
| > > Pid: 2267, comm: libvirtd Not tainted 2.6.33.3-rt16 #28
| > > Call Trace:
| > > [<ffffffff81040e3b>] warn_slowpath_common+0x7c/0x94
| > > [<ffffffff81040e67>] warn_slowpath_null+0x14/0x16
| > > [<ffffffff81115a7f>] umount_tree+0x127/0x175
| > > [<ffffffff81116d1d>] put_mnt_ns+0xc2/0xf0
| > > [<ffffffff81061a1d>] free_nsproxy+0x1f/0x86
| > > [<ffffffff81061abc>] switch_task_namespaces+0x38/0x3c
| > > [<ffffffff81061ad0>] exit_task_namespaces+0x10/0x12
| > > [<ffffffff81044ae3>] do_exit+0x595/0x738
| > > [<ffffffff81360626>] ? rt_mutex_unlock+0xe/0x10
| > > [<ffffffff81360db8>] ? lockdep_sys_exit_thunk+0x35/0x67
| > > [<ffffffff81044d10>] do_group_exit+0x8a/0xb9
| > > [<ffffffff81044d56>] sys_exit_group+0x17/0x1b
| > > [<ffffffff81002d32>] system_call_fastpath+0x16/0x1b
| > > ---[ end trace 348d259112b3e793 ]---
| > > 
| > > 
| > > The warning comes from:
| > > 
| > > 	WARN_ON(!(p->mnt_flags & MNT_MOUNTED));
| 
| Hey Luis,
| 	So Thomas' current tip/rt/2.6.33 should have the fix for the WARN_ON
| already included, however there is still the hang your seeing that I've
| been hunting down all of yesterday and today.
| 
| Basically it was an issue with namespaces. Nick switched the
| dentry->d_mounted counter to a flag, and that gives us problems with
| namespaces since the dentry might get attached multiple times. This
| causes the first namespace release to cause d_mountpoint to fail and the
| mounts to be lost. Thus /proc goes away and things don't seem to take
| well to that.
| 
| Anyway, the patch below seems to fix it for me. If you could give it a
| whirl (again, on top of the current tip/rt/2.6.33 tree) and let me know
| how it works for you, I'd appreciate it.

John, I tested Thomas' latest rt/2.6.33, that has your patch below, and it
works like a charm. System boots, mouse moves, X is shiny again.

Thanks for fixing this issue.
Luis
 
| Thanks again!
| -john
| 
| 
| >From e33602d947bcbfcb9e7043c6d496c595043a5c74 Mon Sep 17 00:00:00 2001
| From: John Stultz <johnstul@us.ibm.com>
| Date: Wed, 28 Apr 2010 23:31:49 -0700
| Subject: [PATCH] Fix namespace related hangs
| 
| Nick converted the dentry->d_mounted counter to a flag,
| however with namespaces, dentries can be mounted multiple times
| (and more importantly unmounted multiple times).
| 
| If a namespace was created and then released, the
| unmount_tree would remove the DCACHE_MOUNTED flag
| and that would make d_mountpoint fail, causing the
| mounts to be lost.
| 
| This patch coverts it back to a counter, and adds some extra
| WARN_ONs to make sure things are accounted properly.
| 
| Signed-off-by: John Stultz <johnstul@us.ibm.com>
| ---
|  fs/autofs4/expire.c    |    5 +++--
|  fs/dcache.c            |    1 +
|  fs/libfs.c             |    1 +
|  fs/namespace.c         |    5 +++--
|  include/linux/dcache.h |    3 ++-
|  5 files changed, 10 insertions(+), 5 deletions(-)
| 
| diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
| index dc629ee..60a7c6c 100644
| --- a/fs/autofs4/expire.c
| +++ b/fs/autofs4/expire.c
| @@ -296,7 +296,8 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
|  		if (d_mountpoint(root)) {
|  			ino->flags |= AUTOFS_INF_MOUNTPOINT;
|  			spin_lock(&root->d_lock);
| -			root->d_flags &= ~DCACHE_MOUNTED;
| +			WARN_ON(root->d_mounted == 0);
| +			root->d_mounted--;
|  			spin_unlock(&root->d_lock);
|  		}
|  		ino->flags |= AUTOFS_INF_EXPIRING;
| @@ -536,7 +537,7 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
|  		spin_lock(&sbi->fs_lock);
|  		if (ino->flags & AUTOFS_INF_MOUNTPOINT) {
|  			spin_lock(&sb->s_root->d_lock);
| -			sb->s_root->d_flags |= DCACHE_MOUNTED;
| +			sb->s_root->d_mounted++;
|  			spin_unlock(&sb->s_root->d_lock);
|  			ino->flags &= ~AUTOFS_INF_MOUNTPOINT;
|  		}
| diff --git a/fs/dcache.c b/fs/dcache.c
| index c2a4d2e..89b9d1f 100644
| --- a/fs/dcache.c
| +++ b/fs/dcache.c
| @@ -1187,6 +1187,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
|  	dentry->d_sb = NULL;
|  	dentry->d_op = NULL;
|  	dentry->d_fsdata = NULL;
| +	dentry->d_mounted = 0;
|  	INIT_HLIST_NODE(&dentry->d_hash);
|  	INIT_LIST_HEAD(&dentry->d_lru);
|  	INIT_LIST_HEAD(&dentry->d_subdirs);
| diff --git a/fs/libfs.c b/fs/libfs.c
| index 48fe7c8..98d2717 100644
| --- a/fs/libfs.c
| +++ b/fs/libfs.c
| @@ -265,6 +265,7 @@ int get_sb_pseudo(struct file_system_type *fs_type, char *name,
|  	d_instantiate(dentry, root);
|  	s->s_root = dentry;
|  	s->s_flags |= MS_ACTIVE;
| +	WARN_ON(mnt->mnt_flags & MNT_MOUNTED);
|  	mnt->mnt_flags |= MNT_MOUNTED;
|  	simple_set_mnt(mnt, s);
|  	return 0;
| diff --git a/fs/namespace.c b/fs/namespace.c
| index 6c115d8..64db957 100644
| --- a/fs/namespace.c
| +++ b/fs/namespace.c
| @@ -586,7 +586,8 @@ static void dentry_reset_mounted(struct vfsmount *mnt, struct dentry *dentry)
|  {
|  	if (!__lookup_mnt(mnt, dentry, 0)) {
|  		spin_lock(&dentry->d_lock);
| -		dentry->d_flags &= ~DCACHE_MOUNTED;
| +		WARN_ON(dentry->d_mounted == 0);
| +		dentry->d_mounted--;
|  		spin_unlock(&dentry->d_lock);
|  	}
|  }
| @@ -610,7 +611,7 @@ void mnt_set_mountpoint(struct vfsmount *mnt, struct dentry *dentry,
|  	child_mnt->mnt_parent = mntget(mnt);
|  	spin_lock(&dentry->d_lock);
|  	child_mnt->mnt_mountpoint = dget_dlock(dentry);
| -	dentry->d_flags |= DCACHE_MOUNTED;
| +	dentry->d_mounted++;
|  	spin_unlock(&dentry->d_lock);
|  }
|  
| diff --git a/include/linux/dcache.h b/include/linux/dcache.h
| index 39872ea..bc5a5ff 100644
| --- a/include/linux/dcache.h
| +++ b/include/linux/dcache.h
| @@ -99,6 +99,7 @@ struct dentry {
|  	atomic_t d_count;
|  	unsigned int d_flags;		/* protected by d_lock */
|  	spinlock_t d_lock;		/* per dentry lock */
| +	int d_mounted;
|  	seqcount_t d_seq;		/* per dentry seqlock */
|  	struct inode *d_inode;		/* Where the name belongs to - NULL is
|  					 * negative */
| @@ -364,7 +365,7 @@ extern void dput(struct dentry *);
|  
|  static inline int d_mountpoint(struct dentry *dentry)
|  {
| -	return dentry->d_flags & DCACHE_MOUNTED;
| +	return dentry->d_mounted;
|  }
|  
|  extern struct vfsmount *lookup_mnt(struct path *);
| -- 
| 1.6.0.4
| 
| 
---end quoted text---

-- 
[ Luis Claudio R. Goncalves                    Bass - Gospel - RT ]
[ Fingerprint: 4FDD B8C4 3C59 34BD 8BE9  2696 7203 D980 A448 C8F8 ]

