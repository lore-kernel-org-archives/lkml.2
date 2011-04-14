Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab1DNROz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:14:55 -0400
Received: from mail-03.jhb.wbs.co.za ([196.2.97.2]:4127 "EHLO
	mail-03.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab1DNROv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:14:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0RAIMqp03AqIO6/2dsb2JhbACET5JXjlF4gQ2vD5EygwGBdXgEjW8
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: npiggin@kernel.dk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Regression] 2.6.38 ncpfs
Date: Thu, 14 Apr 2011 19:14:23 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.36.2-desktop-2mnb; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>
References: <201104051858.20304.bonganilinux@mweb.co.za>
In-Reply-To: <201104051858.20304.bonganilinux@mweb.co.za>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_vtypN/HVf9T6l/m"
Message-Id: <201104141914.23529.bonganilinux@mweb.co.za>
X-GeoIP: ZA|South Africa
X-EximConfig: v2.5 on mail.iburst.co.za
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_vtypN/HVf9T6l/m
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit

Hi Rafael, Greg and Linus

I reported a bug in the ncpfs , that causes an oops when you enter a recently 
mounted ncpfs volume. The bug was also reported by Dr. Bernd Feige in January. 
I have attached a patch that makes ncpfs usable again on the 2.6.38 kernel.

The bug is caused by commit fb2d5b86aff355a27ebfc132d3c99f4a940cc3fe, which 
was committed by Nick. Can you please either revert Nick's changes or include 
the attached patch (or a better version, because I'm not that clued up with 
ncpfs).

Regards
Bongani


On Tuesday 05 April 2011 18:58:20 Bongani Hlope wrote:
> Hi Nick
> 
> The following commit fb2d5b86aff355a27ebfc132d3c99f4a940cc3fe causes an
> oops ( when I enter or list a ncpfs mounted volume. The code that you
> replaced in dir.c checked that the d_inode pointer was not null before it
> did a mutex lock.
> 
> For some reason the first time readdir is called for a ncpfs mount point,
> that pointer seems to be null/invalid (check the rest of ncp_fill_cache,
> they always check before using that pointer.). The BUG_ON that checks if
> the mutex is locked causes an Invalid Opcode oops. The attached patch
> fixes it for me, I'm not good with the file system layer, worse ncpfs. Can
> you please apply it to make ncpfs usable again.
> 
> kernel BUG
> at /home/bongani/development/c/kernel/linux-2.6.33/fs/dcache.c:2126!
> invalid opcode: 0000 [#1] PREEMPT SMP
> last sysfs
> file:
> /sys/devices/pci0000:00/0000:00:1f.5/host2/target2:0:0/2:0:0:0/block/sdb/ue
> vent CPU 0
> Modules linked in: ncpfs nls_iso8859_1 nls_cp437 vfat fat uas
> usb_storage fuse vmnet vmblock vsock vmci vmmon af_packet ipv6
> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
> snd_seq_device snd_pcm_oss snd_pcm sg snd_timer snd_mixer_oss snd
> iTCO_wdt iTCO_vendor_support serio_raw sr_mod soundcore snd_page_alloc
> r8169 mii i2c_i801 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
> binfmt_misc cpufreq_ondemand cpufreq_conservative cpufreq_powersave
> acpi_cpufreq freq_table mperf nvram evdev button ppdev parport_pc
> parport processor ide_generic pata_jmicron ide_pci_generic ide_gd_mod
> ide_core pata_acpi ata_generic ahci libahci ata_piix libata sd_mod
> scsi_mod crc_t10dif ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd usbhid
> hid usbcore
> 
> Pid: 12199, comm: bash Not tainted 2.6.38 #1 Gigabyte Technology Co.,
> Ltd. EG45M-UD2H/EG45M-UD2H
> RIP: 0010:[<ffffffff8114d19c>]  [<ffffffff8114d19c>]
> dentry_update_name_case+0x6c/0x80
> RSP: 0018:ffff8801b5af99c8  EFLAGS: 00010246
> RAX: 0000000000000001 RBX: ffff8801a81bd9c0 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffff8801b5af9a88 RDI: ffff8801a81bd9c0
> RBP: ffff8801b5af99e8 R08: 0000000000000053 R09: ffff8801a81bd9f8
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88010039c048
> R13: ffff8801b5af9a88 R14: ffff8800b8d170c0 R15: ffff8801a81bd9c0
> FS:  00007f74a48b9700(0000) GS:ffff8800bfc00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f74a3ff2360 CR3: 000000011075c000 CR4: 00000000000406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process bash (pid: 12199, threadinfo ffff8801b5af8000, task
> ffff8801bdf6e440)
> Stack:
>  ffff88010039c048 ffff8801b5af9e58 ffff88010039c048 ffff8801b5af9c08
>  ffff8801b5af9bd8 ffffffffa05ef62f ffff8801b5af9a18 ffffffff8103e4f1
>  ffff8801b5af9a38 ffffffff8114a030 ffff8801b5af9f38 0000000000000000
> Call Trace:
>  [<ffffffffa05ef62f>] ncp_fill_cache+0x1df/0x5a0 [ncpfs]
>  [<ffffffff8103e4f1>] ? get_parent_ip+0x11/0x50
>  [<ffffffff8114a030>] ? filldir+0x0/0xd0
>  [<ffffffff8103e4f1>] ? get_parent_ip+0x11/0x50
>  [<ffffffff8103ea7d>] ? sub_preempt_count+0x9d/0xd0
>  [<ffffffff813b2e1c>] ? _raw_spin_unlock_irqrestore+0x2c/0x60
>  [<ffffffffa05f78b0>] ? ncp_do_request+0x2b0/0x3c0 [ncpfs]
>  [<ffffffff81074520>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff81074520>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffffa05f7ad2>] ? ncp_request2+0x52/0x90 [ncpfs]
>  [<ffffffffa05efad7>] ncp_read_volume_list+0xe7/0x120 [ncpfs]
>  [<ffffffff8114a030>] ? filldir+0x0/0xd0
>  [<ffffffff810e8bd6>] ? find_lock_page+0x26/0x80
>  [<ffffffff81030000>] ? untrack_pfn_vma+0x0/0x70
>  [<ffffffffa05f0150>] ncp_readdir+0x310/0x750 [ncpfs]
>  [<ffffffff8114a030>] ? filldir+0x0/0xd0
>  [<ffffffff8114a030>] ? filldir+0x0/0xd0
>  [<ffffffff8114a268>] vfs_readdir+0xb8/0xe0
>  [<ffffffff8114a3f5>] sys_getdents+0x85/0xf0
>  [<ffffffff813b3815>] ? page_fault+0x25/0x30
>  [<ffffffff81002fd2>] system_call_fastpath+0x16/0x1b
> Code: 04 48 8b 7b 28 41 8b 55 04 49 8b 75 08 e8 cd 79 0b 00 ff 43 04 4c
> 89 e7 e8 22 5c 26 00 48 8b 5d e8 4c 8b 65 f0 4c 8b 6d f8 c9 c3 <0f> 0b
> eb fe 0f 0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 55
> RIP  [<ffffffff8114d19c>] dentry_update_name_case+0x6c/0x80
>  RSP <ffff8801b5af99c8>
> 
> decodecode < ncpfs-oops2.txt
> 
> 
> Code: 04 48 8b 7b 28 41 8b 55 04 49 8b 75 08 e8 cd 79 0b 00 ff 43 04 4c 89
> e7 e8 22 5c 26 00 48 8b 5d e8 4c 8b 65 f0 4c 8b 6d f8 c9 c3 <0f> 0b eb fe
> 0f 0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 55
> 
> All code
> 
> ========
> 
>    0:   04 48                   add    $0x48,%al
>    2:   8b 7b 28                mov    0x28(%rbx),%edi
>    5:   41 8b 55 04             mov    0x4(%r13),%edx
>    9:   49 8b 75 08             mov    0x8(%r13),%rsi
>    d:   e8 cd 79 0b 00          callq  0xb79df
>   12:   ff 43 04                incl   0x4(%rbx)
>   15:   4c 89 e7                mov    %r12,%rdi
>   18:   e8 22 5c 26 00          callq  0x265c3f
>   1d:   48 8b 5d e8             mov    -0x18(%rbp),%rbx
>   21:   4c 8b 65 f0             mov    -0x10(%rbp),%r12
>   25:   4c 8b 6d f8             mov    -0x8(%rbp),%r13
>   29:   c9                      leaveq
>   2a:   c3                      retq
>   2b:*  0f 0b                   ud2a        <-- trapping instruction
>   2d:   eb fe                   jmp    0x2d
>   2f:*  0f 0b                   ud2a        <-- trapping instruction
>   31:   eb fe                   jmp    0x31
>   33:   66 66 66 2e 0f 1f 84    data32 data32 nopw %cs:0x0(%rax,%rax,1)
>   3a:   00 00 00 00 00
>   3f:   55                      push   %rbp
> 
> Code starting with the faulting instruction
> ===========================================
> 
>    0:   0f 0b                   ud2a
>    2:   eb fe                   jmp    0x2
>    4:   0f 0b                   ud2a
>    6:   eb fe                   jmp    0x6
>    8:   66 66 66 2e 0f 1f 84    data32 data32 nopw %cs:0x0(%rax,%rax,1)
>    f:   00 00 00 00 00
>   14:   55                      push   %rbp
> 
> gdb gives me this:
> 
> 
> (gdb) l *0xffffffff8114d19c
> 
> 0xffffffff8114d19c is in dentry_update_name_case
> (/home/bongani/development/c/kernel/linux-2.6.33/fs/dcache.c:2126).
> 
> 2121     * Parent inode i_mutex must be held over d_lookup and into this
> call (to
> 2122     * keep renames and concurrent inserts, and readdir(2) away).
> 2123     */
> 2124    void dentry_update_name_case(struct dentry *dentry, struct qstr
> *name) 2125    {
> 2126            BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
> 2127            BUG_ON(dentry->d_name.len != name->len); /* d_lookup gives
> this */
> 2128
> 2129            spin_lock(&dentry->d_lock);
> 2130            write_seqcount_begin(&dentry->d_seq);

--Boundary-00=_vtypN/HVf9T6l/m
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ncpfs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ncpfs.patch"

--- linux-2.6.33/fs/dcache.c.org	2011-04-04 08:20:20.382107296 +0200
+++ linux-2.6.33/fs/dcache.c	2011-04-04 09:05:40.182805269 +0200
@@ -2123,7 +2123,6 @@
  */
 void dentry_update_name_case(struct dentry *dentry, struct qstr *name)
 {
-	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
 	BUG_ON(dentry->d_name.len != name->len); /* d_lookup gives this */
 
 	spin_lock(&dentry->d_lock);
--- linux-2.6.33/fs/ncpfs/dir.c.org	2011-04-04 08:16:21.812659616 +0200
+++ linux-2.6.33/fs/ncpfs/dir.c	2011-04-04 09:52:18.822549265 +0200
@@ -583,6 +583,7 @@
 	struct qstr qname;
 	int valid = 0;
 	int hashed = 0;
+	int wasLocked = 1;
 	ino_t ino = 0;
 	__u8 __name[NCP_MAXPATHLEN + 1];
 
@@ -620,7 +621,23 @@
 		 * server. Parent dir's i_mutex is locked because we're in
 		 * readdir.
 		 */
+
+		struct inode *inode = dentry->d_inode;
+
+		if(inode) {
+			if(!mutex_is_locked(&dentry->d_inode->i_mutex)) {
+				mutex_lock(&inode->i_mutex);
+				wasLocked = 0;
+			}
+		}
+		
 		dentry_update_name_case(newdent, &qname);
+
+		if(inode) {
+			if(!wasLocked) {
+				mutex_unlock(&inode->i_mutex);
+			}
+		}
 	}
 
 	if (!newdent->d_inode) {

--Boundary-00=_vtypN/HVf9T6l/m--
