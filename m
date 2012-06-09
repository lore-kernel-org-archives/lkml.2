Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab2FIHPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 03:15:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40835 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2FIHPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 03:15:19 -0400
Date: Sat, 9 Jun 2012 08:15:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        sds@tycho.nsa.gov, james.l.morris@oracle.com, eparis@parisplace.org
Subject: Re: selinux_inode_setxattr oops.
Message-ID: <20120609071516.GZ30000@ZenIV.linux.org.uk>
References: <20120604215729.GA2531@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604215729.GA2531@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 05:57:29PM -0400, Dave Jones wrote:
> More syscall fuzzing fallout..
> 
> BUG: unable to handle kernel paging request at ffffffffffffffff
> IP: [<ffffffff812cf3f6>] selinux_inode_setxattr+0x196/0x200
> PGD 1c0d067 PUD 1c0e067 PMD 0 
> Oops: 0000 [#1] SMP 
> CPU 0 
> Modules linked in: ipt_ULOG can_raw binfmt_misc bnep cmtp kernelcapi dccp_ipv4 dccp hidp af_802154 phonet bluetooth rfkill can pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose ax25 atm appletalk ipx p8022 psnap llc p8023 nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables btrfs dm_mirror dm_region_hash dm_log zlib_deflate libcrc32c coretemp kvm_intel kvm raid0 ppdev snd_hda_codec_idt dcdbas snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd microcode soundcore pcspkr snd_page_alloc serio_raw i2c_i801 lpc_ich tg3 mfd_core i5000_edac edac_core i5k_amb parport_pc parport shpchp sunrpc firewire_ohci firewire_core crc_itu_t floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
> 
> Pid: 12482, comm: trinity-child0 Not tainted 3.5.0-rc1+ #61 Dell Inc.                 Precision WorkStation 490    /0DT031
> RIP: 0010:[<ffffffff812cf3f6>]  [<ffffffff812cf3f6>] selinux_inode_setxattr+0x196/0x200
> RSP: 0018:ffff8801f8103cd8  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8801f3c68860 RCX: 0000000000000021
> RDX: 0000000000000000 RSI: 0000000000000020 RDI: 0000000000000000
> RBP: ffff8801f8103d58 R08: 0000000000000000 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801f519a480
> R13: ffff88022333d550 R14: ffff8801f7e51720 R15: ffff8801f7e9d0b0
> FS:  00007f1bc4538700(0000) GS:ffff880226600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffff CR3: 00000001d39ee000 CR4: 00000000000007f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process trinity-child0 (pid: 12482, threadinfo ffff8801f8102000, task ffff8801f519a480)
> Stack:
>  ffff8801ffffffea 0000000000000000 0000000000000000 0000071f81021de9
>  ffff8801f8103d28 ffff8801f7e9d10a ffff8801f7e51720 0000000000000000
>  2222222222222222 0000000022222222 2222222222222222 ffff8801f7e51720
> Call Trace:
>  [<ffffffff812c8910>] security_inode_setxattr+0x20/0x30
>  [<ffffffff811e96a1>] vfs_setxattr+0x91/0xd0
>  [<ffffffff811e97d3>] setxattr+0xf3/0x1a0
>  [<ffffffff810cdba5>] ? lock_release_holdtime.part.9+0x15/0x1a0
>  [<ffffffff810938b1>] ? lock_hrtimer_base+0x31/0x60
>  [<ffffffff8106c9fe>] ? do_setitimer+0x18e/0x360
>  [<ffffffff816b6710>] ? _raw_spin_unlock_irq+0x30/0x50
>  [<ffffffff810d397d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
>  [<ffffffff810d3a1d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff816b6710>] ? _raw_spin_unlock_irq+0x30/0x50
>  [<ffffffff811c47f9>] ? fget_light+0x3f9/0x4f0
>  [<ffffffff816bfc15>] ? sysret_check+0x22/0x5d
>  [<ffffffff811e9c3b>] sys_fsetxattr+0xbb/0xf0
>  [<ffffffff816bfbe9>] system_call_fastpath+0x16/0x1b
> Code: 0f 1f 44 00 00 bf 21 00 00 00 89 45 80 e8 63 2f da ff 84 c0 75 5f 48 8b 55 90 48 8b 45 88 be 20 00 00 00 49 8b bc 24 d0 05 00 00 <80> 7c 02 ff 01 49 89 c5 ba 79 05 00 00 49 83 dd 00 e8 b4 77 e2 

	How quaint...  That looks *almost* like the only place in
security_inode_setxattr() where I'd expect an access at that address, but...
it's comparing with the wrong value.  80 7c 02 ff 01 is
	cmpb   $0x1,-0x1(%rdx,%rax,1)
and if not for that last 01 I would've definitely pointed to comparison in

                        /* We strip a nul only if it is at the end, otherwise the
                         * context contains a nul and we should audit that */
                        str = value;
                        if (str[size - 1] == '\0')
                                audit_size = size - 1;
                        else
                                audit_size = size;

but we are comparing with '\1', not '\0'...  Very odd.  Could you post
disassembled security_inode_setxattr() from that kernel?  In any case,
that looks like a bug capable of producing such dereferences, if you
can get there with size == 0.  Look: security_context_to_sid() ends up
doing
        /* Copy the string so that we can modify the copy as we parse it. */
        scontext2 = kmalloc(scontext_len + 1, gfp_flags);
        if (!scontext2)
                return -ENOMEM;
        memcpy(scontext2, scontext, scontext_len);
        scontext2[scontext_len] = 0;
and doesn't dereference scontext ever after.  If the things below that point
end up returning -EINVAL, you'll end up with just that kind of oops.

The question is, can we get there with value == NULL and size == 0?  That
would've meant vfs_setxattr(dentry, name, NULL, 0, flags)... and AFAICS
sys_setxattr() does exactly that if it gets zero as "size" argument.
So this is legitimate.  I wonder why it doesn't trigger all the time,
then...

OK, what we have so far is e.g.
	setxattr(path, name, whatever, 0, XATTR_REPLACE)
with name being good enough to get through xattr_permission().
Then we reach security_inode_setxattr() with the desired value and size.
Aha.  name should begin with "security.selinux", or we won't get that
far in selinux_inode_setxattr().  Suppose we got there and have enough
permissions to relabel that sucker.  We call security_context_to_sid()
with value == NULL, size == 0.  OK, we want ss_initialized to be non-zero.
I.e. after everything had been set up and running.  No problem...

We do 1-byte kmalloc(), zero-length memcpy() (which doesn't oops, even
thought the source is NULL) and put a NUL there.  I.e. form an empty
string.  string_to_context_struct() is called and looks for the first
':' in there.  Not found, -EINVAL we get.  OK, security_context_to_sid_core()
has rc == -EINVAL, force == 0, so it silently returns -EINVAL.  
All it takes now is not having CAP_MAC_ADMIN and we are fucked.

All right, it might be a different bug (modulo strange code quoted in the
report), but it's real.  Easily fixed, AFAICS:

Deal with size == 0, value == NULL case in selinux_inode_setxattr()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 372ec65..65df65f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2792,11 +2792,16 @@ static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 
 			/* We strip a nul only if it is at the end, otherwise the
 			 * context contains a nul and we should audit that */
-			str = value;
-			if (str[size - 1] == '\0')
-				audit_size = size - 1;
-			else
-				audit_size = size;
+			if (value) {
+				str = value;
+				if (str[size - 1] == '\0')
+					audit_size = size - 1;
+				else
+					audit_size = size;
+			} else {
+				str = "";
+				audit_size = 0;
+			}
 			ab = audit_log_start(current->audit_context, GFP_ATOMIC, AUDIT_SELINUX_ERR);
 			audit_log_format(ab, "op=setxattr invalid_context=");
 			audit_log_n_untrustedstring(ab, value, audit_size);
