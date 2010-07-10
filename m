Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab0GJGdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 02:33:07 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56263 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315Ab0GJGdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 02:33:05 -0400
X-Sasl-enc: gZ5dm/u540oeGoxsKeUlTINqzQrRcGk7kuILhQSFqQys 1278743581
Message-ID: <4C381411.4040505@fastmail.com.au>
Date: Sat, 10 Jul 2010 16:32:49 +1000
From: A D <amd1234@fastmail.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: johnstul@us.ibm.com, nando@ccrma.Stanford.EDU,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.33.5 rt23: machine lockup (nfs/autofs related?)
References: <f4357-SJ-15@gated-at.bofh.it> <f47V8-84x-17@gated-at.bofh.it> <f484O-8hq-5@gated-at.bofh.it> <f48o9-rG-1@gated-at.bofh.it>
In-Reply-To: <f48o9-rG-1@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/10 09:10, john stultz wrote:
> On Thu, 2010-07-08 at 15:44 -0700, Fernando Lopez-Lezcano wrote:
>> On Thu, 2010-07-08 at 15:33 -0700, john stultz wrote:
>>> On Thu, 2010-07-08 at 10:19 -0700, Fernando Lopez-Lezcano wrote:
>>>> We are having problems with 2.6.33.5+rt23, at least in our configuration
>>>> while accessing an nfs automounted directory. This causes a complete
>>>> machine lockup (press reset to exit as the only option).

I replied to this yesterday., then realized that it was a one-way news 
group of lkml.
Let's see if I can fudge a threaded reply.
================================================

I also have some nfs issues with this combo, but not as severe.
Maybe my fstab mount options help:
     noauto,users,rsize=4096,wsize=4096,timeo=14,intr,hard

Anyway, Fedora 13,both vanilla 2.6.33.5 and Redhat patched, exhibit it 
as a kernel fault upon user mounting a nfs partition.  It is the 
uniprocessor variant kernel (not PAE).  I get an operating nfs 
connection, but the kernel auto bug reporting thingy (abrt) pops up 
shortly after the mount.  I was going to work through a few variations 
on kernels etc before trying bugzilla but I've acquired a bug of the 
non-computer variety and won't feel up to this for a week or so.

WARNING: at fs/namespace.c:1203 umount_tree+0xd8/0x118()
Hardware name: VT8366-8233A
Modules linked in: nfs fuse nfsd lockd nfs_acl auth_rpcgss exportfs 
sunrpc ipv6 binfmt_misc snd_via82xx snd_ac97_codec ac97_bus snd_seq 
snd_pcm snd_timer snd_page_alloc snd_mpu401_uart 8250_pnp snd_rawmidi 
8250 snd_seq_device pcspkr i2c_viapro snd serial_core parport_pc 8139too 
i2c_core fan thermal 8139cp soundcore mii firewire_ohci uhci_hcd floppy 
firewire_core [last unloaded: freq_table]
Pid: 2842, comm: mount.nfs Not tainted 2.6.33.5-rt23.fc13.i686 #1
Call Trace:
[<c0434f84>] warn_slowpath_common+0x6a/0x81
[<c04d281a>] ? umount_tree+0xd8/0x118
[<c0434fad>] warn_slowpath_null+0x12/0x15
[<c04d281a>] umount_tree+0xd8/0x118
[<c04d3084>] put_mnt_ns+0x80/0xa4
[<c04c8339>] ? vfs_path_lookup+0x8a/0x99
[<f89e58d2>] nfs_follow_remote_path+0x46/0xec [nfs]
[<f89e587c>] ? nfs_do_root_mount+0x61/0x71 [nfs]
[<f89e5a65>] nfs4_try_mount+0x61/0x94 [nfs]
[<f89e6bc8>] nfs_get_sb+0x61d/0x815 [nfs]
[<c04ba568>] ? pcpu_alloc+0x6bb/0x6d0
[<c070cd77>] ? rt_spin_unlock+0xd/0xf
[<c04a3da5>] ? kstrdup+0x2f/0x3f
[<c04a3da5>] ? kstrdup+0x2f/0x3f
[<c04c11f7>] vfs_kern_mount+0x86/0x11f
[<c04c12db>] do_kern_mount+0x34/0xb4
[<c04d44e1>] do_mount+0x67f/0x6de
[<c04d26a2>] ? copy_mount_options+0x78/0xd7
[<c04d45a6>] sys_mount+0x66/0x94
[<c040329f>] sysenter_do_call+0x12/0x28

If you want to follow up via email bump the user digits by one place to 
the right.
